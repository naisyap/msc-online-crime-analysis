
# Online Platform Responses to Crime Risks

**MSc Dissertation Research | University College London | 2026**

## Overview

This project examines how four major social media platforms—**Instagram, TikTok, YouTube, and Snapchat**—publicly report their responses to online crime risks.

The research focuses on three crime categories:
- Scams and fraud
- Illicit drugs and regulated goods
- Child sexual abuse material and child sexual exploitation (CSAM/CSEA)

The wider dissertation combines comparative qualitative analysis of platform policies, risk assessments, and EU Digital Services Act (DSA) reports with quantitative data processing using **R**.

This GitHub repository showcases the R analysis code, selected datasets, and key research insights rather than the full dissertation.

## Research Objectives

- Examine how major online platforms identify and address different online crime risks.
- Analyse publicly reported moderation measures and preventive interventions.
- Process and compare selected DSA transparency-report statistics.
- Identify limitations in platform reporting and the interpretation of moderation data.

## Tools and Technologies

**Programming Language:** R

**R Packages:**
- readr
- readxl
- dplyr
- tibble

**Analytical Techniques:**
- Data cleaning and preprocessing
- Data extraction and transformation
- Descriptive statistical analysis
- Data validation and quality checks
- Comparative document analysis
- Missing data handling

## What the Code Does

The R script processes selected moderation statistics from the January–June 2026 DSA transparency reports.

The workflow:

1. Imports harmonised transparency-report tables from three ZIP packages and one Excel workbook.
2. Standardises column headers and extracts specified moderation categories.
3. Converts numerical fields into a consistent format.
4. Preserves missing observations rather than replacing them with zero.
5. Validates category matching to prevent incorrect data extraction.
6. Exports selected descriptive statistics to a CSV file.

The analysis preserves differences in platform reporting categories to avoid misleading comparisons.

## Repository Structure

```text
msc-online-crime-analysis/
|
|-- scripts/
|   |-- Naisya_Permana_SECU0045_Analysis_Code.R
|
|-- results/
|   |-- SECU0045_selected_H1_2026_metrics.csv
|   |-- SECU0045_selected_H1_2026_metrics_reproduced.csv
|
|-- README.md
|-- SOURCE_MANIFEST.txt
```

**File descriptions:**

- **scripts/** — R code used to process and extract transparency-report statistics.
- **results/** — Original and reproduced analytical outputs.
- **SOURCE_MANIFEST.txt** — Details of the original source datasets.
- **README.md** — Research overview, methodology, findings, and reproduction instructions.

## Data Sources

The analysis uses publicly available transparency-report data from four major online platforms, covering **1 January–30 June 2026**.

The original source files are:

- Instagram_DSA_Transparency_H1_2026.zip
- TikTok_DSA_Transparency_H1_2026.zip
- YouTube_DSA_Transparency_H1_2026.zip
- Snapchat_DSA_Transparency_H1_2026.xlsx

These files contain provider-reported moderation statistics published under the EU Digital Services Act.

The original source packages are not included in this repository. They must be obtained separately to reproduce the analysis.

See `SOURCE_MANIFEST.txt` for the source-file list.

## Key Research Insights

### 1. Multiple Crime Prevention Mechanisms

Online platforms report different approaches to addressing crime risks, including automated detection, content restrictions, account enforcement, reporting mechanisms, and preventive measures.

Content removal alone does not fully represent the range of interventions reported by platforms.

### 2. Differences in Platform Reporting

The platforms use different reporting categories and definitions, which limits direct comparisons between their moderation statistics.

Reported figures should therefore be interpreted within each platform's reporting framework.

### 3. Limitations of Moderation Statistics

Reported moderation measures do not necessarily represent the number of crimes committed, victims affected, or unique incidents.

These statistics describe platform enforcement activity and cannot independently establish whether crime prevention measures reduce offending.

## Reproducing the Analysis

### Requirements

- R
- RStudio (recommended)

Install the required R packages if they are not already installed:

```r
install.packages(c("readr", "readxl", "dplyr", "tibble"))
```

### Step 1: Prepare the Source Data

Create a `data/` folder in the repository's main directory.

Place the four original DSA transparency-report files inside this folder.

```text
msc-online-crime-analysis/
|
|-- data/
|   |-- Instagram_DSA_Transparency_H1_2026.zip
|   |-- TikTok_DSA_Transparency_H1_2026.zip
|   |-- YouTube_DSA_Transparency_H1_2026.zip
|   |-- Snapchat_DSA_Transparency_H1_2026.xlsx
|
|-- scripts/
|-- results/
```

The `data/` folder is intended for local source files and does not need to be uploaded to GitHub.

### Step 2: Run the R Script

From the repository's main directory, execute:

```bash
Rscript scripts/Naisya_Permana_SECU0045_Analysis_Code.R
```

Alternatively, open the script in RStudio, click **Source**, and execute `main()` in the Console if necessary.

The script automatically locates the repository directory and processes the source files.

### Step 3: Check the Output

After successful execution, the script generates:

`results/SECU0045_selected_H1_2026_metrics_reproduced.csv`

The output contains **15 records and 8 variables**, including moderation measures relating to fraud, prohibited products, and child safety.

Missing observations remain missing rather than being converted to zero.

## Reproducibility Verification

The R analysis script was successfully executed in RStudio using the original January–June 2026 DSA transparency-report datasets.

The reproduced dataset was compared against the original dissertation analysis output using:

```r
all.equal(original, reproduced)
```

**Verification result: `TRUE`**

This confirmed consistency between the original and reproduced datasets.

The verified output is included in the `results/` directory.

## Limitations

- The analysis relies on publicly reported platform statistics.
- Reporting definitions and categories vary between platforms.
- Moderation measures cannot be interpreted directly as crime prevalence.
- Some reported categories combine multiple types of prohibited activity.
- The analysis is descriptive and does not establish causal relationships between moderation interventions and crime reduction.

## Academic Context

This project was developed as part of an **MSc dissertation at University College London (UCL)** in 2026.

The full dissertation investigates platform responses to online crime risks through comparative documentary analysis and descriptive data processing.

This repository presents selected analytical materials for academic and professional portfolio purposes.
