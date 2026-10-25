# SECU0045 dissertation - reproducible descriptive extraction of selected H1 2026
# Digital Services Act transparency-report metrics.
#
# Author: Naisya Permana
#
# Purpose
# -------
# Reproduce the selected H1 2026 moderation figures reported in Table 3 of the
# dissertation. This script performs descriptive extraction only. It does not
# treat moderation measures as offences, victims, unique incidents, or evidence
# of causal crime reduction.
#
# Expected source files in --root
# -------------------------------
# 1. Instagram_DSA_Transparency_H1_2026.zip
# 2. TikTok_DSA_Transparency_H1_2026.zip
# 3. YouTube_DSA_Transparency_H1_2026.zip
# 4. Snapchat_DSA_Transparency_H1_2026.xlsx
#
# Usage
# -----
# Easiest: keep the source packages in repository-root data/, open this script in RStudio,
# and click Source. The script automatically reads the bundled data/ folder
# and writes results/SECU0045_selected_H1_2026_metrics_reproduced.csv in the repository.
#
# Command-line use is also supported:
# Rscript scripts/Naisya_Permana_SECU0045_Analysis_Code.R
#
# The importer tolerates provider CSV rows with omitted trailing fields and
# preserves those omissions as missing values.
#
# Dependencies
# ------------
# readr; readxl; dplyr; tibble
# --root and --out accept absolute paths or paths relative to repository root.

required_packages <- c("readr", "readxl", "dplyr", "tibble")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Missing required R package(s): ",
    paste(missing_packages, collapse = ", "),
    ". Install them before running the script."
  )
}

# Locate this script so it can find the bundled data/ folder even when
# the script is run from RStudio with a different working directory.
get_script_dir <- function() {
  full_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", full_args, value = TRUE)

  if (length(file_arg) > 0) {
    script_path <- sub("^--file=", "", file_arg[[1]])
    return(dirname(normalizePath(script_path, winslash = "/", mustWork = TRUE)))
  }

  frames <- sys.frames()
  for (i in rev(seq_along(frames))) {
    ofile <- frames[[i]]$ofile
    if (!is.null(ofile)) {
      return(dirname(normalizePath(ofile, winslash = "/", mustWork = TRUE)))
    }
  }

  getwd()
}

script_dir <- get_script_dir()
repo_dir <- dirname(script_dir)  # scripts/ is one level below repository root

source_files <- c(
  Instagram = "Instagram_DSA_Transparency_H1_2026.zip",
  TikTok = "TikTok_DSA_Transparency_H1_2026.zip",
  YouTube = "YouTube_DSA_Transparency_H1_2026.zip",
  Snapchat = "Snapchat_DSA_Transparency_H1_2026.xlsx"
)

category_col <- "Category of incompatibility with the provider's terms and conditions"
other_col <- 'Description of the sub-category "Other"'

target_columns <- c(
  own_initiative = "Number of measures taken at the provider's own initiative",
  solely_automated = "Number of measures taken after detection with solely automated means",
  removal = "Visibility restriction Removal",
  age_restricted = "Visibility restriction Age restricted",
  service_termination = "Provision of the service Termination",
  account_termination = "Account restriction Termination"
)

normalise_headers <- function(df) {
  names(df) <- trimws(names(df))
  df
}

as_number <- function(value) {
  if (length(value) == 0 || is.na(value)) {
    return(NA_real_)
  }

  if (is.character(value)) {
    value <- trimws(gsub(",", "", value, fixed = TRUE))
    if (!nzchar(value)) {
      return(NA_real_)
    }
  }

  result <- suppressWarnings(as.numeric(value))
  if (is.na(result)) NA_real_ else result
}

