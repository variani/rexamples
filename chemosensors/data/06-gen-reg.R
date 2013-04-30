### 04-gen-reg.R

### include
library(chemosensors)

library(doMC)

### par
cores <- 2

seed.value <- 1

gases <- c("A", "C")
nSet <- 100

numA <- 1:3
numC <- c(13:14, 17) 
numAC <- c(1:3, 13:14, 17)
nsensors <- 24

dsd.values <- c(0, 0.1)

narrays <- 3

### parallel
parallel <- cores > 1
if(cores > 1) {
  registerDoMC(cores = cores)
}

### small-size
if(FALSE) {
  nSet <- 2
  nsensors <- 2
  narrays <- 1
}

### sa
gas_to_num <- function(gas, i)
{
  switch(gas,
    "A" = {
      if(i == 1) numA
      else if(i == 2) numAC
      else if(i == 3) numC      
      else stop("Error in 'gas_to_num': if")
    },
    "C" = {
      if(i == 1) numC
      else if(i == 2) numAC
      else if(i == 3) numA
      else stop("Error in 'gas_to_num': if")
    },
    stop("Error in 'gas_to_num': switch."))
}

input <- llply(gases, function(x) {
  llply(1:narrays, function(i) {
    llply(dsd.values, function(dsd) {
      num <- gas_to_num(x, i)

      set.seed(seed.value)
      sa <- SensorArray(num = num, nsensors = nsensors, dsd = dsd)
      
      list(gas = x, num = num, nsensors = nsensors, dsd = dsd, sa = sa)
    })
  })
}, .parallel = TRUE) 

stopifnot(length(input) == 2)
stopifnot(length(input[[1]]) == 3)
input <- c(input[[1]], input[[2]])

stopifnot(length(input) == 6)
input <- c(input[[1]], input[[2]], input[[3]], input[[4]], input[[5]], input[[6]])

### input (conc)
gas_to_conc <- function(gas)
{
  switch(gas,
    "A" = c(0.01, 0.02, 0.05, 0.1),
    "B" = c(0.01, 0.02, 0.05, 0.1),
    "C" = c(0.1, 0.4, 1, 2),        
    stop("Error in 'gas_to_conc': switch."))
}

input <- llply(input, function(x) {
  
  dataset.name <- paste("reg", x$gas, sep = "")
  rdata.filename <- paste(dataset.name, "RData", sep = ".")
  
  set <- paste(x$gas, gas_to_conc(x$gas))
  
  set.seed(seed.value)
  sc <- Scenario(T = set, nT = nSet, V = set, nV = nSet, randomize = TRUE)

  conc <- getConc(sc)
  cf <- sdata.frame(sc)
    
  c(x, list(dataset.name = dataset.name, rdata.filename = rdata.filename,
    sc = sc, conc = conc, cf = cf))
}, .parallel = TRUE)

### output (generate data)
output <- llply(input, function(x) {
  set.seed(seed.value)
  sdata <- predict(x$sa, x$conc, nclusters = cores)
  
  df <- sdata.frame(x$sa, cf = x$cf, sdata = sdata, feature = "transient")
  
  #cmd <- paste(x$dataset.name, " <- df")
  #eval(parse(text = cmd))
  
  c(x, list(sdata = sdata, df = df))
})

### save to RData file
reg <- llply(output, function(x) {
  list(gas = x$gas, num = x$num, nsensors = x$nsensors, sa = x$sa,
    df = x$df)
})

save(reg, file = "reg.RData")
