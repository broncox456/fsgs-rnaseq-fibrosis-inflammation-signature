# 02_metadata_extraction.R

library(GEOquery)

gse_id <- "GSE197307"

gse_list <- getGEO(gse_id, GSEMatrix = TRUE)
gse <- gse_list[[1]]

meta <- pData(gse)

cat("Metadata dimensions:\n")
print(dim(meta))

cat("\nColumn names:\n")
print(colnames(meta))

# Save full metadata
write.csv(meta, "data/metadata/full_metadata_GSE197307.csv", row.names = TRUE)

# Print first few rows for inspection
cat("\nFirst rows preview:\n")
print(meta[1:5, 1:min(12, ncol(meta))])

cat("\nSaved file:\n")
cat("data/metadata/full_metadata_GSE197307.csv\n")