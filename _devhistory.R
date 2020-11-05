## Add .Git at the root of the project
usethis::use_git()
usethis::use_github()

## Create project in Github and follow the instructions
## Invite collaborators using the Settings directory in Github
## They can create a project on their computer using version control

## Buildignore/Gitignore
usethis::use_build_ignore("_devhistory.R")
usethis::use_build_ignore(".DS_Store")
usethis::use_git_ignore(".DS_Store")
usethis::use_build_ignore("data/.DS_Store")
usethis::use_git_ignore("data/.DS_Store")

## Create README
usethis::use_readme_rmd()

usethis::use_mit_license("Nicolas Rode")

## Add a data directory
dir.create("data")

usethis::use_r("")

data <- read.csv("./data/FitnessExperimentalDesign_G60Final.csv", head=TRUE, sep=";")

head(data)

library(tidyverse)
## Clean names
names(data) <- janitor::make_clean_names(names(data))

data_temp <- data %>%
  mutate(nbadrep1=rpois(n=nrow(data), lambda = 20))

data_temp
## Export dataset
write_csv(data_temp, file= "data/fitness.csv")
