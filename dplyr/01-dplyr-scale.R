### scale either column-wise or row-wise

### inc
library(tidyverse)
library(magrittr)

### data
dat <- as_data_frame(iris[, -5])

### (1) scale column-wide
fun_center <- function(x) scale(x, center = TRUE, scale = FALSE)
fun_scale <- function(x) scale(x, center = TRUE, scale = TRUE)

dat1 <- mutate_all(dat, funs(fun_center))
dat2 <- mutate_all(dat, funs(fun_scale))

### (2) scale row-wise
row_means <- rowwise(dat) %>% 
  do(stat = mean(as.numeric(.))) %>% 
  summarize(mean = stat) %$% mean

fun_center <- function(x, means = row_means) x - means

dat1 <- mutate_all(dat, funs(fun_center))

# note that `dat1` is used instead of `dat`
row_sds <- rowwise(dat1) %>% 
  do(stat = sd(as.numeric(.)))

# option 1  
row_sds <- row_sds %>% 
  summarize(sd = stat) %$% sd

# option 2  
#row_sds <- row_sds %>% unlist %>% as.numeric

fun_scale <- function(x, sds = row_sds) x/sds

dat2 <- mutate_all(dat1, funs(fun_scale))

### check 
mean_row1 <- dat2[1, ] %>% as.numeric %>% mean
stopifnot(abs(mean_row1) < 1e-16)

sd_row1 <- dat2[1, ] %>% as.numeric %>% sd
stopifnot(sd_row1 == 1)
