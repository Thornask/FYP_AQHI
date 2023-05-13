

### requiring

require("tidyverse")
require("readr")
require(zoo)
require(rvest)
require(mongolite)


## Scraping

doc2 <- read_html("https://www.aqhi.gov.hk/en.html")


### Time scraping

# dateTime of current version: table_time
text_time <- html_elements(doc2, xpath="//*[@id='tblCurrAQHI']/tbody/tr[2]/td[1]") %>% html_text() %>% strsplit(" ")
temp_date <- strsplit(text_time[[1]][2], "-")
temp_time <- strsplit(text_time[[1]][1], ":")

table_time <- ISOdate(as.numeric(temp_date[[1]][3]), as.numeric(temp_date[[1]][2]), as.numeric(temp_date[[1]][1]), as.numeric(temp_time[[1]][1]), as.numeric(temp_time[[1]][2]), 0)

# (make the current time format match for using in mongolite, timestamp) 
temp_timestamp <- strsplit(as.character(table_time), " ")
if(is.na(temp_timestamp[[1]][2])){
  timestamp <- paste0(temp_timestamp[[1]][1], "T00:00:00Z")
} else{
  timestamp <- paste0(temp_timestamp[[1]][1], "T", temp_timestamp[[1]][2], "Z")
}


### pollutant concentration scraping

table_test <- html_elements(doc2, xpath = "//*[contains(@class, 'cMapPopup ui-corner-all')]/table") %>% html_table()


## Mongodb accessing

# link for accessing mongodb 
connection_string <- 'mongodb+srv://admin:fypadmin@cluster0.neeez8b.mongodb.net/test'

## Access and insert data to each collections:


### 1: CentralWestern (cwest)

centralwest_collection <- mongo(collection="CentralWest", db="dbTseries", url=connection_string)
if(
  nrow( centralwest_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 1
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cw_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "CentralWest"}' )
  
  centralwest_collection$insert(str)
}


### 2: Kwai Chung (kc)

kwaichung_collection <- mongo(collection="KwaiChung", db="dbTseries", url=connection_string)
if(
  nrow( kwaichung_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 2
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "KwaiChung"}' )
  
  kwaichung_collection$insert(str)
} 


### 3: Sham Shui Po (ssp)

shamshuipo_collection <- mongo(collection="ShamShuiPo", db="dbTseries", url=connection_string)
if(
  nrow( shamshuipo_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 3
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\ssp_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "ShamShuiPo"}' )
  
  shamshuipo_collection$insert(str)
}


### 4: Tai Po 

taipo_collection <- mongo(collection="TaiPo", db="dbTseries", url=connection_string)
if(
  nrow( taipo_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 4
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kc_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\taipo_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "TaiPo"}' )
  taipo_collection$insert(str)
}


### 5: Tap Mun 

tapmun_collection <- mongo(collection="TapMun", db="dbTseries", url=connection_string)
if(
  nrow( tapmun_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 5
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "TapMun"}' )
  tapmun_collection$insert(str)
}


### 6: Tsuen Wan (tw)

tsuenwan_collection <- mongo(collection="TsuenWan", db="dbTseries", url=connection_string)
if(
  nrow( tsuenwan_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 6
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tw_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "TsuenWan"}' )
  tsuenwan_collection$insert(str)
}


### 7: Tung Chung (tc)

tungchung_collection <- mongo(collection="TungChung", db="dbTseries", url=connection_string)
if(
  nrow( tungchung_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 7
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tc_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "TungChung"}' )
  tungchung_collection$insert(str)
}


### 8: Yuen Long (yl)

yuenlong_collection <- mongo(collection="YuenLong", db="dbTseries", url=connection_string)
if(
  nrow( yuenlong_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 8
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\yl_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "YuenLong"}' )
  yuenlong_collection$insert(str)
}


### 9: roadside_CausewayBay (cwb)

causewaybay_collection <- mongo(collection="roadside_CausewayBay", db="dbTseries", url=connection_string)
if(
  nrow( causewaybay_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 9
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cwb_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "roadside_CausewayBay"}' )
  causewaybay_collection$insert(str)
}


### 10: roadside_Central (cent)

central_collection <- mongo(collection="roadside_Central", db="dbTseries", url=connection_string)
if(
  nrow( central_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 10
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tapmun_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\cent_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "roadside_Central"}' )
  central_collection$insert(str)
}


