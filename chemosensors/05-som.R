### 01-reg-perceptron-dim.R

### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

library(doMC)

### parameters
testing <- TRUE

cores <- 8

seed.value <- 1

tuneLength <- 5
 
### parallel
if(cores > 1) {
  registerDoMC(cores = cores)
}

### data
#load("chemosensors/data/reg.RData")
load("chemosensors/regAsom.RData")
input <- regAsom

### test on small-size problem
if(testing)
{
  input <- input[1:2]
  tuneLength <- 2
}

### input
input <- llply(input, function(x) 
{ 
  ### divistion into training/test sets
  snames <- grep("^S", names(x$df))
  
  X.train <- subset(x$df, set == "T", select = snames)
  X.test <- subset(x$df, set == "V", select = snames)

  Y.train <- subset(x$df, set == "T", select = x$gas, drop = TRUE)
  Y.test <- subset(x$df, set == "V", select = x$gas, drop = TRUE)

  c(x, list(X.train = X.train, X.test = X.test, Y.train = Y.train, Y.test = Y.test,
    tuneLength = tuneLength))
})
  
### output (fit)
output <- llply(input, function(x) {

  require(caret)

  set.seed(seed.value)
  trControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10, selectionFunction = "tolerance") 
  fit <- train(x$X.train, x$Y.train, method = "xyf", preProc = c("center", "scale"),
    tuneLength = x$tuneLength, trControl = trControl)

  c(x, list(fit = fit))
})

### output (tab)
tab <- ldply(output, function(x) {
  bestTune <- x$fit$bestTune

  data.frame(gas = x$gas,
    nsensors = x$nsensors,
    #param = paste(laply(1:ncol(bestTune), function(i) 
    #paste(names(bestTune)[i], round(bestTune[1, i], 2))), collapse = ", ")
  )
})

### print
print(ascii(tab))

### save
save(output, tab, file = "som-output.RData")
save(tab, file = "som-tab.RData")
