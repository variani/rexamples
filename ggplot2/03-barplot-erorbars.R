# @ http://www.imachordata.com/lets-all-go-down-to-the-barplot/

### include
library(ggplot2)
library(plyr)

### data
data(mpg)

# boxplot
p1 <- qplot(class, hwy, fill = factor(year), data = mpg, geom = "boxplot", position = "dodge")
p1

# create a 'stat' data frame
hwy.stat <- ddply(mpg, c("class", "year"), summarise,
  hwy.avg = mean(hwy), 
  hwy.sd = sd(hwy))

# create the plot
p2 <- qplot(class, hwy.avg, fill = factor(year), data = hwy.stat, geom = "bar", position = "dodge")

# plot #1
p3 <- p2 + geom_errorbar(aes(ymax = hwy.avg + hwy.sd, ymin = hwy.avg - hwy.sd), position = "dodge")

# plot #2
dodge <- position_dodge(width = 0.9) 
p4 <- p2 + geom_errorbar(aes(ymax = hwy.avg + hwy.sd, ymin = hwy.avg - hwy.sd), position = dodge, width = 0.15)

# plot #3
dodge <- position_dodge(width = 0.9) 
p5 <- p2 + geom_linerange(aes(ymax = hwy.avg + hwy.sd, ymin = hwy.avg - hwy.sd), position = dodge)
