# FSGS RNA-seq – Fibrosis Progression Signature

This project was developed as part of my Bioinformatics Master's training, with a focus on applying transcriptomic analysis to a clinically relevant nephrology problem.

Rather than prioritizing pipeline complexity, the objective was to understand how gene expression patterns reflect key biological processes involved in FSGS, particularly inflammation, fibrosis, and transcriptomic heterogeneity across patients.

## Clinical Context

Focal segmental glomerulosclerosis (FSGS) is a heterogeneous glomerular disease with variable clinical behavior and progression patterns that are not always fully explained by routine clinical parameters.

This analysis explores whether transcriptomic data can capture part of that biological variability and help identify molecular patterns related to fibrosis and inflammatory activity.

## Data

Main project inputs:

- Expression matrix: `data/processed/fsgs_counts_final.csv`
- Metadata: `data/metadata/fsgs_metadata_final.csv`

Additional source and processing files are also included in the repository.

## Analytical Strategy

An initial approach based on precomputed signature scores was considered. However, some intermediate outputs were not consistently available, which limited reproducibility.

For that reason, the workflow was restructured to rely directly on the expression matrix and curated metadata, allowing better control over each analytical step.

### Key technical decisions

- Rebuilt the analysis from the available expression matrix
- Avoided dependence on incomplete intermediate files
- Removed zero-variance genes after detecting PCA instability
- Used PCA for dimensionality reduction before clustering
- Applied unsupervised clustering to explore major transcriptomic patterns
- Evaluated fibrosis- and inflammation-related signals through signature-oriented interpretation
- Performed differential expression and enrichment analysis to characterize cluster-level biological differences

## Workflow

1. Load and validate expression matrix
2. Curate metadata and construct the working cohort
3. Convert expression data into analysis-ready format
4. Remove zero-variance genes
5. Perform PCA for exploratory sample structure analysis
6. Apply patient clustering
7. Evaluate fibrosis and inflammation signatures
8. Generate heatmaps and patient-level signature scores
9. Perform differential expression analysis
10. Perform functional enrichment analysis (GO and KEGG)

## Results

### Patient clustering

Two main transcriptomic clusters were identified:

- Cluster 1: 11 samples
- Cluster 2: 90 samples

The presence of a smaller cluster suggests a subgroup with a distinct molecular profile. This may reflect a more extreme phenotype or a biologically differentiated subtype within FSGS.

No strong assumptions were made regarding clinical subtype assignment because the available metadata was limited.

### Top genes

Highly expressed genes within fibrosis and inflammation signatures included:

- **Fibrosis-related:** `VIM`, `MMP2`, `TGFB2`
- **Inflammation-related:** `TYROBP`, `PTPRC`, `CXCL2`

From a biological and clinical perspective:

- **VIM (Vimentin):** associated with epithelial-to-mesenchymal transition and tissue remodeling
- **MMP2:** involved in extracellular matrix remodeling
- **TGFB2:** a key mediator of fibrotic signaling
- **PTPRC (CD45):** marker of immune cell activation

These findings are consistent with established mechanisms of renal injury, inflammatory activation, and fibrosis.

### Differential expression and enrichment

Differential expression analysis identified genes with strong effect sizes and significant adjusted p-values, supporting the presence of biologically distinct transcriptomic profiles between patient clusters.

Functional enrichment analysis further supported the relevance of fibrosis- and inflammation-related processes.

## Interpretation

The results support the coexistence of inflammatory and fibrotic programs in FSGS and show that transcriptomic data can capture biologically meaningful heterogeneity that may not be fully evident at the clinical level alone.

This type of analysis may contribute to future patient stratification strategies and hypothesis generation in precision nephrology.

## Limitations

- Limited clinical metadata for integrative interpretation
- No longitudinal or outcome-based validation
- No external validation cohort
- Signature-based interpretation simplifies complex biological processes

## Gene Annotation Note

Differential expression was performed on the broader transcriptomic dataset, but some interpretation steps relied on locally curated signature resources.

As a result, not all differentially expressed features could be mapped to a final clinically interpretable gene panel. This is a common limitation when working with partial annotation resources or restricted curated signatures.

## Development Notes

This project was developed with an emphasis on transparency and reproducibility.

Several practical issues were encountered during execution, including:

- missing intermediate outputs,
- incorrect assumptions about data structure,
- PCA instability due to zero-variance genes,
- path inconsistencies during execution.

These issues were addressed iteratively, prioritizing robustness and interpretability over artificial completeness.

## Repository Structure

```text
data/
  metadata/
  processed/
  raw/

results/
  differential_expression/
  enrichment/
  figures/
  tables/

scripts/
  00_setup.R
  01_data_import.R
  02_metadata_extraction.R
  03_build_fsgs_cohort.R
  04_deseq2_analysis.R
  05_clustering.R
  05_enrichment_analysis.R
  06_signature_gene_panels.R
  07_signature_heatmap.R
  08_signature_scores.R
  ```
## Author

Cristian Arias  

MD – Internal Medicine & Nephrology  
Healthcare Data Analyst  
Bioinformatics Master's Candidate  

Focused on clinical data analysis and translational applications in kidney disease.