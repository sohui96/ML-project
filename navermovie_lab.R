#naver movie
#6417유저*106영화
#기준 2015.5.17
#개인당 영화 평점3개 미만 제거
#아이디가 다르지만 네이버아이디 표기법으로 동일하게 취급됨
#ex) abc0218, abc0411 => abc****

m <- read.csv('./data/MovieNaver.csv', fileEncoding='UTF-8', stringsAsFactors=F)

#데이터 탐색
dim(m)
colnames(m)

nrow(m)*ncol(m)

sum(is.na(m))
sum(!is.na(m))

hist(colMeans(m, na.rm = T), breaks = 50)

hist(apply(m, 1, function(x) sum(!is.na(x))), 
     breaks = 50, main="개인당 작성한 평점 갯수")
min(apply(m, 1, function(x) sum(!is.na(x))))
max(apply(m, 1, function(x) sum(!is.na(x))))

par(mar=c(2,2))
hist(m[,1], main = names(m)[1])
hist(m[,2], main = names(m)[2])
hist(m[,3], main = names(m)[3])
hist(m[,4], main = names(m)[4])
hist(m[,5], main = names(m)[5])

library(recommenderlab)
m <- as(m, 'matrix')
m <- as(m, 'realRatingMatrix')

#평점을 기준으로 여러 모형들의 정확도 평가
scheme <- evaluationScheme(m, method="split",
                           train = .8, k = 1, given = 3) 

algorithms <- list(
  "random" = list(name="RANDOM"),
  "popular" = list(name="POPULAR"),
  "popularZ" = list(name="POPULAR", param=list(normalize = "Z-score")),
  "userZ50C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 50, method = 'cosine')),
  "userZ50P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 50, method = 'pearson')),
  "itemZ100PF" = list(name="IBCF", param=list(normalize = 'Z-score', k = 100, method = 'pearson', normalize_sim_matrix = F)),
  "itemZ100PT" = list(name="IBCF", param=list(normalize = 'Z-score', k = 100, method = 'pearson', normalize_sim_matrix = T)),
  'SVDZ10PT' = list(name="SVD", param=list(normalize = 'Z-score', k = 10)),
  'SVDZ10CF' = list(name="SVD", param=list(normalize = 'Z-score', k = 50)),
  'SVDZ50PT' = list(name="SVD", param=list(normalize = 'Z-score', k = 100))
)

results <- evaluate(scheme, algorithms, type='ratings')

for(i in names(results)){
  
  print(i)
  print(getConfusionMatrix(results[[i]]))
}

plot(results)
#par(mfrow=c(1,1))



#library(irlba)
##추천 TOP LIST를 기준으로 여러 모형들의 정확도 평가
scheme <- evaluationScheme(m, method="split",
                           train=.8, k=1, given=3, goodRating=6)

results <- evaluate(scheme, algorithms, type='topNList', n=c(1, 3, 5, 10, 15, 20))
plot(results, annotate = 1, legend="topleft")
#중간쯤 최종알고리즘 결정

#최종 알고리즘은 UBCF(데이터 사용자별 표준화(Z-score), 
#인접한 이웃 50명, 유사도는 피어슨 상관계수)로 결정
rec <- Recommender(m, method = 'UBCF', param=list(normalize = 'Z-score', nn = 50, method = 'pearson'))
#rec <- Recommender(m, method = 'UBCF', param=list(normalize = 'Z-score', nn = 50, method = 'cosine'))

#5번째 사람에게 추천 영화 5개를 추천해봄
as(predict(rec, m[5,], type = 'topNList', n = 5), 'list')
as(m[5,], 'list')


