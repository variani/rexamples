# @ http://www.jstatsoft.org/v28/i05/paper

### include
library(caret)

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


