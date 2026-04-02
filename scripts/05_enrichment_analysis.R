# 05_enrichment_analysis.R

library(clusterProfiler)
library(org.Hs.eg.db)
library(dplyr)

# ---------------------------
# 1. Load DESeq2 results
# ---------------------------
res <- read.csv("results/differential_expression/deseq2_results_significant.csv")

cat("Loaded significant genes:\n")
print(nrow(res))

# ---------------------------
# 2. Prepare gene list
# ---------------------------
# Remove NA
res <- na.omit(res)

# Convert ENSEMBL → ENTREZ
genes <- res$X
genes <- gsub("\\..*", "", genes)  # remove version if present

gene_df <- bitr(
  genes,
  fromType = "ENSEMBL",
  toType = "ENTREZID",
  OrgDb = org.Hs.eg.db
)

cat("\nMapped genes:\n")
print(nrow(gene_df))

# ---------------------------
# 3. GO enrichment
# ---------------------------
ego <- enrichGO(
  gene = gene_df$ENTREZID,
  OrgDb = org.Hs.eg.db,
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  readable = TRUE
)

write.csv(as.data.frame(ego), "results/enrichment/go_results.csv")

# ---------------------------
# 4. KEGG enrichment
# ---------------------------
ekegg <- enrichKEGG(
  gene = gene_df$ENTREZID,
  organism = "hsa",
  pvalueCutoff = 0.05
)

write.csv(as.data.frame(ekegg), "results/enrichment/kegg_results.csv")

# ---------------------------
# 5. Plots
# ---------------------------
png("results/figures/go_dotplot.png", width = 800, height = 600)
dotplot(ego, showCategory = 20)
dev.off()

png("results/figures/kegg_dotplot.png", width = 800, height = 600)
dotplot(ekegg, showCategory = 20)
dev.off()

cat("\nEnrichment analysis completed\n")