### library
library(RColorBrewer) # color palletes
library(plyr)

### data
X <- matrix(seq(0, 2*pi, length=100), 10, 10)
X <- aaply(X, 1:2, cos)

### plot parameters
col <- brewer.pal(9, "Blues")

### plot
img <- as.matrix(X) # needed to be a matrix

image(img, col=col, axes=FALSE)

axis(1, at=seq(0, 1, length.out=nrow(img)), labels=1:nrow(img), tick=FALSE)  
axis(2, at=seq(0, 1, length.out=ncol(img)), labels=colnames(img), las=2, tick=FALSE) 
