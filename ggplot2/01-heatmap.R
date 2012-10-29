### include
library(ggplot2)
library(reshape)

### data
data(iris)

# a kind of 3D graphics
qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)

summary(iris)

# - `as.character` is used to get rid of factors (latern on it is easier to add new lables)
# - for some cases it is needed `include.lowest = TRUE`
iris <- mutate(iris,
  Sepal.Length = as.character(cut(Sepal.Length, seq(4, 8, 0.5))),
  Petal.Length = as.character(cut(Petal.Length, seq(1, 7, 0.5), include.lowest = TRUE)),
  Petal.Width = as.character(cut(Petal.Width, seq(0, 3, 0.5))))

qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)

### heatmap
ggplot(iris, aes(Sepal.Length, Petal.Length, fill = Petal.Width)) + geom_tile()

last_plot() + facet_wrap(~ Species)

### switch to a smaller dataset
versicolor <- subset(iris, Species == "versicolor")

ggplot(versicolor, aes(Sepal.Length, Petal.Length, fill = Petal.Width)) + geom_tile()
