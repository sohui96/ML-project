############################################################################
############################################################################
####05월 25일 기준 code file 구조
#(1)movies_확인_0525.R
#(2)movies_탐색_0525.R
#(3)ratings_탐색_0525.R
############################################################################
############################################################################

#영화별 평점
r2 <- r %>% group_by(movieId) %>% summarise(mean_rating = mean(rating), .groups = 'drop') 
barplot(r2$mean_rating~r2$movieId)
ggplot(data=r2,aes(x=r2$movieId,y=r2$mean_rating))+geom_point()
plot(r$movieId, r$mean_rating)
plot(r$movieId, r$mean_rating,type='l')

r2 <- as.data.frame(r2)
head(r2)
plot(r2$movieId, r2$mean_rating) 
hist(r2[,2], main = colnames(r2)[1], breaks = 50, xlab = "평점")

#유저당 평점 갯수
df <- r %>% summarise(count_rating = n(userId))
count(r$userId[1])
barplot(table(r$userId))#다운샘플링 ? 
