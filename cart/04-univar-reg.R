###
# 
# References.
# list of functions @http://cran.r-project.org/web/packages/caret/caret.pdf 

### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

### data
set2 <- c("A 0.01", "A 0.02", "A 0.05") 

sa <- SensorArray(num = 1:5, dsd = 0)

sc <- Scenario(T = rep(set, 20), V = rep(set, 10))
  
conc <- getConc(sc)
cf <- sdata.frame(sc)

sdata <- predict(sa, conc, nclusters = 2)

p1 <- plotSignal(sa, set = set)
p1

p2 <- plotPCA(sa, conc = conc, sdata = sdata, air = FALSE)
p2 

### divistion into training/test sets
df <- cbind(sdata, cf)
names(df)[1:ncol(sdata)] <- paste("S", 1:ncol(sdata), sep = "")

# remove air
df <- subset(df, lab != "Air")

ind.train <- (df$set == "T")

