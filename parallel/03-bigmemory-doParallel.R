### refs
# - http://www.chrisbilder.com/compstat/presentations/Xiaojuan/Presentation_bigmemory.pdf
# - http://www.bytemining.com/wp-content/uploads/2010/08/r_hpc_II.pdf
# - https://rstudio-pubs-static.s3.amazonaws.com/72295_692737b667614d369bd87cb0f51c9a4b.html
#
### output
# 1: shared TRUE
#   user  system elapsed
#  0.018   0.005   0.062
#
#> print(t_par)
#   user  system elapsed
#  0.019   0.005   0.024
#
# 2. shared FALSE
#> print(t_seq)
#   user  system elapsed
#  0.018   0.004   0.022
#
#> print(t_par)
#   user  system elapsed
#  0.020   0.005   0.024

### inc
library(bigmemory)

library(plyr)
library(doParallel)

### options
options(bigmemory.typecast.warning = FALSE)

### par
shared <- FALSE

cores <- 2
parallel <- (cores > 1)

### parallel
if(parallel) {
  registerDoParallel(cores = cores)
}

### data
#mat <- iris[, -5]
n <- 10e3
m <- 1e3
mat <- matrix(rbinom(m*n, 1, 0.5), nrow = n, ncol = m)

if(shared) {
  dat <- as.big.matrix(mat, type = "char")
  desc <- describe(dat)
} else {
  dat <- as.big.matrix(mat, type = "char", 
    backingfile = "mat.bin", descriptorfile = "mat.desc")
  desc <- describe(dat)
}

rm(mat)

### seq
num_batches <- cores
batch_size <- ceiling(ncol(dat) / num_batches)

beg <- seq(1, ncol(dat), by = batch_size)
end <- c(beg[-1] - 1, ncol(dat))
  
### run seq.
t_seq <- system.time({
   bigdat <- attach.big.matrix(desc) 
   dat <- bigdat[, ]
     
   colMeans(dat)
})

### run in parallel
t_par <- system.time({
  out_par <- laply(1:num_batches, function(i) {
    bigdat <- attach.big.matrix(desc)
    
    ind <- seq(beg[i], end[i])
    dat_i <- bigdat[, ind]
    
    colMeans(dat_i)
  })
})

### print
print(t_seq)
print(t_par)

