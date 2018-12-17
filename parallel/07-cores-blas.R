# @ https://stackoverflow.com/questions/48410130/is-r-creating-too-many-threads-on-startup

library(RhpcBLASctl)

n <- 20e3
p <- 1e3
mat <- matrix(runif(n*p), n, p)

# by default: using all cores, as `elapsed` < `user`
system.time(crossprod(mat))
>   user  system elapsed
>  0.605   0.001   0.176

# check #cores
get_num_cores()
> [1] 4

# it should work in principle, but no luck on my machine
blas_set_num_threads(1)
system.time(crossprod(mat))
#   user  system elapsed
#  0.606   0.002   0.176
