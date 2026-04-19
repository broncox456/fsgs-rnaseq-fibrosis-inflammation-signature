# FSGS RNA-seq – Fibrosis Progression Signature

Can transcriptomic patterns reveal biologically meaningful subgroups and fibrosis-related signals in FSGS?

![FSGS results](results/figures/top_genes_final.png)

---

## Project Overview

This project explores transcriptomic heterogeneity in focal segmental glomerulosclerosis (FSGS) using RNA-seq data, with emphasis on fibrosis-related and inflammatory biological signals.

The analysis was designed to identify molecular subgroups, characterize differential expression patterns, and evaluate whether transcriptomic signatures reveal disease biology beyond routine clinical variables.

---

## Key Findings

- Two main transcriptomic patient clusters were identified, suggesting biological heterogeneity within FSGS
- Fibrosis-related and inflammatory pathways were consistently enriched across subgroup comparisons
- Differential expression analysis highlighted genes linked to extracellular matrix remodeling, immune activation, and disease progression
- The results support the idea that FSGS is a biologically heterogeneous disease not fully captured by conventional clinical descriptors

---

## Clinical Context

Focal segmental glomerulosclerosis (FSGS) is a heterogeneous glomerular disease with variable progression, treatment response, and long-term renal outcomes.

Traditional clinical parameters often fail to fully explain this variability. Transcriptomic analysis provides an opportunity to identify molecular patterns associated with fibrosis, inflammation, and subgroup-specific disease behavior.

---

## Data Source

Main project inputs:

- Expression matrix: `data/processed/fsgs_counts_final.csv`
- Metadata: `data/metadata/fsgs_metadata_final.csv`

Raw inputs include:

- `data/raw/GSE254957_NEPTUNE_GSE197307_UpdatedCountData.txt.gz`
- `data/raw/GSE254957_updatedMatrix.txt.gz`

This analysis is based on curated RNA-seq data and corresponding metadata derived from public nephrology-related transcriptomic resources.

---

## Study Design

- RNA-seq cohort curation and metadata harmonization
- Expression matrix preprocessing
- Removal of zero-variance genes
- Principal component analysis (PCA)
- Unsupervised patient clustering
- Differential expression analysis with DESeq2
- Functional enrichment analysis using GO and KEGG
- Signature-oriented visualization of fibrosis and inflammation patterns

---

## Methods

### Analytical Strategy

The workflow prioritized interpretability and biological relevance:

- direct use of curated count matrix and metadata
- variance filtering after detecting PCA instability
- dimensionality reduction with PCA
- unsupervised clustering to identify transcriptomic subgroups
- differential expression analysis to characterize molecular differences
- functional enrichment analysis to interpret biological pathways
- signature-level visualization focused on fibrosis and inflammation

### Pipeline Steps

1. Load raw and processed expression inputs
2. Curate metadata and define the final analysis cohort
3. Preprocess count data
4. Remove zero-variance genes
5. Perform PCA
6. Identify transcriptomic patient clusters
7. Run differential expression analysis
8. Perform GO and KEGG enrichment analysis
9. Generate fibrosis/inflammation signature outputs
10. Produce publication-style visualizations and final summary tables

---

## Results

### Patient Clustering

Two major transcriptomic clusters were identified:

- Cluster 1: 11 samples
- Cluster 2: 90 samples

The presence of a smaller cluster suggests a biologically distinct subgroup that may reflect a more aggressive or differentiated transcriptomic phenotype.

### Differential Expression

The project generated:

- full differential expression results: `results/differential_expression/deseq2_results_full.csv`
- significant genes: `results/differential_expression/deseq2_results_significant.csv`
- final ranked genes: `results/tables/top_genes_final.csv`

These outputs support the presence of subgroup-specific molecular differences.

### Biological Signals

The dominant biological patterns were:

#### Fibrosis-related activity
- extracellular matrix remodeling
- structural tissue response
- increased expression of fibrosis-associated genes

#### Inflammatory signaling
- immune pathway activation
- inflammatory contribution to progression
- transcriptomic evidence of biologically active disease heterogeneity

### Key Visual Outputs

- PCA plot: `results/figures/pca_plot.png`
- Patient clustering PCA: `results/figures/patient_clustering_pca.png`
- Volcano plot: `results/figures/volcano_plot.png`
- Signature heatmap: `results/figures/signature_heatmap.png`
- GO dotplot: `results/figures/go_dotplot.png`
- KEGG dotplot: `results/figures/kegg_dotplot.png`
- Top genes figure: `results/figures/top_genes_final.png`

---

## Interpretation

This project supports the concept that FSGS is not a uniform disease entity.

Instead, transcriptomic profiling reveals biologically meaningful subgroup structure, with differential activation of fibrosis-related and inflammatory pathways. These findings suggest that molecular stratification may improve disease interpretation beyond standard clinical descriptors alone.

---

## Limitations

- moderate sample size
- no external validation cohort
- no direct integration with longitudinal renal outcomes
- transcriptomic findings remain hypothesis-generating in the absence of independent validation

---

## Why This Matters

This project demonstrates that RNA-seq analysis can be used to:

- identify biologically meaningful FSGS subgroups
- characterize fibrosis and inflammation-related molecular programs
- generate clinically relevant hypotheses for precision nephrology
- move from descriptive disease labels toward molecularly informed interpretation

---

## Project Structure

```text
.
├── data/
│   ├── raw/
│   ├── metadata/
│   └── processed/
├── docs/
├── results/
│   ├── differential_expression/
│   ├── enrichment/
│   ├── figures/
│   └── tables/
├── scripts/
│   ├── 00_setup.R
│   ├── 01_data_import.R
│   ├── 02_metadata_extraction.R
│   ├── 03_build_fsgs_cohort.R
│   ├── 04_deseq2_analysis.R
│   ├── 05_clustering.R
│   ├── 06_enrichment_analysis.R
│   ├── 07_signature_gene_panels.R
│   ├── 08_signature_heatmap.R
│   └── 09_signature_scores.R
└── README.md

## Reproducibility : 

-Requirements

This project was developed in R using transcriptomic analysis packages including DESeq2 and enrichment analysis tools.

Install required packages in R before running the workflow.

## Execution Order

Run scripts in this order:

-source("scripts/00_setup.R")
-source("scripts/01_data_import.R")
-source("scripts/02_metadata_extraction.R")
-source("scripts/03_build_fsgs_cohort.R")
-source("scripts/04_deseq2_analysis.R")
-source("scripts/05_clustering.R")
-source("scripts/06_enrichment_analysis.R")
-source("scripts/07_signature_gene_panels.R")
-source("scripts/08_signature_heatmap.R")
-source("scripts/09_signature_scores.R")

## Main outputs : 

-clustering results: results/tables/patient_clustering_results.csv
-signature scores: results/tables/patient_signature_scores.csv
-top genes table: results/tables/top_genes_final.csv
-significant DE genes: results/differential_expression/deseq2_results_significant.csv
-enrichment results: results/enrichment/go_results.csv, results/enrichment/kegg_results.csv

## Author

Cristian Arias, MD
Internal Medicine & Nephrology
Healthcare Data Analyst
Bioinformatics Master's Candidate

Focused on clinical data analysis and translational applications in kidney disease.