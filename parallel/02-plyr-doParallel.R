### inc
library(plyr)
library(doParallel)

### par
cores <- 2
parallel <- (cores > 1)

### parallel
if(parallel) {
  registerDoParallel(cores = cores)
}

### loop in parallel
t_parallel <- system.time({
  means <- laply(1:10, function(i) {
    x <- rnorm(1e6)
    mean(x)
  }, .parallel = parallel)
})

### a single simu. (for comparison)
t_seq <- system.time({
  means <- laply(1:10, function(i) {
    x <- rnorm(1e6)
    mean(x)
  })
})

cat(" - t_seq:\n")
print(t_seq)
cat(" - t_parallel:\n")
print(t_parallel)

cat("\n")
cat(" - speed up by factor:", t_seq[["elapsed"]] / t_parallel[["elapsed"]] , "\n")

