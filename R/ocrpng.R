## Function that takes a png and return a vector with the rows found in the png by tesseract
## Inspired from: https://rdrr.io/cran/tesseract/f/vignettes/intro.Rmd
ocrpng <- function(impagepath = "data/test.png", n.col=NULL, lang="eng",  header=TRUE){ ##Path to the png image that will be the argument of the toto function

  ## Test with language training data
  if(is.na(match(lang, tesseract_info()$available))) tesseract_download(lang)
  test <- ocr(image = impagepath, engine = tesseract(lang))
  cat(test)

  ## Clean image with magick
  input <- image_read(impagepath)
  image_browse(input)

  input %>%
    image_resize("2000x") %>%     ## Clean the image
    image_convert(type = 'Grayscale') %>%
    image_trim(fuzz = 40) %>%
    image_write(format = 'png', density = '300x300') %>%
    tesseract::ocr(engine = tesseract(language=lang)) %>%
    cat()

  ## Clean image and constrain the type of character that can be present in the document
  text <- input %>%
    image_resize("2000x") %>% ## Clean the image
    image_convert(type = 'Grayscale') %>%
    image_trim(fuzz = 40) %>%
    image_write(format = 'png', density = '300x300') %>%
    tesseract::ocr(
      engine = tesseract(language=lang,
      options = list(tessedit_char_whitelist = paste(c(" .0123456789", letters, toupper(letters)), collapse=""))))## Specify which number and letters are allowed
  cat(text)

  vec <- unlist(strsplit(text, split="\n"))

  ## Replace double space by a single space
  vec <- gsub(pattern="  ", replacement = " ", vec)

  vec2 <- strsplit(vec, split=" ")

  n.col.est <- unlist(unlist(lapply(vec2, length)))
  if(is.null(n.col)) {
    n.col <- median(n.col.est)
  }

  if(header) {
    name.col <- unlist(vec2[[1]])
    if(length(name.col)!=n.col){
        name.col <- c("row_number", name.col)
    }
    vec2[1] <- NULL
    n.col.est <- n.col.est[-1]
  }

  vec2 <- vec2[-which(n.col.est==0)]
  num.error <- sum(unlist(lapply(vec2, length))!=n.col)

  if(num.error>0){
    warning(paste("wrong number of columns for rows", paste(which(unlist(lapply(vec2, length))!=n.col), collapse = " ")))
    print(paste(" % of rows with wrong numbers of columns", round(num.error/length(vec)*100,2), "%"))
    }
  vec3 <- lapply(vec2, `length<-`, max(lengths(vec2)))



  df.raw <- as.data.frame(t(as.data.frame(vec3)))

  df.clean <- na.omit(df.raw)

 rownames(df) <- 1:nrow(df)
 colnames(df) <- name.col

  return(df.clean)
}

