# via @ https://github.com/hadley/plyr/issues/16

library(plyr)
library(doMC)

library(ggplot2)

library(neuralnet)

### parameters
options(cores = 2, stringsAsFactors = FALSE)

layers <- 1 # just one layer/one node in ANN

rounds <- 1:10 # 10 rounds in resampling (bootstrapping)

### data
data(iris)

dat <- mutate(iris,
  setosa = Species == "setosa",
  versicolor = Species == "versicolor",
  virginica = Species == "virginica")

str(dat)

### partition to tr/test sets
set.seed(1)
ind.prediction <- rbinom(nrow(dat), size = 1, prob = 0.25)
table(ind.prediction)

ind.model <- which(ind.prediction == 0)
ind.predict <- which(ind.prediction == 1)

dat.model <- dat[ind.model, ]

### prepare rounds for resampling
n.tr <- floor(0.75 * nrow(dat.model))
n.val <- nrow(dat.model) - n.tr
n.test <- nrow(dat) - n.tr - n.val

dat.rounds <- llply(rounds, function(i, sort = TRUE) {
  set.seed(1)
  ind.tr <- sample(ind.model, n.tr, replace = FALSE)
  if(sort) ind.tr <- sort(ind.tr)
  
  ind.val <- ind.model[!(ind.model %in% ind.tr)]
  list(round = i, ind.tr = ind.tr, ind.val = ind.val)
})

dat.rounds[[1]]

ind.predict

### compute a model
#dat.formula <- setosa + versicolor + virginica ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
dat.formula <- Sepal.Length ~ Sepal.Width

run.round <- function(dat, formula, rounds, i)
{
  ind.tr <- rounds[[i]][["ind.tr"]]
  dat <- dat[ind.tr, ]
  
  model <- neuralnet(formula, dat, hidden = layers)
  
  list(error.tr = model$result.matrix["error", ])
}

registerDoMC()

t1 <- system.time({
  out <- llply(rounds, function(i) {
    run.round(dat, dat.formula, dat.rounds, i)
  }, .parallel = FALSE)
})  

t2 <- system.time({
  out <- llply(rounds, function(i) {
    run.round(dat, dat.formula, dat.rounds, i)
  }, .parallel = TRUE)
})

# output data.frame
of <- data.frame(round = rounds,
  error.tr = laply(out, function(x) x[["error.tr"]]))

qplot(round, error.tr, data = of) + geom_line()

# times
t1

t2
