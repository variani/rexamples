### 01-reg-perceptron-dim.R

### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

library(doMC)

### parameters
seed.value <- 1

gases <- c("A", "B", "C")

tuneLength1 <- 24
tuneLength2 <- 10
 
cores <- 2

### parallel
if(cores > 1) {
  registerDoMC(cores = cores)
}

### data
load("chemosensors/data/reg.RData")

### variables
nsensors <- 1:nsensors(sa)

### test on small-size problem
if(TRUE)
{
  tuneLength1 <- 2
  tuneLength2 <- 2
  
  nsensors <- 2
}

### input
input <- llply(gases, function(gas) 
{ 
  dataset.name <- paste("reg", gas, sep = "")
  cmd <- paste("df <- ", dataset.name)
  eval(parse(text = cmd))

  ### divistion into training/test sets
  snames <- grep("^S", names(df))[1:nsensors]
  
  X.train <- subset(df, set == "T", select = snames)
  X.test <- subset(df, set == "V", select = snames)

  Y.train <- subset(df, set == "T", select = gas, drop = TRUE)
  Y.test <- subset(df, set == "V", select = gas, drop = TRUE)

  list(gas = gas, dataset.name = dataset.name, df = df,
    X.train = X.train, X.test = X.test, Y.train = Y.train, Y.test = Y.test,
    tuneLength1 = tuneLength1, tuneLength2 = tuneLength2)
})
names(input) <- gases

  
### output
compute_fits <- function(input, seed.value = 1)
{
  llply(input, function(x) {

  require(caret)
  
  set.seed(seed.value)
  fit1 <- caret::train(x$X.train, x$Y.train, method = "pls", 
    tuneLength = x$tuneLength1, preProc = c("center", "scale"), 
    trControl = trainControl(method = "repeatedcv", repeats = 10))

  set.seed(seed.value)
  fit2 <- caret::train(x$X.train, x$Y.train, method = "svmRadial", 
    tuneLength = x$tuneLength1, preProc = c("center", "scale"), 
    trControl = trainControl(method = "repeatedcv", repeats = 10))

    c(x, list(fit1 = fit1, fit2 = fit2))
  })
}

eval_fits <- function(input)
{
  llply(input, function(x) {
    tab <- ldply(list(x$fit1, x$fit2), function(fit) {
      bestTune <- fit$bestTune

      data.frame(gas = x$gas,
        method = fit$method,
        param = paste(laply(1:ncol(bestTune), function(i) 
          paste(names(bestTune)[i], round(bestTune[1, i], 4))), collapse = ", "),
        RMSE.train = RMSE(predict(fit, x$X.train), x$Y.train),
        RMSE.test = RMSE(predict(fit, x$X.test), x$Y.test))
    })
    
    tab <- data.frame(gas = x$gas, tab)

    c(x, list(tab = tab))
  })  
}

clean_output <- function(output)
{
  llply(output, function(x) {
    list(gas = x$gas, fit1 = x$fit1, fit2 = x$fit2, tab = x$tab)
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
save(sa, output, tab, file = "reg-output.RData")
save(tab, file = "reg-tab.RData")

