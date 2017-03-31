### inc
library(plyr)
library(doMC)

### par
cores <- 2
parallel <- (cores > 1)

### parallel
if(parallel) {
  registerDoMC(cores = cores)
}

### run
out <- llply(1:10, function(x) {
  x^2
}, .parallel = parallel)
