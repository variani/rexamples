#
# Data set:
# The yeast data set, included in the `kohonen` package, are already in the correct 
# form for fucntion `supersom`: a list where each element is a data matrix with 
# one row per gene.

### include
library(kohonen)
library(caret)

library(doMC)

### parameters
cores <- 2

### parallel
registerDoMC(cores)

### data
data(nir, package = "kohonen")

Y <- nir$composition[, "water"]
X <- nir$spectra
training <- nir$training

Xtrain <- X[training, ]
Ytrain <- Y[nir$training]


### train the model
trControl <- trainControl(method = "repeatedcv", number = 2, repeats = 10, selectionFunction = "tolerance") 

tuneLength <- 5

tuneGrid <- expand.grid(.dim = 2:3, .xweight = c(0.5, 0.7, 0.9), .topo = "hexagonal")
tuneGrid <- mutate(tuneGrid, .xdim = .dim, .ydim = .dim)
tuneGrid <- subset(tuneGrid, select = c(".topo", ".xdim", ".xweight", ".ydim"))


fit <- train(X, Y, method = "xyf", tuneLength = tuneLength, trControl = trControl)
#fit <- train(X, Y, method = "xyf", tuneGrid = tuneGrid, trControl = trControl)

