### 05-gen-mixtures.R

### include
library(chemosensors)

library(doMC)

### par
cores <- 2

seed.value <- 1

nSet <- 20

nsensors <- 60
num.values <- list(numA = 1:3, numC = c(13:14, 17), numAC = c(1:3, 13:14, 17))
dsd.values <- c(0, 0.1)

concA <- c(0.01, 0.02, 0.05, 0.1)
concC <- c(0.1, 0.4, 1, 2)
set <- c(paste("A", concA), paste("C", concC),
  paste(paste("A", concA), paste("C", concC), sep = ", "))

### parallel
parallel <- cores > 1
if(cores > 1) {
  registerDoMC(cores = cores)
}

### small-size
if(TRUE) {
  nSet <- 2
  nsensors <- 2
}

### sa
input <- llply(num.values, function(num) {
  llply(dsd.values, function(dsd) {
    set.seed(seed.value)
    sa <- SensorArray(num = num, nsensors = nsensors, dsd = dsd)
    
    list(num = num, dsd = dsd, nsensors = nsensors, sa = sa)
  })
}, .parallel = TRUE) 

stopifnot(length(input) == 3)
input <- c(input[[1]], input[[2]], input[[3]])

names.num <- paste("array", paste(names(num.values), sep = "_"), sep = "_")
names(input) <- paste(rep(names.num, each = length(dsd.values)), paste("dsd", 100 * dsd.values, sep = "_"), sep = "_")

### input (conc)
input <- llply(input, function(x) {
  set.seed(seed.value)
  sc <- Scenario(T = set, nT = nSet, V = set, nV = nSet, randomize = TRUE)

  conc <- getConc(sc)
  cf <- sdata.frame(sc)
    
  c(x, list(sc = sc, conc = conc, cf = cf))
}, .parallel = TRUE)

### output (generate data)
output <- llply(input, function(x) {
  set.seed(seed.value)
  sdata <- predict(x$sa, x$conc, nclusters = cores)
  
  df <- sdata.frame(x$sa, cf = x$cf, sdata = sdata, feature = "transient")
  
  c(x, list(sdata = sdata, df = df))
})

### output (plots)
output <- llply(output, function(x) {
  
  p <- plotPCA(x$sa, conc = x$conc, sdata = x$sdata, air = FALSE, feature = "step")
  
  c(x, list(p = p))
})

### save to RData file
mixturesAC <- llply(output, function(x) {
  list(sa = x$sa, df = x$df)
})

save(mixturesAC, file = "mixturesAC.RData")
