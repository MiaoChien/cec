setwd("~/Dropbox/practice/crawler/cec")

library(XML)
library(rvest)
library(httr)
library(data.table)
library(magrittr)
library(stringr)

url = "http://db.cec.gov.tw/histQuery.jsp?voteCode=20160101T4A2&qryType=ctks&prvCode=00&candNo=11"
html = GET(url) %>% content(as="text") %>% read_html 
link=html_nodes(html, xpath = "//tr[@class='data']/td[1]/a") %>% html_attr("href") 


urls = paste0("http://db.cec.gov.tw/", link)


source("source/GetCountyVotes.R")

data = lapply(urls, GetCountyVotes) %>% do.call(rbind,.)

data$VR %<>% str_replace_all(.,"%","") %>% as.numeric() 
data$VR = data$VR/100 

write.csv(data, "各鄉鎮政黨票得票.csv", col.names = T, row.names = F)
