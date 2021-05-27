library(flexclust)
data(nutrient)      # 유사한 식품 그룹 파악
str(nutrient)
head(nutrient)
head(ug)
ug <- as.data.frame(ug)
head(ug)
#유저를 열이름 자체로해보자, 행렬 -> 데이터프레임
#https://data-make.tistory.com/91