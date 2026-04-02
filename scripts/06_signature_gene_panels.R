# 06_signature_gene_panels.R

library(org.Hs.eg.db)
library(AnnotationDbi)
library(readr)
library(dplyr)

# ---------------------------
# 1. Load normalized-style matrix source
# ---------------------------
counts_df <- read.csv("data/processed/fsgs_counts_final.csv", check.names = FALSE)
meta <- read.csv("data/metadata/fsgs_metadata_final.csv")

rownames(counts_df) <- counts_df$ENSEMBL_gene_ID
counts_df <- counts_df[, -1]

# ---------------------------
# 2. Define gene panels
# ---------------------------
inflammation_genes <- c(
  "IL1B","TNF","IFNG","CCL2","CCL3","CCL4","CCL5","CXCL2","CXCL16",
  "NFKBIA","TLR1","TLR6","FCER1G","TYROBP","ITGAM","FCGR3A",
  "CCR1","CCR2","CX3CR1","PTPRC"
)

fibrosis_genes <- c(
  "TGFB1","TGFB2","FN1","MMP2","MMP14","COL1A1","COL1A2","COL3A1",
  "COL4A1","COL4A2","COL5A1","COL6A1","SPARC","THBS1","VIM",
  "ACTA2","PDGFRB","CTGF","SERPINE1","TAGLN"
)

all_panel_genes <- unique(c(inflammation_genes, fibrosis_genes))

# ---------------------------
# 3. Map ENSEMBL -> SYMBOL
# ---------------------------
ensembl_ids <- rownames(counts_df)
ensembl_clean <- sub("\\..*$", "", ensembl_ids)

mapping <- AnnotationDbi::select(
  org.Hs.eg.db,
  keys = ensembl_clean,
  columns = c("ENSEMBL", "SYMBOL"),
  keytype = "ENSEMBL"
)

mapping <- mapping %>%
  filter(!is.na(SYMBOL)) %>%
  distinct(ENSEMBL, SYMBOL, .keep_all = TRUE)

map_df <- data.frame(
  ENSEMBL_gene_ID = rownames(counts_df),
  ENSEMBL_clean = ensembl_clean,
  stringsAsFactors = FALSE
) %>%
  left_join(mapping, by = c("ENSEMBL_clean" = "ENSEMBL"))

# ---------------------------
# 4. Keep only panel genes present in dataset
# ---------------------------
panel_df <- map_df %>%
  filter(SYMBOL %in% all_panel_genes)

panel_counts <- counts_df[panel_df$ENSEMBL_gene_ID, , drop = FALSE]

annot <- panel_df %>%
  mutate(
    signature = case_when(
      SYMBOL %in% inflammation_genes ~ "Inflammation",
      SYMBOL %in% fibrosis_genes ~ "Fibrosis",
      TRUE ~ "Other"
    )
  ) %>%
  select(ENSEMBL_gene_ID, SYMBOL, signature)

# ---------------------------
# 5. Save outputs
# ---------------------------
write.csv(annot, "results/tables/signature_gene_annotation.csv", row.names = FALSE)

panel_out <- data.frame(
  ENSEMBL_gene_ID = rownames(panel_counts),
  SYMBOL = annot$SYMBOL[match(rownames(panel_counts), annot$ENSEMBL_gene_ID)],
  signature = annot$signature[match(rownames(panel_counts), annot$ENSEMBL_gene_ID)],
  panel_counts,
  check.names = FALSE
)

write.csv(panel_out, "results/tables/signature_gene_counts.csv", row.names = FALSE)

cat("Inflammation genes requested:", length(inflammation_genes), "\n")
cat("Fibrosis genes requested:", length(fibrosis_genes), "\n")
cat("Total panel genes found in dataset:", nrow(annot), "\n")

cat("\nFound by signature:\n")
print(table(annot$signature))

cat("\nFirst genes found:\n")
print(head(annot[order(annot$signature, annot$SYMBOL), ], 20))