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

## Create README
usethis::use_readme_rmd()

usethis::use_mit_license("Nicolas Rode")

## Add a data directory
dir.create("data")



