### 04-gen-reg.R

### include
library(chemosensors)

library(doMC)

### par
testing <- FALSE

cores <- 2

seed.value <- 1

nT <- 200
nV <- 50
par.dsd <- 0
par.num <- 1:17

par.gases <- c("A")
#par.nsensors <- c(17, 34, 68, 136)
par.nsensors <- c(17, 34)
par.beta <- c(2, 5, 10)

### parallel
parallel <- cores > 1
if(cores > 1) {
  registerDoMC(cores = cores)
}

### small-size
if(testing) {
  par.nsensors <- c(2, 4)
}

### input
gas_to_conc <- function(gas)
{
  switch(gas,
    "A" = c(0.01, 0.02, 0.05, 0.1),
    "B" = c(0.01, 0.02, 0.05, 0.1),
    "C" = c(0.1, 0.4, 1, 2),        
    stop("Error in 'gas_to_conc': switch."))
}

df <- expand.grid(gas = par.gases, nsensors = par.nsensors, beta = par.beta, stringsAsFactors = FALSE)

input <- llply(1:nrow(df), function(i) {
  set.seed(seed.value)
  gas <- df$gas[i]  
  nsensors <- df$nsensors[i]
  beta <- df$beta[i]  
  
  set.seed(seed.value)
  sa <- SensorArray(num = par.num, nsensors = nsensors, beta = beta, dsd = par.dsd)
  
  set <- paste(gas, gas_to_conc(gas))
  sc <- Scenario(T = set, nT = nT, V = set, nV = nV, randomize = TRUE)
      
  list(gas = gas, nsensors = nsensors, beta = beta, sa = sa, set = set, sc = sc)
}, .parallel = TRUE) 

### output (generate data)
output <- llply(input, function(x) {
  set.seed(seed.value)
  
  conc <- getConc(x$sc)
  sdata <- predict(x$sa, conc, nclusters = cores)
  
  df <- sdata.frame(x$sa, conc = conc, sdata = sdata, feature = "step")
  
  c(x, list(conc = conc, sdata = sdata, df = df))
})

regAsom <- output
save(regAsom, file = "regAsom.RData")
