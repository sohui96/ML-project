#http://statkclee.github.io/parallel-r/recommendation-sparklyr.html
#https://rstatistics.tistory.com/31#- 

library(recommenderlab)
data(Jester5k)
dim(Jester5k) # 5000명의 사용자와 100개의 아이템
# 평가 값 탐색 getRatings()
hist(getRatings(Jester5k), main = "Distribution of ratings")
# 음수값(부정적 평가)를 갖는 것은 균일해보이나
# 양수값(긍정적 평가)를 갖는 부분은 점수가 높아질수록 상대적으로
# 감소하는 추세
# 행렬변환
as(Jester5k, "matrix")[1:10, 1:10]
# train:test 7:3
set.seed(2017)
index <- sample(1:nrow(Jester5k), size = nrow(Jester5k) * 0.7)
train <- Jester5k[index, ]
test <- Jester5k[-index, ]
dim(train) 
dim(test)

##UBCF 사용자 기반 협업필터링
#모델링
recomm_model <- Recommender(data = train, method = "UBCF")
recomm_model
recomm_model@model$data
pred <- predict(recomm_model, newdata = test, n = 10)
pred_list <- sapply(pred@items, function(x) { colnames(Jester5k)[x] })
pred_list[1]
pred_list[1500]
table( unlist( lapply(pred_list, length) ) )
#데이터탐색
table(rowCounts(Jester5k))
mean(rowCounts(Jester5k))
data_modify <- Jester5k[rowCounts(Jester5k) <= 72]
dim(data_modify)
boxplot(Matrix::rowMeans(data_modify))
#모형평가
eval_sets <- evaluationScheme(data = data_modify,
                              method = "cross-validation",
                              train = 0.7,
                              k = 10,
                              goodRating = 3,
                              given = 30)
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
accuracy_eval2 <- evaluate(x = eval_sets, 
                           method = "UBCF")
head( getConfusionMatrix(accuracy_eval2) )


##IBCF 아이템 기반 협업필터링
#모델링링
recomm_model2 <- Recommender(data = train, 
                             method = "IBCF",
                             parameter = list(k = 30))
recomm_model2
str( getModel(recomm_model2) )
pred2 <- predict(recomm_model2, newdata = test, n = 10)
pred_list2 <- sapply(pred2@items, function(x) { colnames(Jester5k)[x] })
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
head( accuracy_eval, 10 )
colMeans(accuracy_eval)  # 혹은 byUser = FALSE 하면 바로 출력
accuracy_eval2 <- evaluate(x = eval_sets2, 
                           method = "IBCF", 
                           n = seq(10, 100, by = 10))
head( getConfusionMatrix(accuracy_eval2) )
plot(accuracy_eval2, annotate = TRUE, main = "ROC Curve")
plot(accuracy_eval2, "prec/rec", annotate = TRUE, main = "Precision-Recall")


## 매개변수 튜닝
vector_k <- c(5, 10, 20, 30, 40)

mod1 <- lapply(vector_k, function(k, l) { list(name = "IBCF", parameter = list(method = "cosine", k = k)) })
names(mod1) <- paste0("IBCF_cos_k_", vector_k)
names(mod1)

mod2 <- lapply(vector_k, function(k, l) { list(name = "IBCF", parameter = list(method = "pearson", k = k)) })
names(mod2) <- paste0("IBCF_pea_k_", vector_k)
names(mod2)
mod <- append(mod1, mod2)   # vector merging
list_results <- evaluate(x = eval_sets2, 
                         method = mod,
                         n = c(1, 5, seq(10, 100, by = 10)))
plot(list_results, annotate = c(1, 2), legend = "topleft")
title("ROC Curve")
plot(list_results, "prec/rec", annotate = 1, legend = "bottomright")
title("Precision-Recall")
