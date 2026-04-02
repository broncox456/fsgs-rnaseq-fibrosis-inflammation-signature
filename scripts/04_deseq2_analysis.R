# 04_deseq2_analysis.R

library(DESeq2)
library(ggplot2)

# ---------------------------
# 1. Load data
# ---------------------------
counts <- read.csv("data/processed/fsgs_counts_final.csv", check.names = FALSE)
meta   <- read.csv("data/metadata/fsgs_metadata_final.csv")

# Prepare count matrix
rownames(counts) <- counts$ENSEMBL_gene_ID
counts <- counts[, -1]

# Ensure same order
counts <- counts[, meta$sample_name]

# ---------------------------
# 2. Create DESeq2 object
# ---------------------------
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = meta,
  design = ~ group
)

# ---------------------------
# 3. Filter low-count genes
# ---------------------------
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]

cat("Genes after filtering:\n")
print(dim(dds))

# ---------------------------
# 4. Run DESeq2
# ---------------------------
dds <- DESeq(dds)

res <- results(dds, contrast = c("group", "FSGS", "Control"))

res <- as.data.frame(res)
res <- na.omit(res)

# ---------------------------
# 5. Save results
# ---------------------------
write.csv(res, "results/differential_expression/deseq2_results_full.csv")

sig <- res[res$padj < 0.05 & abs(res$log2FoldChange) > 1, ]
write.csv(sig, "results/differential_expression/deseq2_results_significant.csv")

cat("\nSignificant genes:\n")
print(nrow(sig))

# ---------------------------
# 6. PCA
# ---------------------------
vsd <- vst(dds, blind = FALSE)

pca <- plotPCA(vsd, intgroup = "group", returnData = TRUE)

percentVar <- round(100 * attr(pca, "percentVar"))

p <- ggplot(pca, aes(PC1, PC2, color = group)) +
  geom_point(size = 3) +
  xlab(paste0("PC1: ", percentVar[1], "%")) +
  ylab(paste0("PC2: ", percentVar[2], "%")) +
  theme_minimal()

ggsave("results/figures/pca_plot.png", p)

# ---------------------------
# 7. Volcano plot
# ---------------------------
res$threshold <- as.factor(res$padj < 0.05 & abs(res$log2FoldChange) > 1)

volcano <- ggplot(res, aes(x = log2FoldChange, y = -log10(padj), color = threshold)) +
  geom_point(alpha = 0.6) +
  theme_minimal()

ggsave("results/figures/volcano_plot.png", volcano)

cat("\nAnalysis completed\n")