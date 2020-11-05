load.image(file="data/test.png")

eng <- tesseract("eng")
test <- ocr(image="data/test.png", engine = eng)

cat(test)

vec <- unlist(strsplit(test, split="\n", fixed = FALSE, perl = FALSE, useBytes = FALSE))
namecol <- vec[1]

vec <- vec[-1]

vec2 <- strsplit(vec, split=" ", fixed = FALSE, perl = FALSE, useBytes = FALSE)


nbcol <- lapply(vec2, length)

badrows <- which(nbcol>7)

vec[badrows]


