### 01-gen-univar-reg.R

### include
library(chemosensors)

### par
num <- c(1:3, 13:14)
nsensors <- 15

### sa
set.seed(1)
sa <- SensorArray(num = num, nsensors = nsensors)

### conc
set <- c("A 0.01", "A 0.02", "A 0.05", "A 0.1")

set.seed(1)
sc <- Scenario(T = set, nT = 20, V = set, nV = 20, randomize = TRUE)

cf <- sdata.frame(sc)
conc <- getConc(sc)

### generate data  
set.seed(1)
sdata <- predict(sa, conc, nclusters = 2)

### save to 'df'
df <- sdata.frame(sa, cf = cf, sdata = sdata, feature = "step")

### save to RData file
regA <- df

save(sa, regA, file = "regA.RData")