read_harmonised_csv_from_zip <- function(zip_path) {
  zip_listing <- utils::unzip(zip_path, list = TRUE)

  candidates <- zip_listing$Name[
    endsWith(zip_listing$Name, "6_own_initiative_TC.csv") &
      !endsWith(zip_listing$Name, "6_own_initiative_TC_Ads.csv")
  ]

  if (length(candidates) != 1) {
    stop(
      "Expected exactly one 6_own_initiative_TC.csv in ",
      basename(zip_path),
      "; found ", length(candidates),
      ": ", paste(candidates, collapse = ", ")
    )
  }

  temp_dir <- tempfile("secu0045_zip_")
  dir.create(temp_dir, recursive = TRUE)
  on.exit(unlink(temp_dir, recursive = TRUE, force = TRUE), add = TRUE)

  utils::unzip(
    zip_path,
    files = candidates,
    exdir = temp_dir,
    junkpaths = TRUE
  )

  csv_path <- file.path(temp_dir, basename(candidates))

  # Some provider files, particularly YouTube, contain sparse rows in which
  # unused trailing fields are omitted. Base R's CSV reader with fill = TRUE
  # treats those omitted fields as missing values rather than reporting them
  # as parsing problems.
  df <- utils::read.csv(
    csv_path,
    header = TRUE,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    fill = TRUE,
    na.strings = c("", "NA")
  )

  normalise_headers(df)
}

load_platform <- function(platform, root) {
  if (!platform %in% names(source_files)) {
    stop("Unknown platform: ", platform)
  }

  path <- file.path(root, source_files[[platform]])

  if (!file.exists(path)) {
    stop("Missing source file for ", platform, ": ", path)
  }

  if (platform == "Snapchat") {
    df <- readxl::read_excel(path, sheet = "6_own_initiative_TC")
    return(normalise_headers(df))
  }

  read_harmonised_csv_from_zip(path)
}

select_exact <- function(df, category, other = NA_character_) {
  if (!category_col %in% names(df)) {
    stop("Required category column is missing: ", category_col)
  }

  mask <- as.character(df[[category_col]]) == category

  if (!is.na(other)) {
    if (!other_col %in% names(df)) {
      stop("Required 'Other' description column is missing: ", other_col)
    }
    mask <- mask & as.character(df[[other_col]]) == other
  }

  rows <- df[which(mask %in% TRUE), , drop = FALSE]

  if (nrow(rows) != 1) {
    stop(
      "Expected one row for category=", shQuote(category),
      ", other=", ifelse(is.na(other), "NULL", shQuote(other)),
      "; found ", nrow(rows)
    )
  }

  rows[1, , drop = FALSE]
}

summarise_row <- function(platform, label, row) {
  values <- lapply(target_columns, function(column_name) {
    if (column_name %in% names(row)) {
      as_number(row[[column_name]][1])
    } else {
      NA_real_
    }
  })

  tibble::tibble(
    platform = platform,
    reported_category = label,
    own_initiative = values[["own_initiative"]],
    solely_automated = values[["solely_automated"]],
    removal = values[["removal"]],
    age_restricted = values[["age_restricted"]],
    service_termination = values[["service_termination"]],
    account_termination = values[["account_termination"]]
  )
}

