### About
# Aim: reproduce some code examples in 'The caret Package', Max Kuhn, February 8, 2011
# @ http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.192.6170&rep=rep1&type=pdf
#  * data set: mdrr

### include
library(caret)

library(plyr)
library(ggplot2)

### data
data(mdrr)

table(mdrrClass)
#  Active Inactive 
#     298      230 

ncol(mdrrDescr)
#[1] 342

### pre-process data 
nzv <- nearZeroVar(mdrrDescr)
filteredDescr <- mdrrDescr[, -nzv]
ncol(filteredDescr)
# 297

descrCor <- cor(filteredDescr)
highlyCorDescr <- findCorrelation(descrCor, cutoff = .75)
filteredDescr <- filteredDescr[,-highlyCorDescr]
ncol(filteredDescr)
# 50

### splitting training/test
set.seed(1)
inTrain <- sample(seq(along = mdrrClass), length(mdrrClass)/2) # prortion: 50/50

trainDescr <- filteredDescr[inTrain,]
testDescr <- filteredDescr[-inTrain,]

trainMDRR <- mdrrClass[inTrain]
testMDRR <- mdrrClass[-inTrain]

### model 1: using ROC
fitControl <- trainControl(method = "LGOCV", p = .75, number = 30, classProbs = TRUE,
  summaryFunction = twoClassSummary, returnResamp = "all", verboseIter = FALSE)
  
set.seed(2)
svmROC <- train(trainDescr, trainMDRR,
  method = "svmRadial", tuneLength = 4, 
  metric = "ROC", trControl = fitControl)
  
# ROC
mod <- svmROC$finalModel
probs <- predict(mod, trainDescr, type = "p")
r <- roc(trainMDRR, probs[, 1]) # it is the same as `roc(trainMDRR, probs[, 2])`

plot(r)


  
  
