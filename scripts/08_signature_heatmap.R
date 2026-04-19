# 07_signature_heatmap.R

library(DESeq2)
library(pheatmap)
library(RColorBrewer)

# ---------------------------
# 1. Load data
# ---------------------------
counts <- read.csv("data/processed/fsgs_counts_final.csv", check.names = FALSE)
meta   <- read.csv("data/metadata/fsgs_metadata_final.csv")
sig_df <- read.csv("results/tables/signature_gene_counts.csv", check.names = FALSE)

rownames(counts) <- counts$ENSEMBL_gene_ID
counts <- counts[, -1]
counts <- counts[, meta$sample_name]

# ---------------------------
# 2. DESeq2 object for vst
# ---------------------------
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = meta,
  design = ~ group
)

keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]
vsd <- vst(dds, blind = FALSE)
vsd_mat <- assay(vsd)

# ---------------------------
# 3. Keep only signature genes
# ---------------------------
sig_ids <- sig_df$ENSEMBL_gene_ID
sig_ids <- sig_ids[sig_ids %in% rownames(vsd_mat)]

heatmap_mat <- vsd_mat[sig_ids, , drop = FALSE]

# Row labels = SYMBOL
row_labels <- sig_df$SYMBOL[match(rownames(heatmap_mat), sig_df$ENSEMBL_gene_ID)]
rownames(heatmap_mat) <- row_labels

# Z-score by gene
heatmap_scaled <- t(scale(t(heatmap_mat)))

# Remove rows with NA after scaling
heatmap_scaled <- heatmap_scaled[complete.cases(heatmap_scaled), ]

# ---------------------------
# 4. Annotations
# ---------------------------
annotation_col <- data.frame(
  group = meta$group
)
rownames(annotation_col) <- meta$sample_name

annotation_row <- data.frame(
  signature = sig_df$signature[match(rownames(heatmap_scaled), sig_df$SYMBOL)]
)
rownames(annotation_row) <- rownames(heatmap_scaled)

# ---------------------------
# 5. Plot heatmap
# ---------------------------
png("results/figures/signature_heatmap.png", width = 1400, height = 1200, res = 150)

pheatmap(
  heatmap_scaled,
  annotation_col = annotation_col,
  annotation_row = annotation_row,
  show_colnames = FALSE,
  fontsize_row = 8,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  main = "FSGS inflammation and fibrosis signature heatmap"
)

dev.off()

cat("Signature heatmap generated successfully\n")
cat("Genes included in heatmap:", nrow(heatmap_scaled), "\n")
cat("Samples included in heatmap:", ncol(heatmap_scaled), "\n")