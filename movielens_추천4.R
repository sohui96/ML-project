#(1)movielens_탐색
#(2)movielens_전처리
#(3)movielens_추천1
#(4)movielens_추천2
#(5)movielens_추천3

library(recommenderlab)
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)
m <- as(m, 'matrix') 
m <- as(m, 'realRatingMatrix')

#차원 축소를 이용한 영화 추천
#SVD 에서 조정할 수 있는 파라미터
recommenderRegistry$get_entry(method = 'SVD')

#10개의 차원으로 축소한 뒤 추천해보기
rec <- Recommender(m, method = "SVD", param=list(k = 30))
who <- 1
as(predict(rec, m[who,], type='topNList', n=5), 'list')

rec <- Recommender(m, method = "SVD", param=list(k = 20, normalize='Z-score'))
as(predict(rec, m[c(1,3),], type = 'topNList', n = 5), 'list')

#20개의 차원으로 축소한 뒤 추천해보기
rec <- Recommender(m, method = "SVD", param=list(k = 20))
as(predict(rec, m[c(1,3),], type = 'topNList', n = 5), 'list')