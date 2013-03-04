### 01-reg-perceptron-dim.R
#
# About.
# We'd like to see how non-linear are the sensors/data generation models in the package 'chemosensors'.
# A synthetic experiment is proposed:
# - employ data from the only gas, e.g. 'A';
# - use a perceptron as a regressor, since the number of neurons is a measure of dimensionality (of the perceptron's output).
# 

### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

### parameters
tuneLength <- 15

### load/stat data
load("chemosensors/data/regA.RData")

names(regA)
df <- regA

### divistion into training/test sets
ind.train <- seq(1, nrow(df)/2)
ind.test <- seq(nrow(df)/2, nrow(df))

X <- df[, grep("^S", names(df))]
Y <- df[, grep("A", names(df)), drop = FALSE]

X.train <- X[ind.train, , drop = FALSE]
X.test <- X[-ind.test, , drop = FALSE]

Y.train <- Y[ind.train, , drop = TRUE]
Y.test <- Y[ind.test, , drop = TRUE]

### fit
#set.seed(1)
#fit1 <- caret::train(X.train, Y.train, method = "pls", 
#  tuneLength = tuneLength, preProc = c("center", "scale"), 
#  trControl = trainControl(method = "repeatedcv", repeats = 10))

set.seed(1)
fit2 <- caret::train(X.train, Y.train, method = "pls", 
  tuneLength = tuneLength, preProc = c("center", "scale", "spatialSign"), 
  trControl = trainControl(method = "repeatedcv", repeats = 10))

plot(fit1)
plot(fit2)
