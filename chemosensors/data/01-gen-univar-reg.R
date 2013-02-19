### 01-gen-univar-reg.R

### include
library(chemosensors)

### par
nsensors <- 8

### sa/sc
sa <- SensorArray(num = 1:nsensors, ssd = 1, dsd = 0)

set1 <- c("A 0.01", "A 0.02", "A 0.05") # the working range (more linear)
set2 <- c("A 0.001", "A 0.005", "A 0.01", "A 0.02", "A 0.05", "A 0.1") # a complete range of concentrations

sc1 <- Scenario(T = sample(rep(set1, 20)), V = sample(rep(set1, 20)))
sc2 <- Scenario(T = sample(rep(set2, 20)), V = sample(rep(set2, 20)))

### generate data  
conc1 <- getConc(sc1)
conc2 <- getConc(sc2)

sdata1 <- predict(sa, conc1, nclusters = 2)
sdata2 <- predict(sa, conc2, nclusters = 2)

### save data
sdata1 <- as.data.frame(sdata1)
sdata2 <- as.data.frame(sdata2)

names(sdata1) <- paste("S", 1:nsensors, sep = "")
names(sdata2) <- paste("S", 1:nsensors, sep = "")

df1 <- sdata.frame(sc1)
df2 <- sdata.frame(sc2)

df1 <- cbind(sdata1, df1)
df2 <- cbind(sdata2, df2)

RegUniA <- list(sa = sa, set1 = set1, set2 = set2, df1 = df1, df2 = df2)
save(RegUniA, file = "RegUniA.RData")

### plotting
p1 <- plotSignal(sa, set = set1)
p1

p2 <- plotSignal(sa, set = set2)
p2

p3 <- plotPCA(sa, conc = conc1, sdata = sdata1, air = FALSE)
p3 

p4 <- plotPCA(sa, conc = conc2, sdata = sdata2, air = FALSE)
p4
