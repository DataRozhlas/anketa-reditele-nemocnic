library(jsonlite)
library(readr)
library(magick)
library(dplyr)
library(stringr)
library(RCurl)

data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTbB4taQsHJnOEHGBPmUlumPnVzeHTZ3F6c4mrTyHDN54Uqkvbx-e9EF1t_7Yth39YjxARXaq7fWYw2/pub?gid=0&single=true&output=csv")

# stáhni fotky


for (i in data$f) {
  print(i)
  if (url.exists(i)) {
    obr <- image_read(i)
    filename <-
      sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(i))
    image_write(obr, paste0("../foto/", filename, ".jpg"), format = "jpeg")
  } 
}
  
# autocrop
# autocrop -o orez -r reject -w 150 -H 150

# ořízni fotky

# for(i in data$f) {
#   obr <- image_read(i)
#   obr <- image_strip(obr)
#   obr <- image_crop(obr, "201x201")
#   obr <- image_resize(obr, "120")
#   image_write(obr, paste0("../foto/", basename(i)), "jpg")
# }

# dej správný názvy fotkám, když chybí, face.jpg

data$f[!url.exists(data$f)] <- "face.jpg"

data$f <- str_replace(basename(data$f), "png", "jpg")
data$f <- str_replace(data$f, "JPG", "jpg")
data$f[data$p=="Němeček"] <- "imager.jpg"
data$f[data$p=="Marek"] <- "marek.jpg"

# udělej JSON

Sys.getlocale(category = "LC_ALL")
Sys.setlocale(category = "LC_ALL", locale = "cs_CZ.UTF-8")

data <- data %>% select(1:8)
data <- data %>% arrange(k, p)

write_json(data, path="../data/data.json", na="null")
