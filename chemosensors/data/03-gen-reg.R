### 03-gen-reg.R

### include
library(chemosensors)

### par
cores <- 2

seed.value <- 1

gases <- c("A", "B", "C")
nSet <- 20

num1 <- 1:3
num2 <- c(13:14, 17) 
num <- c(1:3, 13:14, 17)
nsensors <- 24

### sa
set.seed(1)
sa <- SensorArray(num = num, nsensors = nsensors)

### input (conc)
gas_to_conc <- function(gas)
{
  switch(gas,
    "A" = c(0.01, 0.02, 0.05, 0.1),
    "B" = c(0.01, 0.02, 0.05, 0.1),
    "C" = c(0.1, 0.4, 1, 2),        
    stop("Error in 'gas_to_conc': switch."))
}

input <- llply(gases, function(gas) {
  dataset.name <- paste("reg", gas, sep = "")
  rdata.filename <- paste(dataset.name, "RData", sep = ".")
  
  set <- paste(gas, gas_to_conc(gas))
  
  set.seed(seed.value)
  sc <- Scenario(T = set, nT = nSet, V = set, nV = nSet, randomize = TRUE)

  conc <- getConc(sc)
  cf <- sdata.frame(sc)
    
  list(gas = gas, 
    dataset.name = dataset.name, rdata.filename = rdata.filename,
    sc = sc, conc = conc, cf = cf)
})
names(input) <- gases

### output (generate data)
output <- llply(input, function(x) {
  set.seed(seed.value)
  sdata <- predict(sa, x$conc, nclusters = cores)
  
  df <- sdata.frame(sa, cf = x$cf, sdata = sdata, feature = "transient")
  
  #cmd <- paste(x$dataset.name, " <- df")
  #eval(parse(text = cmd))
  
  c(x, list(sdata = sdata, df = df))
})
  
### save to RData file
regA <- output$A$df
regB <- output$B$df
regC <- output$C$df

save(sa, regA, regB, regC, file = "reg.RData")
