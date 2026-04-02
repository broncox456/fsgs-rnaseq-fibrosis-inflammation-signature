# 05_clustering.R

library(ggplot2)

# raíz del proyecto
setwd("C:/Users/Usuario/fsgs-rnaseq-fibrosis-progression-signature")

# cargar scores
scores_df <- read.csv("results/fibrosis_inflammation_scores.csv", stringsAsFactors = FALSE)

# validar columnas esperadas
required_cols <- c("sample_id", "inflammation_score", "fibrosis_score")
missing_cols <- setdiff(required_cols, colnames(scores_df))

if (length(missing_cols) > 0) {
  stop(
    paste(
      "Faltan estas columnas en results/fibrosis_inflammation_scores.csv:",
      paste(missing_cols, collapse = ", ")
    )
  )
}

# clustering
scores_scaled <- scale(scores_df[, c("inflammation_score", "fibrosis_score")])

set.seed(123)
kmeans_res <- kmeans(scores_scaled, centers = 2)

scores_df$cluster <- as.factor(kmeans_res$cluster)

# guardar tabla final
write.csv(scores_df, "results/scores_with_clusters.csv", row.names = FALSE)

# gráfico
p <- ggplot(scores_df, aes(x = inflammation_score, y = fibrosis_score, color = cluster)) +
  geom_point(size = 3, alpha = 0.85) +
  theme_minimal() +
  labs(
    title = "Patient clustering based on inflammation and fibrosis scores",
    x = "Inflammation score",
    y = "Fibrosis score",
    color = "Cluster"
  )

ggsave("results/clustering_plot.png", plot = p, width = 7, height = 5, dpi = 300)

print(table(scores_df$cluster))
print("Clustering completado.")