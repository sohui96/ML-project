# 사용자 기반 협업필터링
# 상관계수
# 유사도: 상관계수와 코사인
# 아이템 기반 협업필터링
# 데이터 탐색
# 전처리
# 인기있는 영화 추천(popular)
# 나와 유사한 사람들 정보를 이용한 영화 추천(ubcf)
# 내가 본 영화와 유사한 영화들의 정보를 이용한 영화 추천(ibcf)
# 차원 축소를 이용한 영화 추천(svd)
# 추천 시스템에서의 모형선택(평점기준)


#데이터로딩
data <- read.csv("movies.csv", header=T)

#데이터확인
library(dplyr)
library(naniar)
sum(!complete.cases(data))
which(!complete.cases(data))
summary(data)
table(is.na(data$year))

#문자열에 로마문자 -> 해당 행의 열이 밀리는 현상 -> 마지막 column인 year에 NA결측치 생김 -> 수작업으로 결측치 전처리 
trans_data <- function(budget, company, country, director, genre,
                       gross, name, rating, released, runtime,
                       score, star, votes, writer,year){
  
  data.frame(budget=budget, company=company, country=country, director=director,
             genre=genre, gross=gross, name=name, rating=rating,
             released=released, runtime=runtime, score=score, star=star,
             votes=votes, year=year)
}

#데이터 타입 변환
data$gross <- as.numeric(data$gross)
data$rating <- as.factor(data$rating)
data$score <- as.numeric(data$score)
data$votes <- as.numeric(data$votes)
#날짜는 상황에 따라 문자형으로 쓰일수도 as.character()
#data$released <- as.Date(data$released, "%Y-%m-%d")

#추천시스템 패키지
library(recommenderlab)
library(reshape2)
#library(data.table)
library(DT)
library(ggplot2)

#데이터로딩
data <- read.csv("movies.csv", header=T)

str(data) #structure
datatable(data) #tabuler view
summary(data) #summary statistics

#############################################
movie_genre <- as.data.frame(data$genre)
colnames(movie_genre) <- 1
head(movie_genre)

list_genre <- unique(movie_genre)
genre_mat <- matrix(0,6820,50)
genre_mat[1,] <- list_genre[[1]]


for(index in 1:nrow(movie_genre)){
  for(col in 1:ncol(movie_genre)){
    gen_col = which(genre_mat[1,]==movie_genre[index, col])
    genre_mat[index+1,gen_col] <- 1
  }
}

genre_mat2 <- as.data.frame(genre_mat[-1,], stringsAsFactors=F)

for(col in 1: ncol(genre_mat2)){
  genre_mat2[,col] <- as.integer(genre_mat2[,col])
}

str(genre_mat2)

#similarity()
#############################################





















