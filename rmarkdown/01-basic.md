# My title.
Joe Smith  
`r Sys.Date()`  









# Figures

## Side-by-side figures

<img src="figures/fig_side_by_side, -1.png" width="50%" /><img src="figures/fig_side_by_side, -2.png" width="50%" />

# Tables


| Sepal.Length   | Sepal.Width   | Petal.Length   | Petal.Width   | Species   |
|:---------------|:--------------|:---------------|:--------------|:----------|
| 5.1            | 3.5           | 1.4            | 0.2           | setosa    |
| 4.9            | 3             | 1.4            | 0.2           | setosa    |
| 4.7            | 3.2           | 1.3            | 0.2           | setosa    |
| 4.6            | 3.1           | 1.5            | 0.2           | setosa    |
| 5              | 3.6           | 1.4            | 0.2           | setosa    |
| 5.4            | 3.9           | 1.7            | 0.4           | setosa    |

# Custom header

Specify the custom header:

```
output:
  html_document:
    includes:
      in_header: header.html
```

## Disable Google robots

Add the following line to disable that your web page is indexed by Google, etc.

```
<meta name="robots" content="noindex">
```

