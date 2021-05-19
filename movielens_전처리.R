#(1)movielens_탐색

library(recommenderlab)
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)

#sparse(NA가 많은)한 데이터를 R에서 잘 다룰 수 있도록 데이터 타입 변경
m <- as(m, 'matrix') #매트릭스로 바꿔주고
m <- as(m, 'realRatingMatrix') #데이터타입변경
colMeans(m)
m

#평점 추출하기(na는 사라진다) - 모든 사용자의 평점
hist(getRatings(m), main="모든 사용자의 평점 빈도")
#3,4,5점에 편중되어 있는 것 같다.
#오른쪽으로 치우쳐진
summary(getRatings(m))

#표준화, 평균빼기를 통해 상관계수, 코사인 유사도 정확도 업
normalize(m, method="center") #평균값을 빼줌

#각 사용자의 평점을 각 사용자별로 평균을 빼준 뒤 (mean centering) 평점 알아보기
hist(getRatings(normalize(m, method='center')), main="평점-평균")
summary(getRatings(normalize(m, method='center')))
#각 사용자의 평점을 각 사용자별로 표준화 한 뒤 평점 알아보기
hist(getRatings(normalize(m, method = 'Z-score')), main="표준화")
summary(getRatings(normalize(m, method = 'Z-score')))
