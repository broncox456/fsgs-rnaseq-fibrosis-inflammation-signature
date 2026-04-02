# 00_setup.R

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

cran_packages <- c(
  "tidyverse",
  "pheatmap",
  "EnhancedVolcano",
  "GEOquery"
)

installed <- rownames(installed.packages())

for (p in cran_packages) {
  if (!(p %in% installed)) {
    install.packages(p)
  }
}

bioc_packages <- c(
  "DESeq2",
  "clusterProfiler",
  "org.Hs.eg.db"
)

for (p in bioc_packages) {
  if (!(p %in% rownames(installed.packages()))) {
    BiocManager::install(p, ask = FALSE, update = FALSE)
  }
}

library(DESeq2)
library(tidyverse)
library(GEOquery)

cat("Setup completed\n")