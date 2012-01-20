### include
library(pls)

### parameters
pc <- 1:2

### data
data(iris)
X <- iris[, 1:4]
Y <- iris[, 5]

### PCA numbers by 'pls' package 
mod <- prcomp(X, center=TRUE, scale=FALSE)

smod <- summary(mod)
var.pls <- smod$importance["Proportion of Variance", pc]

### PCA numbers by manual computation
X <- as.matrix(X) # needed to be a matrix
E <- as.matrix(mod$rotation[, pc])

# scale 'X' according to the model
X.scaled <- X
if(mod$center[1]) X.scaled <- as.matrix(sweep(X.scaled, 2, mod$center))  
if(mod$scale[1])  X.scaled <- as.matrix(sweep(X.scaled,2, mod$scale,"/"))

var.projected <- apply(E, 2, function(e, X) sum((X %*% e)^2), X.scaled)
var.total <- sum(apply(X.scaled, 2, function(x) sum((x)^2)))

var.pc <- var.projected / var.total

### compare numbers of proportion of projected variance
print(var.pls)
print(var.pc)

