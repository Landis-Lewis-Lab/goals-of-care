# Install packages required for generating reports 

if(require('ggplot2', quietly=TRUE) == FALSE){
  install.packages('ggplot2')
} else {
  print('ggplot2 already installed.')
}

if(require('ggthemes', quietly=TRUE) == FALSE){
  install.packages('ggthemes')
} else {
  print('ggthemes already installed.')
}

if(require('tidyverse', quietly=TRUE) == FALSE){
  install.packages('tidyverse')
} else {
  print('tidyverse already installed.')
}

# knitr use here requires pandoc 
if(require('knitr', quietly=TRUE) == FALSE){
  install.packages('knitr', dependencies = TRUE)
} else {
  print('knitr already installed.')
}

if(require('rmarkdown', quietly=TRUE) == FALSE){
  install.packages('rmarkdown')
} else {
  print('rmarkdown already installed.')
}