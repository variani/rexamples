### 
# ﻿[1] Section 6.4 Robus Regression. J. J.Faraway, Linear Models with R. CHAPMAN & HALL / CRC Texts in Statistical Science Series, 2005.
# [2] http://www.maths.bath.ac.uk/~jjf23/LMR/scripts/errprob.R

### data
data(gala, package='faraway')

### Model 0: lm
gl <- lm(Species ~ Area + Elevation + Nearest + Scruz + Adjacent, gala) 

print(summary(gl))

### Model 1: M-estimation, Huber's method
library(MASS)
gr <- rlm(Species ~ Area + Elevation + Nearest + Scruz + Adjacent, gala, 
  method = "M", scale.est = "Huber")

print(summary(gr))

# Model 2: 
#library(quantreg)
#attach(gala)
#gq <- rq(Species ~Area+Elevation+Nearest+Scruz+Adjacent)
#summary(gq)
#detach(gala)
