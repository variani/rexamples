#
# Data set:
# The yeast data set, included in the `kohonen` package, are already in the correct 
# form for fucntion `supersom`: a list where each element is a data matrix with 
# one row per gene.

### include
library(kohonen)

### data
data(yeast, package = "kohonen")

str(yeast, 1, give.attr = FALSE)

X <- yeast[3:6] # "alpha" "cdc15" "cdc28" "elu"
Y <- yeast[7]

#set.seed(7)
#mod <- supersom(yeast, somgrid(8, 8, "hexagonal"), whatmap = 3:6)
mod <- supersom(X, somgrid(8, 8, "hexagonal"))
  
### plot
classes <- levels(yeast$class)
colors <- c("yellow", "green", "blue", "red", "orange")

par(mfrow = c(3, 2))

plot(mod, type = "mapping", pch = 1, main = "All", keepMargins = TRUE)

for (i in seq(along = classes)) {
  X.class <- lapply(yeast, function(x) subset(x, yeast$class == classes[i]))
  X.map <- map(mod, X.class)

  plot(mod, "mapping", classif = X.map, col = colors[i], 
    pch = 1, main = classes[i], keepMargins = TRUE, bgcol = gray(0.85))
}    
