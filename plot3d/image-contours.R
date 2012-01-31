#
# reference: http://addictedtor.free.fr/graphiques/RGraphGallery.php?graph=1

### include
library(MASS) # function 'kde2d'

### data
set.seed(10)
x <- rnorm(50, mean=1)
y <- rnorm(50, mean=5)
d <- kde2d(x, y, n=50)

image(d)
contour(d, add=TRUE, nlevels=10)