### 11: Sha Tin 

shatin_collection <- mongo(collection="ShaTin", db="dbTseries", url=connection_string)
if(
  nrow( shatin_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 11
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\shatin_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "ShaTin"}' )
  shatin_collection$insert(str)
}


### 12: Kwun Tong (kt)

kwuntong_collection <- mongo(collection="KwunTong", db="dbTseries", url=connection_string)
if(
  nrow( kwuntong_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 12
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\kt_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "KwunTong"}' )
  kwuntong_collection$insert(str)
}


### 13: Tseung Kwan O (tko)

tseungkwano_collection <- mongo(collection="TseungKwanO", db="dbTseries", url=connection_string)
if(
  nrow( tseungkwano_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 13
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tko_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "TseungKwanO"}' )
  tseungkwano_collection$insert(str)
}


### 14: Easrtern (east)

eastern_collection <- mongo(collection="Eastern", db="dbTseries", url=connection_string)
if(
  nrow( eastern_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 14
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\east_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "Eastern"}' )
  eastern_collection$insert(str)
}


### 15: roadside_MongKok (mk)

mongkok_collection <- mongo(collection="roadside_MongKok", db="dbTseries", url=connection_string)
if(
  nrow( mongkok_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 15
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\mk_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "roadside_MongKok"}' )
  mongkok_collection$insert(str)
}


### 16: Tuen Mun 

tuenmun_collection <- mongo(collection="TuenMun", db="dbTseries", url=connection_string)
if(
  nrow( tuenmun_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 16
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\tuenmun_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "TuenMun"}' )
  tuenmun_collection$insert(str)
}


### 17: Southern (south)

southern_collection <- mongo(collection="Southern", db="dbTseries", url=connection_string)
if(
  nrow( southern_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 17
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\south_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "Southern"}' )
  southern_collection$insert(str)
}


### 18: North

north_collection <- mongo(collection="North", db="dbTseries", url=connection_string)
if(
  nrow( north_collection$find( paste0('{"date": {"$date": "', timestamp, '"}}') )
  ) == 0){
  p <- 18
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_no2.txt"))
  p_NO2 <- if(!is.na(as.numeric(table_test[[p]][4,2]))){as.numeric(table_test[[p]][4,2])} else {last}
  write(p_NO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_no2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_fsp.txt"))
  p_FSP <- if(!is.na(as.numeric(table_test[[p]][4,4]))){as.numeric(table_test[[p]][4,4])} else {last}
  write(p_FSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_fsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_so2.txt"))
  p_SO2 <- if(!is.na(as.numeric(table_test[[p]][5,2]))){as.numeric(table_test[[p]][5,2])} else {last}
  write(p_SO2, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_so2.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_rsp.txt"))
  p_RSP <- if(!is.na(as.numeric(table_test[[p]][5,4]))){as.numeric(table_test[[p]][5,4])} else {last}
  write(p_RSP, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_rsp.txt")
  
  last <- as.numeric(read_file("C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_o3.txt"))
  p_O3  <- if(!is.na(as.numeric(table_test[[p]][6,2]))){as.numeric(table_test[[p]][6,2])} else {last}
  write(p_O3, "C:\\Users\\user\\OneDrive\\Documents\\GitHub\\FYP_AQHI\\north_o3.txt")
  
  str <- paste0('{"date": {"$date": "', timestamp, '"}, "NO2": ', p_NO2, ', "FSP": ', p_FSP, ', "SO2": ', 
                p_SO2, ', "RSP": ', p_RSP, ', "O3": ', p_O3, ', "station": "North"}' )
  north_collection$insert(str)
}


## Log

# Check if log.rds exists

if(file.exists("log.rds")) {
  
  # Read in current log and assign to 'log'
  
  log <- readRDS("log.rds")
  
  # Capture the time
  
  last_run <- Sys.time()
  
  # Add a row to our one-column dataframe
  # Assign it the value held in 'last_run'
  
  log[nrow(log) + 1, 1] <- last_run
  
  saveRDS(log, file = "log.rds")
  
  
} else {
  
  # This is case where "log.rds" doesn't exist
  # So, we're starting a new log
  
  # Capture the time the script runs
  
  last_run <- Sys.time()
  
  # Create a dataframe that will be our log
  
  log <- data.frame(last_run)
  
  # Write to RDS file "log.rds"
  
  saveRDS(log, file =  "log.rds")
  
}