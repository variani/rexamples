# @ http://stats.stackexchange.com/questions/4517/regression-with-multiple-dependent-variables
# - 'train' does NOT support multivariate response 'Y'

### include
library(caret)
library(plyr)
library(ggplot2)
library(neuralnet)

### par
species <- "setosa"

### data
data(iris)

str(iris)

X <- subset(iris, Species == species, c("Sepal.Length", "Petal.Length"))
Y <- subset(iris, Species == species, c("Sepal.Width", "Petal.Width"))
# See the reasoning for the model by plotting
# qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)

### split data into T/V
ind.tr <- 1:30

Y.tr <- Y[ind.tr, ]
Y.val <- Y[-ind.tr, ]

X.tr <- X[ind.tr, ]
X.val <- X[-ind.tr, ]

### fit a model
formula <- formula(paste(paste(colnames(Y.tr), collapse = "+"), "~", paste(colnames(X.tr), collapse = "+")))
data <- cbind(X.tr, Y.tr)

model <- neuralnet(formula, data, hidden = c(2, 2))
