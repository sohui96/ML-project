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
############################################################################
############################################################################

# 평점 기반 - mr 데이터셋
final_mr <- read.csv('./data/final_mr.csv', header=T) 

df <- final_mr
glimpse(df)
str(df)

df <- as(df, 'matrix') 
df <- as(df, 'realRatingMatrix')
hist(getRatings(df), main = "Distribution of ratings")
as(df, "matrix")[1:100, 1:100]

set.seed(2021)
index <- sample(1:nrow(df), size = nrow(df) * 0.7)

train <- df[index, ]
test <- df[-index, ]
dim(train) 
dim(test)

# recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
# recommender_models

recomm_model <- Recommender(data = train, method = "UBCF")
recomm_model

pred <- predict(recomm_model, newdata = test, n = 10)
pred_list <- sapply(pred@items, function(x) { colnames(df)[x] })
#????????
pred_list[1]
pred_list[615]
table(unlist(lapply(pred_list, length)))

table(rowCounts(df))
mean(rowCounts(df))
data_modify <- df[rowCounts(df) <= 165.2918]
dim(data_modify)
boxplot(Matrix::rowMeans(data_modify))

eval_sets <- evaluationScheme(data = data_modify,
                              method = "cross-validation",
                              train = 0.7,
                              k = 10,
                              goodRating = 3,
                              given = 10)
sapply(eval_sets@runsTrain, length)
getData(eval_sets, "train")

# Training dataset modeling
recomm_eval <- Recommender(data = getData(eval_sets, "train"),
                           method = "UBCF", 
                           parameter = NULL)
recomm_eval

# Prediction
pred_eval <- predict(recomm_eval, 
                     newdata = getData(eval_sets, "known"),
                     n = 10, type = "ratings")
pred_eval

# Calculate accuracy
accuracy_eval <- calcPredictionAccuracy(x = pred_eval,
                                        data = getData(eval_sets, "unknown"),
                                        byUser = TRUE) # byUser = TRUE : 각 사용자들에 대한 모델의 정확도가 계산
head( accuracy_eval, 10 )
colMeans(accuracy_eval)  # 혹은 byUser = FALSE 하면 바로 출력

