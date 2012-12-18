### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

### data
set <- c("A 0.001", "A 0.005", "A 0.01", "A 0.02", "A 0.05", "A 0.1")

sa <- SensorArray(num = 3:5, dsd = 0)

sc <- Scenario(T = rep(set, 20), V = rep(set, 10))
conc <- getConc(sc)
sdata <- predict(sa, conc, nclusters = 2)

p1 <- plotSignal(sa, set = set)
p1

