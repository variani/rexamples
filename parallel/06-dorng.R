     (fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy))### ref
# @ http://stackoverflow.com/questions/8358098/how-to-set-seed-for-random-simulations-with-foreach-and-domc-packages

### inc
library(doParallel)
library(doRNG)

### par
cores <- 2

### loop in seq
registerDoSEQ()

registerDoRNG(123) # set.seed

t_seq <- system.time({
  means_seq <- foreach(i = 1:10) %dorng% {
    x <- rnorm(1e3)
    mean(x)
  }
})

stopImplicitCluster()

### loop in parallel
registerDoParallel(cores = cores)

registerDoRNG(123) # set.seed

t_par <- system.time({
  means_par <- foreach(i = 1:10) %dorng% {
    x <- rnorm(1e3)
    mean(x)
  }
})

stopImplicitCluster()

### check
identical(unlist(means_seq), unlist(means_par))

