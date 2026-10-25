# Online Platform Responses to Crime Risks

**MSc dissertation research | University College London | 2026**

## Overview

This project examines publicly reported approaches to online crime risks on **Instagram, TikTok, YouTube and Snapchat**, focusing on **scams and fraud, illicit drugs/regulated goods, and child sexual abuse material or exploitation (CSAM/CSEA)**.

The wider dissertation combines comparative qualitative analysis of platform policies and Digital Services Act (DSA) reports with a **descriptive R-based extraction** of selected moderation metrics from the **January–June 2026** DSA transparency reports. This repository highlights the code and a small reproducibility output, **not the full dissertation**.

## What the code does

- Imports harmonised transparency tables from three provider ZIP packages and a Snapchat Excel workbook.
- Normalises headers and extracts precisely matched category rows.
- Converts reported numeric fields and preserves missing values rather than treating them as zeros.
- Keeps broad prohibited-products categories separate from drug-specific claims, and provider-specific CHILD_SAFETY data separate from CSAM counts.
- Exports selected descriptive metrics to CSV for checking against the source tables.

## Repository contents

- [`scripts/Naisya_Permana_SECU0045_Analysis_Code.R`](scripts/Naisya_Permana_SECU0045_Analysis_Code.R) — R data extraction script, updated for the repository folder layout.
- [`results/SECU0045_selected_H1_2026_metrics.csv`](results/SECU0045_selected_H1_2026_metrics.csv) — selected exported metrics.
- [`SOURCE_MANIFEST.txt`](SOURCE_MANIFEST.txt) — original source-file list.

## Brief insights

- Platforms report a mixture of detection, content restrictions, account/service interventions and preventive measures; content removal alone does not capture the full response.
- DSA moderation metrics use differing categories and reporting units, which limits direct cross-platform comparisons.
- These figures describe **reported moderation activity**, not confirmed crimes or evidence that any intervention reduced offending.

## Reproducing the analysis

Requires R and the packages `readr`, `readxl`, `dplyr` and `tibble`:

```r
install.packages(c("readr", "readxl", "dplyr", "tibble"))
```

Place the following **original provider source packages** in the repository-level `data/` folder (not `scripts/data/`):

- `data/Instagram_DSA_Transparency_H1_2026.zip`
- `data/TikTok_DSA_Transparency_H1_2026.zip`
- `data/YouTube_DSA_Transparency_H1_2026.zip`
- `data/Snapchat_DSA_Transparency_H1_2026.xlsx`

These original files are **not included** in this repository. See `SOURCE_MANIFEST.txt`. The `data/` directory is excluded from Git by `.gitignore`, except its placeholder file.

From any working directory, run the script by its path (for example, from repository root):

```bash
Rscript scripts/Naisya_Permana_SECU0045_Analysis_Code.R
```

Or open the script in RStudio and click **Source**. The script finds the repository root from its own location and outputs:

`results/SECU0045_selected_H1_2026_metrics_reproduced.csv`

Compare this output against `results/SECU0045_selected_H1_2026_metrics.csv`. The generated `_reproduced.csv` file is ignored by Git so reruns do not create unnecessary repository changes.

The script also accepts `--root` and `--out` path overrides. Relative paths are interpreted from the **repository root** (absolute paths also work):

```bash
Rscript scripts/Naisya_Permana_SECU0045_Analysis_Code.R --root data --out results/custom_metrics.csv
```

**Reproducibility status:** File locations and original extraction logic have been reviewed, but a full execution and comparison has **not** been performed because the four provider source packages were not supplied with these uploads. Install the required R packages and supply those files to validate the exported metrics.

## Interpretation and limitations

The exported data are **provider-reported moderation measures**, not numbers of offences, victims, unique incidents or proof of crime reduction. Blank cells are missing values, not automatically zero. Category differences and reporting definitions limit inference about which platform is safer.

*Academic portfolio project; based on an MSc dissertation at UCL.*
