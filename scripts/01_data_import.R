# 01_data_import.R

count_file <- "data/raw/GSE254957_NEPTUNE_GSE197307_UpdatedCountData.txt.gz"

# Read full count matrix
counts <- read.delim(
  gzfile(count_file),
  header = TRUE,
  sep = "\t",
  check.names = FALSE
)

cat("Full count matrix dimensions:\n")
print(dim(counts))

# Extract sample names
sample_names <- colnames(counts)[-1]

sample_table <- data.frame(
  sample_name = sample_names,
  stringsAsFactors = FALSE
)

# Initial group assignment based on column names
sample_table$initial_group <- ifelse(
  grepl("LivingDonor", sample_table$sample_name, ignore.case = TRUE),
  "LivingDonor",
  "DiseaseSample"
)

# Numeric sample id if present
sample_table$sample_id <- gsub("^Sample_", "", sample_table$sample_name)
sample_table$sample_id <- gsub("_LivingDonor$", "", sample_table$sample_id)

# Save outputs
write.csv(sample_table, "data/metadata/sample_table_initial.csv", row.names = FALSE)
write.csv(head(counts[, 1:min(15, ncol(counts))]), "data/processed/counts_head.csv", row.names = FALSE)

cat("\nInitial sample group counts:\n")
print(table(sample_table$initial_group))

cat("\nFirst 20 sample names:\n")
print(head(sample_table, 20))

cat("\nFiles saved:\n")
cat("- data/metadata/sample_table_initial.csv\n")
cat("- data/processed/counts_head.csv\n")