setwd("~/Dropbox/practice/crawler/cec")

library(XML)
library(rvest)
library(httr)
library(data.table)
library(magrittr)


url = "http://db.cec.gov.tw/histQuery.jsp?voteCode=20160101T4A2&qryType=ctks&prvCode=00&candNo="
URL = paste0(url,1:18)

GetVote = function(url){
  html = GET(url) %>% content(as="text") %>% read_html 
  data = html_table(html,header=TRUE ,fill=T)[[1]] %>% data.table
  return(data)  
}

data = lapply(URL, GetVote) %>% do.call(rbind,.)
data %<>% .[order(地區)]

write.csv(data,"各縣市政黨票得票.csv", row.names = F, col.names = T)
