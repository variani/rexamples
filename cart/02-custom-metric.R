# @ ?train (see Examples section)

### include
library(caret)
library(plyr)
library(ggplot2)

### data
data(iris)
iris <- subset(iris, Species == "setosa")

str(iris)

X <- subset(iris, select = c("Sepal.Length", "Petal.Length"))
Y <- subset(iris, select = "Petal.Width")
# See the reasoning for the model by plotting
# qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)

### split data into T/V
ind.tr <- 1:30

Y.tr <- Y[ind.tr, ]
Y.val <- Y[-ind.tr, ]

X.tr <- X[ind.tr, ]
X.val <- X[-ind.tr, ]

### summary function
madSummary <- function(data, lev = NULL, model = NULL) 
{
  out <- mad(data$obs - data$pred, na.rm = TRUE)  
  names(out) <- "RMSEsum"
  out
}


#####     
### fit a model
trControl <- trainControl(summaryFunction = madSummary)
tuneGrid <- expand.grid(.size = c(1, 2), .decay = c(0, 1e-4, 0.01))

fit <- train(X.tr, Y.tr, 
  preProcess = c("center", "scale"),
  trControl = trControl, metric = "RMSEsum", maximize = FALSE,
  method = "nnet", tuneGrid = tuneGrid, 
  trace = FALSE)

fit

plot(fit)
