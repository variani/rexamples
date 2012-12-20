### include
library(chemosensors)

library(caret)

library(plyr)
library(ggplot2)

### data
set1 <- c("A 0.001", "A 0.005", "A 0.01", "A 0.02", "A 0.05", "A 0.1") # a complete range of concentrations
set2 <- c("A 0.01", "A 0.02", "A 0.05") # the working range (more linear)

sa <- SensorArray(num = 1:5, dsd = 0)

sc1 <- Scenario(T = rep(set1, 20), V = rep(set1, 10))
sc2 <- Scenario(T = rep(set2, 20), V = rep(set2, 10))
  
conc1 <- getConc(sc1)
cf1 <- sdata.frame(sc1)

conc2 <- getConc(sc2)
cf2 <- sdata.frame(sc2)

sdata1 <- predict(sa, conc1, nclusters = 2)
sdata2 <- predict(sa, conc2, nclusters = 2)

p1 <- plotSignal(sa, set = set1)
p1

p2 <- plotSignal(sa, set = set2)
p2


p3 <- plotPCA(sa, conc = conc1, sdata = sdata1, air = FALSE)
p3 

p4 <- plotPCA(sa, conc = conc2, sdata = sdata2, air = FALSE)
p4

### divistion into training/test sets
df1 <- cbind(sdata1, cf1)
names(df1)[1:ncol(sdata1)] <- paste("S", 1:ncol(sdata1), sep = "")

df2 <- cbind(sdata2, cf2)
names(df2)[1:ncol(sdata2)] <- paste("S", 1:ncol(sdata2), sep = "")

# remove air
df1 <- subset(df1, lab != "Air")
df2 <- subset(df2, lab != "Air")

ind.train1 <- (df1$set == "T")
ind.train2 <- (df2$set == "T")

X1 <- df1[, grep("^S", names(df1)), drop = FALSE]
Y1 <- df1[, grep("A", names(df1)), drop = FALSE]

X2 <- df2[, grep("^S", names(df2)), drop = FALSE]
Y2 <- df2[, grep("A", names(df2)), drop = FALSE]

Y.train1 <- Y1[ind.train1, , drop = FALSE]
Y.test1 <- Y1[-ind.train1, , drop = FALSE]

Y.train2 <- Y2[ind.train2, , drop = FALSE]
Y.test2 <- Y2[-ind.train2, , drop = FALSE]

X.train1 <- X1[ind.train1, , drop = FALSE]
X.test1 <- X1[-ind.train1, , drop = FALSE]

X.train2 <- X2[ind.train2, , drop = FALSE]
X.test2 <- X2[-ind.train2, , drop = FALSE]

### fit
formula1 <- formula(paste(paste(colnames(Y.train1), collapse = "+"), "~", paste(colnames(X.train1), collapse = "+")))
data1 <- cbind(X.train1, Y.train1)

formula2 <- formula(paste(paste(colnames(Y.train2), collapse = "+"), "~", paste(colnames(X.train2), collapse = "+")))
data2 <- cbind(X.train2, Y.train2)

trControl <- trainControl(method = "repeatedcv", number = 10) ## 10-fold CV
tuneGrid <- expand.grid(.decay = 1e-4, .size = c(1:6)) # we've already found `decay 1e-4` to be the best

fit1 <- train(formula1, data1, 
  method = "nnet", maxit = 1000,
  trControl = trControl, tuneGrid = tuneGrid, trace = FALSE)
  
plot(fit1)  

fit2 <- train(formula2, data2, 
  method = "nnet", maxit = 1000,
  trControl = trControl, tuneGrid = tuneGrid, trace = FALSE)
  
plot(fit2)  
