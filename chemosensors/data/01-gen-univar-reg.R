### 01-gen-univar-reg.R

### include
library(chemosensors)

### sa/sc
sa <- SensorArray(num = 1:8, dsd = 0)

set1 <- c("A 0.01", "A 0.02", "A 0.05") # the working range (more linear)
set2 <- c("A 0.001", "A 0.005", "A 0.01", "A 0.02", "A 0.05", "A 0.1") # a complete range of concentrations

sc1 <- Scenario(T = rep(set1, 20), V = rep(set1, 10))
sc2 <- Scenario(T = rep(set2, 20), V = rep(set2, 10))

### generate data  
conc1 <- getConc(sc1)
conc2 <- getConc(sc2)

sdata1 <- predict(sa, conc1, nclusters = 2)
sdata2 <- predict(sa, conc2, nclusters = 2)

### save data
df1 <- sdata.frame(sa, conc1, sdata1, "step")
df2 <- sdata.frame(sa, conc2, sdata2, "step")

save(sa, set1, set2, df1, df2, file = "reg-univar-A.RData")

### plotting
p1 <- plotSignal(sa, set = set1)
p1

p2 <- plotSignal(sa, set = set2)
p2

p3 <- plotPCA(sa, conc = conc1, sdata = sdata1, air = FALSE)
p3 

p4 <- plotPCA(sa, conc = conc2, sdata = sdata2, air = FALSE)
p4
