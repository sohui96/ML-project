#(1)movielens_탐색
#(2)movielens_전처리

library(recommenderlab)
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)
m <- as(m, 'matrix') 
m <- as(m, 'realRatingMatrix')

#recommenderlab에서 기본적으로 사용가능한 추천 알고리즘 확인
#recommenderRegistry$get_entries()

#데이터가 평점 등 실수(real) 데이터 일 경우 
#recommenderlab에서 기본적으로 사용가능한 추천 알고리즘 확인
#recommenderRegistry$get_entry(dataType = 'realRatingMatrix')


##1
#평균 평점이 높은 영화 순(인기순)으로 추천(학습 단계)
rec <- Recommender(m, method = 'POPULAR')
rec

#1번(첫번째) 사람에 대해 평점 예측(predict)(추천 단계)
who <- 1
predict(rec, m[who, ], type = 'ratings')
as(predict(rec, m[who, ], type = 'ratings'), 'list')

#1번(첫번째) 사람에 대해 평점을 예측(predict)하되, 
#평점이 높은 영화 5개만 추천(추천 단계)
as(predict(rec, m[who, ], type = 'topNList', n=5), 'list')

as(predict(rec, m[2, ], type = 'topNList', n=5), 'list')
as(predict(rec, m[943, ], type = 'topNList', n=5), 'list')



##2
#평점 데이터를 사용자별로 표준화 한 뒤, 
#평균 평점이 높은 영화 순(인기순)으로 추천(학습 단계)
rec <- Recommender(m, method = 'POPULAR', param = list(normalize = 'Z-score'))
rec

#1번(첫번째) 사람에 대해 평점을 예측(predict)하되, 
#평점이 높은 영화 5개만 추천(추천 단계)
as(predict(rec, m[who, ], type = 'topNList', n=5), 'list')

as(predict(rec, m[2, ], type = 'topNList', n=5), 'list')
as(predict(rec, m[943, ], type = 'topNList', n=5), 'list')
