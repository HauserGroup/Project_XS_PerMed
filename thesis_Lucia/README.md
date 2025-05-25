# WGS burden testing framework using UK Biobank data

## Overview

This repository contains a custom pipeline developed for **whole-genome sequencing (WGS)** based **burden testing** of the **OPRM1** gene using the **UK Biobank Research Analysis Platform (RAP)**. The pipeline is optimized for identifying functional variants in the OPRM1 gene and associating them with opioid-related phenotypes using **REGENIE**, **Hail**, and **PLINK2**. While this implementation is focused on OPRM1, the framework is adaptable to other genes or gene sets and drugs by modifying the target genomic intervals, variant annotation filters, mask and phenotypes definitions accordingly.

Inspired by the https://github.com/HauserGroup/gogoGPCR2 framework.


## Step-by-Step Workflow

### Step 1: Sample and variant quality control

From https://github.com/HauserGroup/gogoGPCR2/tree/main/notebooks/WGS run in order:

1. `01_QC_Samples_PCs.ipynb`: Generate genetic PCs (Field 22009)
2. `01_QC_Samples_Ancestry.ipynb`: Assign ancestry (uses [UKBB-PGS](https://github.com/privefl/UKBB-PGS))
3. `01_QC_Samples.ipynb`: Filter samples (relatedness, low call rate, outliers)

### Step 2: Covariates

Run:

- `covariates.ipynb`: Generates REGENIE-compatible covariates: FID, IID, sex, age, age², age×sex, age²×sex, PC1–PC20  
  - Adds disease-specific indicators (e.g., musculoskeletal ICD-10 M-codes)

### Step 3: Variant filtering and annotation

Run:

- `QC_WGS.ipynb`:  Perform quality control on variants of specific set of genes. It also performs Variant Effect Predictor (VEP). Quality control is based on sequencing parameters (call rate, quality, etc.) and functional annotation from VEP. 


### Step 4: Phenotypes definition

Run the following notebooks:

- `phenotypes_definition/phenotypes_BT.ipynb`: opioid switching or co-exposure
- `phenotypes_definition/phenotypes_QT.ipynb`: Usage intensity and adherence
- `phenotypes_definition/phenotypes_survival_analysis.ipynb`: Time to stop use or psychiatric diagnosis

Phenotypes are formatted for REGENIE:
- Binary/Quantitative: `FID IID PHENOTYPE`
- Time-to-event: `FID IID TIME EVENT`

### Step 5: Association analysis with REGENIE

- Define Masks of interest
- Run scripts `1_regenie_step1_().sh` and `2_regenie_step2_().sh` 
()= BT,QT or survival



---

## Exploratory Data Analysis (EDA)

The `notebooks/eda/` folder contains supplementary notebooks used to explore and visualize the relationships between genetic variants and prescription patterns, as well as to support phenotype definition and mask construction. These analyses are not strictly required for REGENIE but provide essential context. 
These notebooks are helpful for:
- Validating prescription mappings (OMOP-CDM and ATC codes)
- Visualizing variant–drug overlaps (heatmaps)
- Selecting ICD-10-based disease subgroups (e.g., musculoskeletal)
- Supplementing the construction of binary, quantitative, and survival phenotypes
