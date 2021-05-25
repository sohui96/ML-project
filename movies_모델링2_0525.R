#https://rstatistics.tistory.com/31#----ibcf
############################################################################
############################################################################
####05월 25일 기준 code file 구조
#(1)movies_확인_0525.R
#(2)movies_탐색_0525.R
#(3)ratings_탐색_0525.R
#(4)tags_탐색_0525.R
#(5)movies_최종데이터구축_0525.R
#(6)movies_모델링_0525.R - 평점기반
#(7)movies_모델링2_0525.R - 장르 기반
############################################################################
############################################################################

# 장르 기반 - mr 데이터셋
final_mg <- read.csv('./data/final_mg.csv', header=T) 
final_mg <- final_mg[,-1]

df <- final_mg
glimpse(df)
str(df)

df <- as(df, 'matrix') 
df <- as(df, 'realRatingMatrix')
hist(getRatings(df), main = "Distribution of ratings")
as(df, "matrix")[1:10, 1:10]

set.seed(2021)
index <- sample(1:nrow(df), size = nrow(df) * 0.7)

train <- df[index, ]
test <- df[-index, ]
dim(train) 
dim(test)


recomm_model2 <- Recommender(data = train, 
                             method = "IBCF",
                             parameter = list(k = 30))
recomm_model2
str( getModel(recomm_model2) )

pred2 <- predict(recomm_model2, newdata = test, n = 10)
pred_list2 <- sapply(pred2@items, function(x) { colnames(df)[x] })
pred_list2[1]
pred_list2[1500]

eval_sets2 <- evaluationScheme(data = data_modify,
                               method = "cross-validation",
                               train = 0.7,
                               k = 5,
                               goodRating = 3,
                               given = 15)
getData(eval_sets2, "train")
# Training dataset modeling
recomm_eval2 <- Recommender(data = getData(eval_sets2, "train"),
                            method = "IBCF", 
                            parameter = NULL)
recomm_eval2

# Prediction
pred_eval2 <- predict(recomm_eval2, 
                      newdata = getData(eval_sets2, "known"),
                      n = 10, type = "ratings")
pred_eval2

# Calculate accuracy
accuracy_eval2 <- calcPredictionAccuracy(x = pred_eval2,
                                         data = getData(eval_sets2, "unknown"),
                                         byUser = TRUE) # byUser = TRUE : 각 사용자들에 대한 모델의 정확도가 계산
head(accuracy_eval, 10 )

colMeans(accuracy_eval)  # 혹은 byUser = FALSE 하면 바로 출력

############################################################################
############################################################################

##시각화
plot(accuracy_eval2, annotate = TRUE, main = "ROC Curve") # ? 왜 알오시?

##파라미터 튜닝