#!/bin/bash

dirs=("ggplot2")

dir_out="output"
name="output"
file_Rmd="$name.Rmd"

opt_pandoc="-s --toc -mathjax -c $dir_out/inc/normalize.css -c $dir_out/inc/screen.css --self-contained" 

date_curr=$(date +"%m/%d/%y")


header_str_1="% Output from R code
% github.com/variani/drift-multicomp
% $date_curr"

header_str_2='
```{r setup, include = FALSE}
opts_chunk$set(fig.path = "figure/", tidy = FALSE, dev = "svg")
# upload images automatically? (identity/imgur_upload)
opts_knit$set(upload.fun = identity)
```'
for dir in ${dirs[@]} ; do
  echo " dir: $dir"
  files=$(ls $dir | grep R | grep '^[0-9][0-9]-') # ) # R files like 01-script.R

  echo " * file processing: R > Rmd"
  echo "$header_str_1" > $file_Rmd
  echo "$header_str_2" >> $file_Rmd

  echo "# $dir" >> $file_Rmd

  pat='```'
  for file in $files ; do
    echo $file
  
    echo "## $file" >> $file_Rmd
    echo "$pat{r $file}" >> $file_Rmd
    cat $dir/$file >> $file_Rmd
    echo "$pat" >> $file_Rmd
  done

  echo " * knitr: Rmd -> md"
  R -q -e 'library(knitr);knit("output.Rmd")'

  echo " * pandoc: md -> html"
  cmd="pandoc $opt_pandoc $name.md -o $dir_out/$name-$dir.html"
  #echo "cmd: $cmd"
  $cmd
  
  echo " * clean"
  rm -rf figure/ cache/ output.md output.Rmd
  
  echo " * ls"
  ls $dir_out/ | grep html
done

