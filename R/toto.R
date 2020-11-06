## Function that takes a png and return a vector with the rows found in the png by tesseract
## Inspired from: https://rdrr.io/cran/tesseract/f/vignettes/intro.Rmd
ocrpng <- function(impagepath = "data/test.png"){ ##Path to the png image that will be the argument of the toto function

  ## Test with English training data
  test <- ocr(image = impagepath, engine = tesseract("eng"))
  cat(test)

  ## Test with French training data
  if(is.na(match("fra", tesseract_info()$available))) tesseract_download("fra")
  test <- ocr(image = impagepath, engine = tesseract("fra"))
  cat(test)

  ## Clean image with magick
  library(magick)
  input <- image_read(impagepath)
  image_browse(input)

  input %>%
    image_resize("2000x") %>%     ## Clean the image
    image_convert(type = 'Grayscale') %>%
    image_trim(fuzz = 40) %>%
    image_write(format = 'png', density = '300x300') %>%
    tesseract::ocr(engine = tesseract(language="fra")) %>%
    cat()

  ## Clean image and constrain the type of character that can be present in the document
  text <- input %>%
    image_resize("2000x") %>% ## Clean the image
    image_convert(type = 'Grayscale') %>%
    image_trim(fuzz = 40) %>%
    image_write(format = 'png', density = '300x300') %>%
    tesseract::ocr(
      engine = tesseract(language="fra",
      options = list(tessedit_char_whitelist = paste(c(" .0123456789", letters, toupper(letters)), collapse=""))))## Specify which number and letters are allowed
  cat(text)


  vec <- unlist(strsplit(text, split="\n", fixed = FALSE, perl = FALSE, useBytes = FALSE))
  namecol <- vec[1]

  vec <- vec[-c(1,2)]

  ## Replace double space by a single space
  vec <- gsub(pattern="  ", replacement = " ", vec)

  vec2 <- strsplit(vec, split=" ", fixed = FALSE, perl = FALSE, useBytes = FALSE)

  head(vec2)

  nbcol <- lapply(vec2, length)

  badrows <- which(nbcol>7)

  vec_clean <- vec[!nbcol>7]
  vec_notclean <- vec[nbcol>7]
  return(vec_clean)

}
