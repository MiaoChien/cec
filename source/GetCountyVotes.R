# url = urls[1]

GetCountyVotes = function(url){
  library(XML)
  library(rvest)
  library(httr)
  library(data.table)
  library(magrittr)
  library(stringr)
  
  
  html = GET(url) %>% content(as="text") %>% read_html 
  
  name = 
    html_nodes(html, xpath = "//tr[@class='data'][1]/td[1]/a") %>% 
    html_text %>% str_extract(., "\\S{3}")
  
  b=
    html_nodes(html, xpath = "//tr[@class='data']/td") %>% 
    html_text %>% 
    strsplit(., split="\\s", perl = T) %>% unlist
  
  n = which(grepl(name, b))
  
  a=list()
  for(i in 1:length(n)){
    if(i==length(n)){
      a[[i]] = b[n[i]:length(b)]  
    }else{
      a[[i]]  = b[(n[i]):(n[i+1]-1)]  
    }
    
  }
  
  # a= split(a,as.numeric(gl(length(a),107,length(a))))
  
  
  managelist=function(list){
    FullName=list[1]
    list %<>% .[-which(.=="")] %>% .[-1]
    list %>% str_extract_all(.,"\\S") 
    data = list %>% split(., as.numeric(gl(length(.),4, length(.)))) %>% 
      do.call(rbind,.) %>% data.table %>% set_names(c("Party", "No", "Votes", "VR")) %>% 
      cbind(FullName, .)
    
    return(data)
  }
  
  data = lapply(a, managelist) %>% do.call(rbind,.) %>% data.table(County=name, .)
  
  return(data)  
}