build_summary <- function(root) {
  specifications <- tibble::tribble(
    ~platform,   ~label,                                      ~category,                                          ~other,
    "Instagram", "Scams and fraud",                          "STATEMENT_CATEGORY_SCAMS_AND_FRAUD",               NA_character_,
    "Instagram", "Unsafe and prohibited products",           "STATEMENT_CATEGORY_UNSAFE_AND_PROHIBITED_PRODUCTS", NA_character_,
    "Instagram", "Child sexual abuse material",              "KEYWORD_CHILD_SEXUAL_ABUSE_MATERIAL",             NA_character_,

    "TikTok",    "Scams and fraud",                          "STATEMENT_CATEGORY_SCAMS_AND_FRAUD",               NA_character_,
    "TikTok",    "Unsafe and prohibited products",           "STATEMENT_CATEGORY_UNSAFE_AND_PROHIBITED_PRODUCTS", NA_character_,
    "TikTok",    "Child sexual abuse material",              "KEYWORD_CHILD_SEXUAL_ABUSE_MATERIAL",             NA_character_,

    "YouTube",   "Scams and fraud",                          "STATEMENT_CATEGORY_SCAMS_AND_FRAUD",               NA_character_,
    "YouTube",   "Unsafe and prohibited products",           "STATEMENT_CATEGORY_UNSAFE_AND_PROHIBITED_PRODUCTS", NA_character_,
    "YouTube",   "Child sexual abuse material",              "KEYWORD_CHILD_SEXUAL_ABUSE_MATERIAL",             NA_character_,
    # Kept separate rather than relabelled as CSAM.
    "YouTube",   "Provider-specific CHILD_SAFETY",           "KEYWORD_OTHER",                                    "CHILD_SAFETY",

    "Snapchat",  "Scams and fraud",                          "STATEMENT_CATEGORY_SCAMS_AND_FRAUD",               NA_character_,
    "Snapchat",  "Unsafe and prohibited products",           "STATEMENT_CATEGORY_UNSAFE_AND_PROHIBITED_PRODUCTS", NA_character_,
    "Snapchat",  "Child sexual abuse material",              "KEYWORD_CHILD_SEXUAL_ABUSE_MATERIAL",             NA_character_,
    "Snapchat",  "Grooming / sexual enticement of minors",   "KEYWORD_GROOMING_SEXUAL_ENTICEMENT_MINORS",       NA_character_,
    "Snapchat",  "Protection of minors (total)",             "STATEMENT_CATEGORY_PROTECTION_OF_MINORS",          NA_character_
  )

  datasets <- new.env(parent = emptyenv())
  output_rows <- vector("list", nrow(specifications))

  for (i in seq_len(nrow(specifications))) {
    platform <- specifications$platform[[i]]

    if (!exists(platform, envir = datasets, inherits = FALSE)) {
      assign(platform, load_platform(platform, root), envir = datasets)
    }

    df <- get(platform, envir = datasets, inherits = FALSE)

    selected <- select_exact(
      df,
      category = specifications$category[[i]],
      other = specifications$other[[i]]
    )

    output_rows[[i]] <- summarise_row(
      platform,
      specifications$label[[i]],
      selected
    )
  }

  dplyr::bind_rows(output_rows)
}

parse_args <- function(args) {
  result <- list(
    root = "data",
    out = "results/SECU0045_selected_H1_2026_metrics_reproduced.csv"
  )

  i <- 1
  while (i <= length(args)) {
    if (args[[i]] == "--root") {
      if (i == length(args)) stop("--root requires a value")
      result$root <- args[[i + 1]]
      i <- i + 2
    } else if (args[[i]] == "--out") {
      if (i == length(args)) stop("--out requires a value")
      result$out <- args[[i + 1]]
      i <- i + 2
    } else {
      stop("Unknown argument: ", args[[i]])
    }
  }

  result
}

main <- function() {
  args <- parse_args(commandArgs(trailingOnly = TRUE))

  is_absolute <- function(path) {
    grepl("^([A-Za-z]:[/\\\\]|/|~)", path)
  }

  root_arg <- if (is_absolute(args$root)) args$root else file.path(repo_dir, args$root)
  out_arg <- if (is_absolute(args$out)) args$out else file.path(repo_dir, args$out)

  root <- normalizePath(root_arg, winslash = "/", mustWork = TRUE)
  summary <- build_summary(root)

  out_dir <- dirname(out_arg)
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  }

  readr::write_csv(summary, out_arg, na = "")

  print(summary, n = Inf)
  cat("\nSaved descriptive summary to: ", normalizePath(out_arg, winslash = "/", mustWork = FALSE), "\n", sep = "")
}

if (sys.nframe() == 0) {
  main()
}
