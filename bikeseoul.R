#특정 대여소의 시간대별 예측모델
library(data.table)
library(tidyverse)
library(dplyr)
library(ggplot2)

##날씨
#2017/1/1 - 2021/5/10
humid <- read.csv("./weatherdata/weather_Humidity.csv", stringsAsFactors=F)
precip <- read.csv("./weatherdata/weather_precipitation.csv", stringsAsFactors=F)
temp <- read.csv("./weatherdata/weather_temp.csv", stringsAsFactors=F)
wind <- read.csv("./weatherdata/weather_wind.csv", stringsAsFactors=F)

#필요한 변수만
humid <- humid[,3:4]
names(humid) <- c("date","mean_h")
table(is.na(humid))
sum(!complete.cases(humid))
summary(humid)

precip <- precip[,3:4]
names(precip) <- c("data", "mean_p")
table(is.na(precip))
sum(!complete.cases(precip))
summary(precip)

temp <- temp[,3:4]
names(temp) <- c("data", "mean_t")
table(is.na(temp))
sum(!complete.cases(temp))
summary(temp)

wind <- wind[,3:4]
names(wind) <- c("data", "mean_w")
table(is.na(wind))
sum(!complete.cases(wind))
summary(wind)

##자전거
#2020
bike_info = data.frame()
for(i in 20201:20203) {
  
  path = paste0("./bike_day_info/공공자전거 이용정보(일별)_", i, ".csv")
  data = fread(path, stringsAsFactors=F, header=T)
  bike_info = rbind(bike_info, data)
  
}
names(bike_info) <-  c("date", "num", "place", "code", "sex", "agecode","use","health", "carb", "usedis", "usetime")
#c("대여일자", "대여소번호", "대여소", "대여구분코드", "성별", "연령대코드","이용건수","운동량", "탄소량", "이동거리(m)", "이용시간(m)")
bike_info <- as.data.frame(bike_info)

#save(list=ls(), file="bikeseoul.RData")
###############################################
###############################################
###############################################
###############################################
#######여기서부터 데이터 불러오고 시작#########
###############################################
###############################################
###############################################
load("./bikeseoul.RData")

#결측치 유무 확인
summary(bike_info)
table(is.na(bike_info[,7]))
sum(!complete.cases(bike_info[,8]))
bike_info$sex <- gsub("\\N",NA,bike_info$sex)

#대여소별 데이터셋 나누기
bike1 = bike_info %>% filter(num==101)

#이상치 유무 확인




#전처리 완료된 데이터 csv 파일로 저장하기
write.csv(bike_info, "./bike_info.csv")
write.csv(humid, "./humid.csv")
write.csv(precip, "./precip.csv")
write.csv(temp, "./temp.csv")
write.csv(wind, "./wind.csv")
