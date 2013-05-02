### 04-pls-non-linear.R
#
# About.
# We'd like to test the PLS linear/non-linear predictive model on linear/non-linear data sets.
# Details of the experiment:
# - Use `RegUniA` dataset.
#   -- Scenario: nT = 20, nV = 10
#   -- The first scenario `sc1` covers the complete range (from 0.001 up to 0.1 % vol.),
#   -- The second scenario `sc2` contains concentrations in a relatevely linear range.

### include
library(chemosensors)

#library(caret)

#library(devtools)
#load_all("tmp/pkg/caret/")
library(caret)

library(plyr)
library(ggplot2)

library(doMC)
 
cores <- 2

### parallel
if(cores > 1) {
  registerDoMC(cores = cores)
}

### load/stat data
load("chemosensors/data/RegUniA.RData") # -> sa, set1, set2, df1, df2

names(RegUniA)

set1 <- RegUniA$set1  
set2 <- RegUniA$set2

sa <- RegUniA$sa    

df1 <- RegUniA$df1
df2 <- RegUniA$df2   

### divistion into training/test sets
ind.train1 <- 1:nrow(df1) <= (2/3) * nrow(df1) # first 2/3 of samples for T
ind.train2 <- 1:nrow(df2) <= (2/3) * nrow(df2) # first 2/3 of samples for T

X1 <- df1[, grep("^S", names(df1)), drop = FALSE]
Y1 <- df1[, grep("A", names(df1)), drop = FALSE]

X2 <- df2[, grep("^S", names(df2)), drop = FALSE]
Y2 <- df2[, grep("A", names(df2)), drop = FALSE]

Y.train1 <- as.matrix(Y1[ind.train1, , drop = FALSE])
Y.test1 <- as.matrix(Y1[-ind.train1, , drop = FALSE])

Y.train2 <- as.matrix(Y2[ind.train2, , drop = FALSE])
Y.test2 <- as.matrix(Y2[-ind.train2, , drop = FALSE])

X.train1 <- as.matrix(X1[ind.train1, , drop = FALSE])
X.test1 <- as.matrix(X1[-ind.train1, , drop = FALSE])

X.train2 <- as.matrix(X2[ind.train2, , drop = FALSE])
X.test2 <- as.matrix(X2[-ind.train2, , drop = FALSE])

### fit
trControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10,
  selectionFunction = "tolerance") 

set.seed(1)  
fit1 <- train(X.train1, Y.train1, method = "pls", 
  tuneLength = 8, preProc = c("center", "scale"),
  trControl = trControl)

set.seed(1)  
fit2 <- train(X.train2, Y.train2, method = "pls", 
  tuneLength = 8, preProc = c("center", "scale"),
  trControl = trControl)  

set.seed(1)  
fit3 <- train(X.train1, Y.train1, method = "svmRadial", 
  tuneLength = 8, preProc = c("center", "scale"),
  trControl = trControl)    
  
### predict new data
rmse.fit1 <- RMSE(predict(fit1, newdata = X.test1), Y.test1)
rmse.fit3 <- RMSE(predict(fit3, newdata = X.test1), Y.test1)

cat(" * rmse.fit1:", rmse.fit1, "\n")
cat(" * rmse.fit1:", rmse.fit3, "\n")

