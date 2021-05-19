#(1)movielens_탐색
#(2)movielens_전처리
#(3)movielens_추천1

library(recommenderlab)
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)
m <- as(m, 'matrix') 
m <- as(m, 'realRatingMatrix')

#User-Based Collaborative Filtering(UBCF)에서 
#조정할 수 있는 파라미터
#recommenderRegistry$get_entry(method = 'UBCF')

#피어슨 상관계수를 이용하여 추천
rec <- Recommender(m, method='UBCF', param=list(method='pearson'))
who <- 1
as(predict(rec, m[who, ], type = 'ratings'), 'list') #평점추출
as(predict(rec, m[who, ], type = 'topNList', n=5), 'list') #영화추출

#코사인 유사도를 이용하여 추천해보기
rec <- Recommender(m, method='UBCF', param=list(method='cosine'))
as(predict(rec, m[who, ], type='topNList', n=5), 'list')

#추천 시 특정 사용자와 인접한 이웃의 수를 50으로 설정하여 추천
rec <- Recommender(m, method='UBCF', param=list(method='cosine', nn=50))
as(predict(rec, m[who, ], type='topNList', n=5), 'list')
