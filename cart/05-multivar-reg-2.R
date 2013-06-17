# @ http://stats.stackexchange.com/questions/4517/regression-with-multiple-dependent-variables
# - 'train' does NOT support multivariate response 'Y'
# - ?pls::cppls.fit

### include
library(plyr)
library(ggplot2)
library(kohonen)
library(pls)

### par

### data
data(nir, package = "kohonen")

Y <- nir$composition
X <- nir$spectra
training <- nir$training

Xtrain <- X[training, ]
Ytrain <- Y[training, ]

df <- data.frame(training = nir$training)
df$composition <- nir$composition
df$spectra <- nir$spectra

mod <- cppls(composition ~ spectra, 10, data = df, subset = training)

###
data(mayonnaise)

# Create dummy response
mayonnaise$dummy <- I(model.matrix(~y-1, data.frame(y=factor(mayonnaise$oil.type))))

# Predict CPLS scores for test data
may.cpls <- cppls(dummy ~ NIR, 10, data = mayonnaise, subset = train)
may.test <- predict(may.cpls, newdata = mayonnaise[!mayonnaise$train,], type = "score")

