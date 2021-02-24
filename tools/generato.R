library(jsonlite)
library(readr)
library(magick)
library(dplyr)
library(stringr)

data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vSdS2s4DV_wy9zcK5pA8Oz83NzwT5Xdhw_UxceP2quT-tIkXbK5fOn4g030lNNDonjhDW0E3pigElEn/pub?gid=0&single=true&output=csv")

# stáhni fotky

for(i in data$f) {
  obr <- image_read(i)
  filename <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(i))
  image_write(obr, paste0("../foto/orig/", filename, ".jpg"), format = "jpeg")
}
  
# ořízni fotky

for(i in data$f) {
  obr <- image_read(i)
  obr <- image_strip(obr)
  obr <- image_crop(obr, "201x201")
  obr <- image_resize(obr, "120")
  image_write(obr, paste0("../foto/", basename(i)), "jpg")
}

# udělej JSON

Sys.getlocale(category = "LC_ALL")
Sys.setlocale(category = "LC_ALL", locale = "cs_CZ.UTF-8")

data <- data %>% select(1:6)
data$f <- paste0("../foto/orez/", sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(data$f)), ".jpg")
data <- data %>% arrange(p)

write_json(data, path="../data/data.json", na="null")
