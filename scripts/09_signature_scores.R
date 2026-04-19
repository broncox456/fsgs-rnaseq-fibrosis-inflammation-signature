# 08_signature_scores.R

library(DESeq2)
library(dplyr)

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
# 2. DESeq2 + VST
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
# 3. Extract signature genes
# ---------------------------
sig_ids <- sig_df$ENSEMBL_gene_ID
sig_ids <- sig_ids[sig_ids %in% rownames(vsd_mat)]

sig_mat <- vsd_mat[sig_ids, , drop = FALSE]

# Add annotation
sig_annot <- sig_df[match(sig_ids, sig_df$ENSEMBL_gene_ID), ]

# ---------------------------
# 4. Calculate scores
# ---------------------------
# Inflammation
inflam_ids <- sig_annot$ENSEMBL_gene_ID[sig_annot$signature == "Inflammation"]
fibrosis_ids <- sig_annot$ENSEMBL_gene_ID[sig_annot$signature == "Fibrosis"]

inflam_mat <- sig_mat[inflam_ids, , drop = FALSE]
fibrosis_mat <- sig_mat[fibrosis_ids, , drop = FALSE]

inflam_score <- colMeans(inflam_mat)
fibrosis_score <- colMeans(fibrosis_mat)

# ---------------------------
# 5. Build output
# ---------------------------
scores_df <- data.frame(
  sample_name = names(inflam_score),
  inflammation_score = inflam_score,
  fibrosis_score = fibrosis_score
)

scores_df <- scores_df %>%
  left_join(meta, by = "sample_name")

# ---------------------------
# 6. Save
# ---------------------------
write.csv(scores_df, "results/tables/patient_signature_scores.csv", row.names = FALSE)

cat("Scores calculated successfully\n")

cat("\nSummary:\n")
print(summary(scores_df[, c("inflammation_score", "fibrosis_score")]))

cat("\nGroup comparison:\n")
print(scores_df %>%
        group_by(group) %>%
        summarise(
          mean_inflammation = mean(inflammation_score),
          mean_fibrosis = mean(fibrosis_score)
        ))