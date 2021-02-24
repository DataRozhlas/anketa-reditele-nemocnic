library(jsonlite)
library(readr)
library(magick)
library(dplyr)
library(stringr)

data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTbB4taQsHJnOEHGBPmUlumPnVzeHTZ3F6c4mrTyHDN54Uqkvbx-e9EF1t_7Yth39YjxARXaq7fWYw2/pub?gid=0&single=true&output=csv")

# stáhni fotky

for(i in data$Foto) {
  if(is.na(i)) {return()}
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
