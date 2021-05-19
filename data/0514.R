metadata <- read.csv("movies.csv", header=T)
head(metadata)
str(metadata)

library(dplyr)
library(ggplot2)
library(naniar)
sum(!complete.cases(metadata))
which(!complete.cases(metadata))

#NA
summary(metadata)
naniar::vis_miss(metadata)
naniar::gg_miss_var(metadata)
table(is.na(metadata$year))

#결측치 처리
metadata$budget[34] <- c(24500000)
metadata$company[34] <- c("Warner Bros.")
metadata$country[34] <- c("UK")
metadata$director[34] <- c("Roland Joff")
metadata$genre[34] <- c("Adventure")
metadata$gross[34] <- c(17218023)
metadata$name[34] <- c("The Mission")
metadata$rating[34] <- c("PG")
metadata$released[34] <- c("1986-10-31")
metadata$runtime[34] <- c(125)
metadata$score[34] <- c(7.5)
metadata$star[34] <- c("Robert De Niro")
metadata$votes[34] <- c(47497)
metadata$writer[34] <- c("Robert Bolt")
metadata$year[34] <- c(1986)

#이상치
dim(metadata)
country <- metadata$country
country

# 이상치 발견 
table(country)
pie(table(country))






#전처리 완료된 데이터 csv 파일로 저장하기
write.csv(bike_info, "./bike_info.csv")