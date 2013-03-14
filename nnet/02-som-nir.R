#
# Data set:
# Data set `nir` contains NIR spectra of 95 ternary mixtures.

### include
library(kohonen)

### data
data(nir, package = "kohonen")

Y <- nir$composition
X <- nir$spectra
training <- nir$training

Xtrain <- X[training, ]
Ytrain <- Y[nir$training, ]

# check `Y` is properly scaled
Y.residual <- abs(rowSums(Y) - 1)
stopifnot(any(Y.residual < 1e-2))

### compute model
set.seed(3) # to replicate example in `?nir`
mod <- xyf(data = Xtrain, Y = Ytrain,
  xweight = .75, grid = somgrid(6, 6, "hexagonal"), rlen = 500, 
  contin = TRUE)

### check the output model `mode` is ok
stopifnot(mod$contin)
  
### plot model

# plot type `property`
opar <- par(mfrow = c(2, 2))

plot(mod, "property", property = predict(mod)$unit.prediction[, "ethanol"], main = "ethanol")
plot(mod, "property", property = predict(mod)$unit.prediction[, "water"], main = "water")
plot(mod, "property", property = predict(mod)$unit.prediction[, "isopropanol"], main = "isopropanol")

par(opar)

# plot type `mapping`
Y.class <- rep(as.character(NA), nrow(Y))

ind <- apply(Y, 1, function(x) x[2] < 0.16)
Y.class[ind] <- "water < 0.16"

ind <- apply(Y, 1, function(x) x[2] > 0.5)
Y.class[ind] <- "water > 0.5"

Y.class <- as.factor(Y.class)

classes <- levels(Y.class)
colors <- c("yellow", "green", "blue", "red", "orange")

opar <- par(mfrow = c(2, 2))

plot(mod, type = "mapping", pch = 1, main = "All", keepMargins = TRUE)

for (i in seq(along = classes)) {
  X.class <- subset(Xtrain, Y.class[training] == classes[i])
  X.map <- map(mod, X.class)

  plot(mod, "mapping", classif = X.map, col = colors[i], pch = 1, main = classes[i], 
    bgcol = gray(0.85), keepMargins = TRUE)
}
par(opar)

### prediction
Yp <- predict(mod, newdata = Xtrain)$prediction

RMSE.train <- apply(Ytrain - Yp, 2, function(x) sqrt(mean(x^2)))

Xtest <- X[-training, ]
Ytest <- Y[-training, ]
Yp <- predict(mod, newdata = Xtest)$prediction

RMSE.test <- apply(Ytest - Yp, 2, function(x) sqrt(mean(x^2)))

### print results
print(apply(Y, 2, quantile))

print(RMSE.train)
print(RMSE.test)
