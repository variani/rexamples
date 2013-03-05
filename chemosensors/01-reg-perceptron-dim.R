### 01-reg-perceptron-dim.R
#
# About.
# We'd like to see how non-linear are the sensors/data generation models in the package 'chemosensors'.
# A synthetic experiment is proposed:
# - employ data from the only gas, e.g. 'A';
# - use a perceptron as a regressor, since the number of neurons is a measure of dimensionality (of the perceptron's output).
# 
# Coding details.
# - We use two scenarios `sc1` and `sc2` different in the gas concentrations involved.
#   The first one `sc1` covers the complete range (from 0.001 up to 0.1 % vol.),
#   while the second one `sc2` contains concentrations in relatevely linear range.

### include
library(chemosensors)

#library(caret)

#library(devtools)
#load_all("tmp/pkg/caret/")
library(parc)

library(plyr)
library(ggplot2)

### load/stat data
load("chemosensors/data/RegUniA.RData") # -> sa, set1, set2, df1, df2

names(RegUniA)

set1 <- RegUniA$set1  
set2 <- RegUniA$set2

sa <- RegUniA$sa    

df1 <- RegUniA$df1
df2 <- RegUniA$df2   

p1 <- qplot(as.factor(A), S1, data = df1, geom = "boxplot")
p1

p2 <- qplot(as.factor(A), S1, data = df2, geom = "boxplot")
p2

p3 <- plotSignal(sa, set = set1)
p3

p4 <- plotSignal(sa, set = set2)
p4

p5 <- plotPCA(sa, set = rep(set1, 3), air = FALSE)
p5 

p6 <- plotPCA(sa, set = rep(set2, 3), air = FALSE)
p6

### divistion into training/test sets
ind.train1 <- 1:nrow(df1) <= (2/3) * nrow(df1) # first 2/3 of samples for T
ind.train2 <- 1:nrow(df2) <= (2/3) * nrow(df2) # first 2/3 of samples for T

X1 <- df1[, grep("^S", names(df1)), drop = FALSE]
Y1 <- df1[, grep("A", names(df1)), drop = FALSE]

X2 <- df2[, grep("^S", names(df2)), drop = FALSE]
Y2 <- df2[, grep("A", names(df2)), drop = FALSE]

Y.train1 <- Y1[ind.train1, , drop = FALSE]
Y.test1 <- Y1[-ind.train1, , drop = FALSE]

Y.train2 <- Y2[ind.train2, , drop = FALSE]
Y.test2 <- Y2[-ind.train2, , drop = FALSE]

X.train1 <- X1[ind.train1, , drop = FALSE]
X.test1 <- X1[-ind.train1, , drop = FALSE]

X.train2 <- X2[ind.train2, , drop = FALSE]
X.test2 <- X2[-ind.train2, , drop = FALSE]

### fit

