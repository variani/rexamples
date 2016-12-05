# https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html
# https://github.com/baptiste/gridextra/wiki/arranging-ggplot

library(ggplot2)
library(gridExtra)

p1 <- qplot(rnorm(100))
p2 <- qplot(rchisq(100, 1))
p3 <- qplot(rcauchy(100))

layout <- rbind(c(1, 2), c(3, 3))

grid.arrange(p1, p2, p3, layout_matrix = layout)
