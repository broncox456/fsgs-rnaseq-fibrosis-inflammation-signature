# 03_build_fsgs_cohort.R

count_file <- "data/raw/GSE254957_NEPTUNE_GSE197307_UpdatedCountData.txt.gz"
meta_file  <- "data/metadata/full_metadata_GSE197307.csv"

# 1. Read counts
counts <- read.delim(
  gzfile(count_file),
  header = TRUE,
  sep = "\t",
  check.names = FALSE
)

gene_ids <- counts$ENSEMBL_gene_ID
count_matrix <- counts[, -1]
rownames(count_matrix) <- gene_ids

cat("Raw count matrix dimensions:\n")
print(dim(count_matrix))

# 2. Read metadata
meta <- read.csv(meta_file, row.names = 1, check.names = FALSE)

cat("\nRaw metadata dimensions:\n")
print(dim(meta))

meta_small <- meta[, c("title", "disease:ch1", "tissue:ch1")]
colnames(meta_small) <- c("sample_name", "disease", "tissue")
meta_small$disease <- trimws(meta_small$disease)

cat("\nUnique disease labels:\n")
print(sort(unique(meta_small$disease)))

# 3. Filter target groups
target_groups <- c(
  "Focal Segmental Glomerulosclerosis",
  "Healthy living transplant donor"
)

meta_filt <- meta_small[meta_small$disease %in% target_groups, ]

cat("\nFiltered metadata dimensions:\n")
print(dim(meta_filt))

cat("\nFiltered group counts:\n")
print(table(meta_filt$disease))

# 4. Match samples
common_samples <- intersect(colnames(count_matrix), meta_filt$sample_name)

cat("\nMatched sample count:\n")
print(length(common_samples))

meta_final <- meta_filt[match(common_samples, meta_filt$sample_name), ]
count_final <- count_matrix[, common_samples, drop = FALSE]

stopifnot(all(colnames(count_final) == meta_final$sample_name))

# 5. Recode groups
meta_final$group <- ifelse(
  meta_final$disease == "Focal Segmental Glomerulosclerosis",
  "FSGS",
  "Control"
)

meta_final$group <- factor(meta_final$group, levels = c("Control", "FSGS"))

cat("\nFinal cohort counts:\n")
print(table(meta_final$group))

cat("\nFinal count matrix dimensions:\n")
print(dim(count_final))

# 6. Save outputs
write.csv(meta_final, "data/metadata/fsgs_metadata_final.csv", row.names = FALSE)

write.csv(
  data.frame(ENSEMBL_gene_ID = rownames(count_final), count_final, check.names = FALSE),
  "data/processed/fsgs_counts_final.csv",
  row.names = FALSE
)

cat("\nSaved files:\n")
cat("- data/metadata/fsgs_metadata_final.csv\n")
cat("- data/processed/fsgs_counts_final.csv\n")

cat("\nSaved files:\n")
cat("- data/metadata/fsgs_metadata_final.csv\n")
cat("- data/processed/fsgs_counts_final.csv\n")