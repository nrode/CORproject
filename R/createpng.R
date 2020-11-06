#'@title createpng
#'
#'@description Function that takes a png and return a vector with the rows found by tesseract
#'
#'@param x Numeric vector
#'
#'@return A png with the simulated data
#'
#'@export
#'
#'@examples
#'createpng(csvpath="data/FitnessExperimentalDesign_G60Final.csv", outputpng="data/test.png")


createpng <- function(csvpath="data/FitnessExperimentalDesign_G60Final.csv", outputpng="data/test.png"){ ##Path to the input .csv and output .png files

set.seed(1)
data <- read.csv(csvpath, head=TRUE, sep=";")

head(data)

library(tidyverse)

## Clean names
names(data) <- janitor::make_clean_names(names(data))

## Simulate dataset
data_temp <- data %>%
  mutate(nbadrep1=rpois(n=nrow(data), lambda = 20))

data_temp
## Export dataset
write_csv(data_temp, file= "data/fitness.csv")

library(gridExtra)
png(outputpng, height = 200*nrow(data_temp), width = 500*ncol(data_temp), res=600)
grid.table(data_temp,  theme = ttheme_minimal())
dev.off()

}
