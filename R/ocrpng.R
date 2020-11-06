## Function that takes a png and return a vector with the rows found in the png by tesseract
## Inspired from: https://rdrr.io/cran/tesseract/f/vignettes/intro.Rmd
#' Title
#'
#' @param impagepath
#' @param n.col
#' @param lang
#' @param header
#' @param outcsv
#' @param cleaning
#'
#' @return
#' @export
#' @import magick
#' @import tesseract
#' @importFROM data.table na.omit
#' @examples
#'

ocrpng <- function(impagepath = "data/test.png", n.col=NULL, lang="eng",  header=TRUE, cleaning=FALSE, outcsv="data/fitnessOCR.csv"){ ##Path to the png image that will be the argument of the toto function

  ## Test with language training data
  if(is.na(match(lang, tesseract_info()$available))) tesseract_download(lang)
  if(!cleaning){
    print(paste("OCR in", lang, "without cleaning", sep=" "))
    test <- ocr(image = impagepath, engine = tesseract(lang))
    cat(test)
  }else{




    ## Clean image with magick
    input <- image_read(impagepath)
    #image_display(input)

    #  input %>%
    #    image_resize("2000x") %>%     ## Clean the image
    #    image_convert(type = 'Grayscale') %>%
    #    image_trim(fuzz = 40) %>%
    #    image_write(format = 'png', density = '300x300') %>%
    #    tesseract::ocr(engine = tesseract(language=lang)) %>%
    #    head() %>%
    #    cat()


    ## Clean image and constrain the type of character that can be present in the document
    print(paste("OCR in", lang, "with cleaning", sep=" "))
    text <- input %>%
      image_resize("2000x") %>% ## Clean the image
      image_convert(type = 'Grayscale') %>%
      image_trim(fuzz = 40) %>%
      image_write(format = 'png', density = '300x300') %>%
      tesseract::ocr(
        engine = tesseract(language=lang,
                           options = list(tessedit_char_whitelist = paste(c(" .0123456789", letters, toupper(letters)), collapse=""))))## Specify which number and letters are allowed
    cat(text)
  }

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

 rownames(df.clean) <- 1:nrow(df.clean)
 colnames(df.clean) <- name.col
 ## Export dataset
 write_csv(df.clean, file= outcsv)
 print("")
 print("")
 print("Here is a clean dataframe")
 print(df.clean)
  return(df.clean)
}

