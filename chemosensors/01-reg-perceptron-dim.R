### 01-reg-perceptron-dim.R
#
# About.
# We'd like to see how non-linear are the sensors/data generation models in the package 'chemosensors'.
# A synthetic experiment is proposed:
# - employ data from the only gas, e.g. 'A';
# - use a perceptron as a regressor, since the number of neurons is a measure of dimensionality (of the perceptron's output).
# 
# Coding details.
# - We use two scenarios `sc1` and `sc2` different in the gas concentrations involved.
#   The first one `sc1` covers the complete range (from 0.001 up to 0.1 % vol.),
#   while the second one `sc2` contains concentrations in relatevely linear range.

### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

### load/stat data
load("chemosensors/data/reg-univar-A.RData") # -> sa, set1, set2, df1, df2

sa

plot(sa)

p1 <- plotSignal(sa, set = set1)
p1

p2 <- plotSignal(sa, set = set2)
p2

p3 <- plotPCA(sa, set = rep(set1, 3), air = FALSE)
p3 

p4 <- plotPCA(sa, set = rep(set2, 3), air = FALSE)
p4

### divistion into training/test sets
ind.train1 <- 1:nrow(df1) <= (2/3) * nrow(df1) # first 2/3 of samples for T
ind.train2 <- 1:nrow(df2) <= (2/3) * nrow(df2) # first 2/3 of samples for T

X1 <- df1[, grep("^S", names(df1)), drop = FALSE]
Y1 <- df1[, grep("A", names(df1)), drop = FALSE]

X2 <- df2[, grep("^S", names(df2)), drop = FALSE]
Y2 <- df2[, grep("A", names(df2)), drop = FALSE]

Y.train1 <- Y1[ind.train1, , drop = FALSE]
Y.test1 <- Y1[-ind.train1, , drop = FALSE]

Y.train2 <- Y2[ind.train2, , drop = FALSE]
Y.test2 <- Y2[-ind.train2, , drop = FALSE]

X.train1 <- X1[ind.train1, , drop = FALSE]
X.test1 <- X1[-ind.train1, , drop = FALSE]

X.train2 <- X2[ind.train2, , drop = FALSE]
X.test2 <- X2[-ind.train2, , drop = FALSE]

### fit
formula1 <- formula(paste(paste(colnames(Y.train1), collapse = "+"), "~", paste(colnames(X.train1), collapse = "+")))
data1 <- cbind(X.train1, Y.train1)

formula2 <- formula(paste(paste(colnames(Y.train2), collapse = "+"), "~", paste(colnames(X.train2), collapse = "+")))
data2 <- cbind(X.train2, Y.train2)

trControl <- trainControl(method = "repeatedcv", number = 10) ## 10-fold CV
tuneGrid <- expand.grid(.decay = 1e-4, .size = c(1, 3, 5, 10)) # we've already found `decay 1e-4` to be the best

fit1 <- train(formula1, data1, 
  method = "nnet", maxit = 1000,
  trControl = trControl, tuneGrid = tuneGrid, trace = FALSE)
  
plot(fit1)  

fit2 <- train(formula2, data2, 
  method = "nnet", maxit = 1000,
  trControl = trControl, tuneGrid = tuneGrid, trace = FALSE)
  
plot(fit2)  
