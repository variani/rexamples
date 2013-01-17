# @ http://www.jstatsoft.org/v28/i05/paper

### include
library(caret)
library(plyr)
library(ggplot2)

### data
data(iris)

str(iris)

X <- iris[, -5]
Y <- iris[, 5]

### split data into T/V
set.seed(1)
ind.tr <- createDataPartition(Y, p = 2/3, list = FALSE)

Y.tr <- Y[ind.tr]
Y.val <- Y[-ind.tr]

X.tr <- X[ind.tr, ]
X.val <- X[-ind.tr, ]

prop.table(table(Y))
prop.table(table(Y.tr))
prop.table(table(Y.val))

### pre-process data
transform <- preProcess(X.tr, method = c("pca"), tresh = 0.95)
transform

T.tr <- predict(transform, X.tr)
T.val <- predict(transform, X.val)

### fit a model
trControl <- trainControl(method = "repeatedcv", number = 10) ## 10-fold CV
tuneGrid <- expand.grid(.size = c(1, 2, 3), .decay = c(0, 1e-4, 0.01))

fit <- train(T.tr, Y.tr, 
  trControl = trControl, 
  method = "nnet", tuneGrid = tuneGrid, #tuneLength = 4,
  trace = FALSE)

fit

plot(fit)

model <- fit$finalModel

### prediction
pf <- extractPrediction(list(fit), testX = T.val, testY = Y.val) # Prediction data Frame
head(pf)

pf <- mutate(pf,
  predicted.ok = factor(obs == pred, levels = c("TRUE", "FALSE")))
  
# statistics for validation set
pf.val <- subset(pf, dataType == "Test")
stat <- confusionMatrix(pf.val$pred, pf.val$obs)
stat

### final plots
pf.tr <- subset(pf, dataType == "Training")
df <- cbind(pf.tr, T.tr) # Data Frame for plotting

p1 <- ggplot(df, aes(PC1, PC2)) + 
  geom_point(colour = "grey50", aes(size = predicted.ok)) +
  geom_point(aes(colour = obs)) + ggtitle("Training Set")
p1

df <- cbind(pf.val, T.val) # Data Frame for plotting

p2 <- ggplot(df, aes(PC1, PC2)) + 
  geom_point(colour = "grey50", aes(size = predicted.ok)) +
  geom_point(aes(colour = obs)) + ggtitle("Validation Set")
p2

