## Framapad: https://mensuel.framapad.org/p/corproject-9jx1?lang=fr

## Add .Git at the root of the project
usethis::use_git()
usethis::use_github()

## Create project on Github and follow the instructions (do not create ReadMe, gitignore, etc.)
## Invite collaborators using the "Settings" directory on Github
## Collaborators can create a project on their computer using the "Version control" option

## Buildignore/Gitignore
usethis::use_build_ignore("_devhistory.R")
usethis::use_build_ignore(".DS_Store")
usethis::use_git_ignore(".DS_Store")
usethis::use_build_ignore("data/.DS_Store")
usethis::use_git_ignore("data/.DS_Store")

## Open the description file to manually edit the metadata
usethis::edit_file("DESCRIPTION")

## Creates a R file to create R documentation (check with Nina)
usethis::use_package_doc()
## Create a man file for the help page and update NAMESPACE (check with Nina)
devtools::document()

## Create README
usethis::use_readme_rmd()

## Add license
usethis::use_mit_license("Nicolas Rode")

## Add a data directory
dir.create("data")
dir.create("text")


## Install dependencies
devtools::install_deps()


## Create file for functions
usethis::use_r("toto.R")

usethis::use_r("createpng.R")

usethis::use_r("analyse_corproject.R")

# Packages
usethis::use_package("plyr")
usethis::use_package("magick")
usethis::use_package("ggplot2")
usethis::use_package("lme4")
usethis::use_package("DHARMa")
usethis::use_package("multcomp")
usethis::use_package("glht")
usethis::use_package("car")
usethis::use_package("janitor")
devtools::install_deps()
devtools::load_all()
