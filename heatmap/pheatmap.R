#
# http://cran.r-project.org/web/packages/pheatmap/
# pheatmap: Pretty Heatmaps
# The package for drawing pretty heatmaps in R.
#

### library
library(pheatmap)

### data
test <- matrix(rnorm(200), 20, 10)
test[1:10, seq(1, 10, 2)] <- test[1:10, seq(1, 10, 2)] + 3
test[11:20, seq(2, 10, 2)] <- test[11:20, seq(2, 10, 2)] + 2

colnames(test) <- paste("Test", 1:10, sep = "")
rownames(test) <- paste("Gene", 1:20, sep = "")

pheatmap(test, legend=TRUE, annotation_legend = TRUE, border_color = "black", 
  cluster_row=FALSE, cluster_col=FALSE, fontsize=7, axis=TRUE)
