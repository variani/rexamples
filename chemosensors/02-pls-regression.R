### 01-reg-perceptron-dim.R

### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

library(doMC)

### parameters
nsensors <- 24

seed.value <- 1

tuneLength1 <- 24
tuneLength2 <- 10
 
cores <- 2

### parallel
if(cores > 1) {
  registerDoMC(cores = cores)
}

### data
#load("chemosensors/data/reg.RData")
load("chemosensors/reg.RData")

### variables

### test on small-size problem
if(FALSE)
{
  reg <- reg[1:2]
  tuneLength1 <- 2
  tuneLength2 <- 2
  
  nsensors <- 2
}

### input
input <- llply(reg, function(x) 
{ 
  ### divistion into training/test sets
  snames <- grep("^S", names(x$df))[1:nsensors]
  
  X.train <- subset(x$df, set == "T", select = snames)
  X.test <- subset(x$df, set == "V", select = snames)

  Y.train <- subset(x$df, set == "T", select = x$gas, drop = TRUE)
  Y.test <- subset(x$df, set == "V", select = x$gas, drop = TRUE)

  c(x, list(X.train = X.train, X.test = X.test, Y.train = Y.train, Y.test = Y.test,
    tuneLength1 = tuneLength1, tuneLength2 = tuneLength2))
})
  
### output
compute_fits <- function(input, seed.value = 1)
{
  llply(input, function(x) {

  require(caret)

  trControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10, selectionFunction = "tolerance") 
    
  set.seed(seed.value)
  fit1 <- caret::train(x$X.train, x$Y.train, method = "pls", 
    tuneLength = x$tuneLength1, preProc = c("center", "scale"), trControl = trControl)

  set.seed(seed.value)
  fit2 <- caret::train(x$X.train, x$Y.train, method = "svmRadial", 
    tuneLength = x$tuneLength2, 
    preProc = c("center", "scale"), trControl = trControl)

    c(x, list(fit1 = fit1, fit2 = fit2))
  })
}

eval_fits <- function(input)
{
  llply(input, function(x) {
    
    tab <- ldply(list(x$fit1, x$fit2), function(fit) {
      bestTune <- fit$bestTune

      data.frame(gas = x$gas,
        nsensors = x$nsensors,
        num = paste(x$num, collapse = ", "),
        dsd = x$sa@dsd, 
        method = fit$method,
        param = paste(laply(1:ncol(bestTune), function(i) 
          paste(names(bestTune)[i], round(bestTune[1, i], 4))), collapse = ", "),
        RMSE.train = RMSE(predict(fit, x$X.train), x$Y.train),
        RMSE.test = RMSE(predict(fit, x$X.test), x$Y.test))
    })
    
    c(x, list(tab = tab))
  })  
}

clean_output <- function(output)
{
  llply(output, function(x) {
    list(gas = x$gas, sa = x$sa, fit1 = x$fit1, fit2 = x$fit2, tab = x$tab)
  })
}

output <- compute_fits(input, seed.value = seed.value)
output <- eval_fits(output)
output <- clean_output(output)

tab <- ldply(output, function(x) x$tab)
tab <- tab[, -1] # remove column '.id'    

### print
#print(ascii(tab, format = c("s", rep(c("s", "f", "f"), 2)), digits = 4, include.rownames = FALSE))

### save
save(output, tab, file = "reg-output.RData")
save(tab, file = "reg-tab.RData")
