### output
# cores == 1:
#   user  system elapsed 
#  1.900   0.048   1.953 
# cores == 2:
#   user  system elapsed 
#  0.988   0.044   1.183 

### inc
library(plyr)
library(doParallel)

### par
cores <- 2
parallel <- (cores > 1)

### parallel
if(parallel) {
  registerDoParallel(cores = cores)
} else {
  registerDoSEQ()
}

### loop in parallel
t_loop <- system.time({
  means <- foreach(i = 1:10) %dopar% {
    x <- rnorm(1e6)
    mean(x)
  }
})

cat(" - t_loop:\n")
print(t_loop)

### clean
stopImplicitCluster()

