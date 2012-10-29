### include
library(ggplot2)
library(reshape)

### data
data(iris)

# a kind of 3D graphics
qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)

summary(iris)

# - for some cases it is needed `include.lowest = TRUE`
iris <- mutate(iris,
  Sepal.Length = cut(Sepal.Length, seq(4, 8, 0.5)),
  Petal.Length = cut(Petal.Length, seq(1, 7, 0.5), include.lowest = TRUE),
  Petal.Width = cut(Petal.Width, seq(0, 3, 0.5)))

qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)

### heatmap
ggplot(iris, aes(Sepal.Length, Petal.Length, fill = Petal.Width)) + geom_tile()

last_plot() + facet_wrap(~ Species)

### switch to a smaller dataset
versicolor <- subset(iris, Species == "versicolor")
versicolor <- mutate(versicolor, 
  Petal.Width = factor(Petal.Width))
  
ggplot(versicolor, aes(Sepal.Length, Petal.Length, fill = Petal.Width)) + geom_tile()

### 
last_plot() + scale_fill_brewer(palette="Set1") #+ 
#  scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0))
#  opts(axis.ticks = theme_blank(), axis.text.x = theme_text(angle = 90, hjust = 0, colour = "grey50"))  
