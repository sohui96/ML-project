#(1)movielens_탐색
#(2)movielens_전처리
#(3)movielens_추천1
#(4)movielens_추천2

library(recommenderlab)
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)
m <- as(m, 'matrix') 
m <- as(m, 'realRatingMatrix')

#Item Based Collaborative Filtering(IBCF)에서 
#조정할 수 있는 파라미터 알아보기
recommenderRegistry$get_entry(method = 'IBCF')

#피어슨 상관계수를 이용하여 추천
rec <- Recommender(m, method = "IBCF", param=list(method = 'pearson'))
who <- 1
as(predict(rec, m[who,], type = 'ratings', n=5), 'list')
as(predict(rec, m[who,], type = 'topNList', n=5), 'list')

#유사도를 행별로 normalize(행별로 유사도 합이 1이 되도록 재조정)
#한 후 피어슨 상관계수를 이용하여 추천
rec <- Recommender(m, method = "IBCF", param=list(method = 'pearson', normalize_sim_matrix = T))
as(predict(rec, m[who,], type = 'ratings', n=5), 'list')
as(predict(rec, m[who,], type = 'topNList', n=5), 'list')

#파라미터 조정 method='cosine', k=5
rec <- Recommender(m, method = "IBCF", param=list(method = 'cosine', normalize_sim_matrix = T, k=5))
as(predict(rec, m[who,], type = 'topNList', n=5), 'list')
