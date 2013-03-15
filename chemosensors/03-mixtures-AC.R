### 03-mixtures-AC.R

### include
library(chemosensors)

library(kohonen)

library(plyr)
library(ggplot2)

library(doMC)

### parameters
seed.value <- 12

gnames <- c("A", "C")

cores <- 2

### parallel
if(cores > 1) {
  registerDoMC(cores = cores)
}

### data
load("chemosensors/data/mixturesAC.RData")

sa <- mixturesAC[[5]]$sa
df <- mixturesAC[[5]]$df

df <- sdata.frame(sa, df = df, feature = "step")
#df <- subset(df, glab == "A, C")

conc <- as.matrix(subset(df, select = gnames(sa)))
sdata <- as.matrix(subset(df, select = snames(sa)))

X <- as.matrix(subset(df, select = snames(sa)))
Y <- as.matrix(subset(df, select = gnames))
training <- df$set == "T"

#for(i in 1:ncol(Y)) {
#  Y[, i] <- Y[, i] / max(Y[, i])
#}
  
X.train <- X[training, ]
X.test <- X[-training, ]

X.train <- scale(X.train)
X.test <- scale(X.test, center = attr(X.train, "scaled:center"), scale = attr(X.train, "scaled:scale"))

Y.train <- Y[training, ]
Y.test <- Y[-training, ]

set.seed(seed.value)
mod <- xyf(data = X.train, Y = Y.train,
  xweight = .5, grid = somgrid(4, 3, "rectangular"), rlen = 500)

stopifnot(mod$contin)

### plot model

opar <- par(mfrow = c(3, 3))

# plot type 'counts'
plot(mod, "counts")

# plot type `property`
plot(mod, "property", property = predict(mod)$unit.prediction[, "A"], main = "A")
plot(mod, "property", property = predict(mod)$unit.prediction[, "C"], main = "C")

# plot type 'mapping'
Y.class <- as.factor(with(df, glab[set == "T"]))
Y.lab <- as.factor(with(df, lab[set == "T"]))

classes <- levels(Y.class)
colors <- c("blue", "green", "yellow", "red")

plot(mod, type = "mapping", pch = 1, main = "All", keepMargins = TRUE)

for (i in seq(along = classes)) {
  ind <- Y.class == classes[i]
  X.class <- X.train[ind, ]
  X.map <- map(mod, X.class)

  plot(mod, "mapping", classif = X.map, col = colors[as.numeric(factor(Y.lab[ind]))], pch = 1, main = classes[i], 
    bgcol = gray(0.85), keepMargins = TRUE)
}


par(opar)

### prediction
Yp <- predict(mod, newdata = X.train)$prediction

RMSE.train <- apply(Y.train - Yp, 2, function(x) sqrt(mean(x^2)))

Yp <- predict(mod, newdata = X.test)$prediction

RMSE.test <- apply(Y.test - Yp, 2, function(x) sqrt(mean(x^2)))

### print results
print(apply(Y, 2, quantile))

print(RMSE.train)
print(RMSE.test)

