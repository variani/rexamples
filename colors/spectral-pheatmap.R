#
# basic color taken from http://cran.r-project.org/web/packages/pheatmap/

### include
library(MASS) # function 'kde2d'

### parameters
N <- 100 # number of colors
np <- 50 # number of points

### colors
bcol <- rev(c("#D73027", "#FC8D59", "#FEE090", "#FFFFBF", "#E0F3F8", "#91BFDB", "#4575B4")) # base colors
col <- colorRampPalette(bcol)(N)

### data
set.seed(10)
x <- rnorm(np, mean=1)
y <- rnorm(np, mean=5)
z <- kde2d(x, y, n=50) # 2D density

image(z, col=col)

