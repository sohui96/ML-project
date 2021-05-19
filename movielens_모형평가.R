#(1)movielens_탐색
#(2)movielens_전처리
#(3)movielens_추천1
#(4)movielens_추천2
#(5)movielens_추천3
#(6)movielens_모형평가

library(recommenderlab)
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)
m <- as(m, 'matrix') 
m <- as(m, 'realRatingMatrix')

##추천 시스템에서의 모형 선택 (평점기준)
#모형 평가를 위해서 Traing Set과 Test Set 분할하기
scheme <- evaluationScheme(m, method="split",
                           train = .8, k = 1, given = 15) 
#k: 심플하게 k를 여러번 할수록 잘 섞인다.
#given: 특정 정보에 편향되지 않게, 최소한 영화를 15개 본 유저정보를 활용하겠다.

scheme@runsTrain
set.seed(12345)
scheme <- evaluationScheme(m, method="split",
                           train = .8, k = 1, given = 15) 
scheme@runsTrain

#평가할 알고리즘 설정하기

algorithms <- list(
  "random" = list(name="RANDOM"),
  "popular" = list(name="POPULAR"), 
  "popularZ" = list(name="POPULAR", param=list(normalize = "Z-score")),
  "userN10C" = list(name="UBCF", param=list(normalize = NULL, nn = 10, method = 'cosine')),
  "userN10P" = list(name="UBCF", param=list(normalize = NULL, nn = 10, method = 'pearson')),
  "userN50C" = list(name="UBCF", param=list(normalize = NULL, nn = 50, method = 'cosine')),
  "userN50P" = list(name="UBCF", param=list(normalize = NULL, nn = 50, method = 'pearson')),
  "userC50C" = list(name="UBCF", param=list(normalize = 'center', nn = 50, method = 'cosine')),
  "userC50P" = list(name="UBCF", param=list(normalize = 'center', nn = 50, method = 'pearson')),
  "userZ50C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 50, method = 'cosine')),
  "userZ50P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 50, method = 'pearson')),
  "userZ100C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 100, method = 'cosine')),
  "userZ100P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 100, method = 'pearson')),
  "userZ500C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 500, method = 'cosine')),
  "userZ500P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 500, method = 'pearson'))
)

#Training Set으로 각 알고리즘에 대해서 학습 후 
#Test Set을 이용하여 정확도 평가하기
results <- evaluate(scheme, algorithms, type='ratings')

#각 모형에 대한 정확도 확인하기
names(results)
getConfusionMatrix(results[['random']])
getConfusionMatrix(results[['popular']])

for (i in names(results)){
  
  print(i)
  print(getConfusionMatrix(results[[i]]))
}

#각 모형에 대한 정확도를 그림으로 나타내기
plot(results)

#User Based CF외에 Item Based CF와 SVD를 추가하여 모형 평가하기
algorithms <- list(
  "random" = list(name="RANDOM"),
  "popular" = list(name="POPULAR"),
  "popularZ" = list(name="POPULAR", param=list(normalize = "Z-score")),
  "userN10C" = list(name="UBCF", param=list(normalize = NULL, nn = 10, method = 'cosine')),
  "userZ500C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 500, method = 'cosine')),
  "itemZ100PF" = list(name="IBCF", param=list(normalize = 'Z-score', k = 100, method = 'pearson', normalize_sim_matrix = F)),
  "itemZ100PT" = list(name="IBCF", param=list(normalize = 'Z-score', k = 100, method = 'pearson', normalize_sim_matrix = T)),
  "itemZ100CF" = list(name="IBCF", param=list(normalize = 'Z-score', k = 100, method = 'cosine', normalize_sim_matrix = F)),
  "itemZ100CT" = list(name="IBCF", param=list(normalize = 'Z-score', k = 100, method = 'cosine', normalize_sim_matrix = T)),
  "itemZ500PT" = list(name="IBCF", param=list(normalize = 'Z-score', k = 500, method = 'pearson', normalize_sim_matrix = T)),
  "itemZ500CT" = list(name="IBCF", param=list(normalize = 'Z-score', k = 500, method = 'cosine', normalize_sim_matrix = T)),
  'SVDZ10PT' = list(name="SVD", param=list(normalize = 'Z-score', k = 10)),
  'SVDZ50PT' = list(name="SVD", param=list(normalize = 'Z-score', k = 50)),
  'SVDZ100PT' = list(name="SVD", param=list(normalize = 'Z-score', k = 100)),
)

results <- evaluate(scheme, algorithms, type='ratings')

for (i in names(results)){
  
  print(i)
  print(getConfusionMatrix(results[[i]]))
}

plot(results)



##추천 시스템에서의 모형 선택 (추천목록기준)
#모형 평가를 위해서 Traing Set과 Test Set 분할하기: 
#단, 3점 이상일 경우 재미있게 봤다고 가정
set.seed(12345)
scheme <- evaluationScheme(m, method="split",
                           train = .8, k = 1, given = 15, goodRating = 3)

#평가할 알고리즘 설정하기
algorithms <- list(
  "random" = list(name="RANDOM"),
  "popular" = list(name="POPULAR"),
  "popularZ" = list(name="POPULAR", param=list(normalize = "Z-score")),
  "userN10C" = list(name="UBCF", param=list(normalize = NULL, nn = 10, method = 'cosine')),
  "userN10P" = list(name="UBCF", param=list(normalize = NULL, nn = 10, method = 'pearson')),
  "userN50C" = list(name="UBCF", param=list(normalize = NULL, nn = 50, method = 'cosine')),
  "userN50P" = list(name="UBCF", param=list(normalize = NULL, nn = 50, method = 'pearson')),
  "userC50C" = list(name="UBCF", param=list(normalize = 'center', nn = 50, method = 'cosine')),
  "userC50P" = list(name="UBCF", param=list(normalize = 'center', nn = 50, method = 'pearson')),
  "userZ50C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 50, method = 'cosine')),
  "userZ50P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 50, method = 'pearson')),
  "userZ100C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 100, method = 'cosine')),
  "userZ100P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 100, method = 'pearson')),
  "userZ500C" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 500, method = 'cosine')),
  "userZ500P" = list(name="UBCF", param=list(normalize = 'Z-score', nn = 500, method = 'pearson'))
)

#Training Set으로 각 알고리즘에 대해서 학습 후 Test Set을 이용하여 정확도 평가
results <- evaluate(scheme, algorithms, type='topNList', n=c(1, 3, 5, 10, 15, 20))

#정확도 결과 그래프로 나타내기
plot(results, annotate=1, legend="topleft")


?evaluate











