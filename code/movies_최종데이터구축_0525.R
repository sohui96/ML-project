############################################################################
############################################################################
####05월 25일 기준 code file 구조
#(1)movies_확인_0525.R
#(2)movies_탐색_0525.R
#(3)ratings_탐색_0525.R
#(4)tags_탐색_0525.R
#(5)movies_최종데이터구축_0525.R
############################################################################
############################################################################

#무비id 오름차순 정렬 후 새 인덱스 부여
m <- m[order(m$movieId),]
m$idx <- 1:nrow(m)

#movies - rating 병합
mr <- merge(m, r, key='movieId', all.y=T)
mr <- mr[,-c(1,7)]
mr <- mr[,-c(2,3)]

sum(duplicated(mr)) #[1] 3
which(duplicated(mr)|duplicated(mr,fromLast=T))
mr[which(duplicated(mr)|duplicated(mr,fromLast=T)),]
mr <- mr[-which(duplicated(mr)|duplicated(mr,fromLast=T)),]
mr <- mr[-c(80209,88669),]
write.csv(mr, "./data/mr.csv",row.names = F)
##
final_mr <- spread(mr, key = "title", value = "rating", fill = NA)
final_mr <- final_mr[,-1]
write.csv(m, "./data/final_mr.csv",row.names = F)
#hist(colMeans(final_mr, na.rm = T), breaks = 50)

#mr, final_mr 생성완료
############################################################################
############################################################################

#movies에 있는 장르분리 및 장르df생성
g <- data.table()
n <- nrow(m)
for (i in 1:n){
  
  #print(i)
  
  name_index <- as.character(m[i, 4])
  item_index <- as.character(m[i, 3])
  
  item_index_split_temp <- data.frame(strsplit(item_index, split = '\\|'))
  m_temp <- data.frame(cbind(name_index, item_index_split_temp))
  
  names(m_temp) <- c("movieId", "genres")
  
  g <- rbind(g, m_temp)
}
rm(name_index, item_index, item_index_split_temp, m_temp) # delete temp dataset
g$movieId <- as.integer(g$movieId)
names(g)<-c("idx", "genres")
glimpse(g)
summary(g)

#장르확인
unique(g$genres)
#(no genres listed) -> NA 결측치 처리
g$genres<- gsub("\\(no genres listed\\)", NA, g$genres)
g <- as.data.frame(g)

write.csv(g, "./data/genres.csv",row.names = F)
#genres 생성완료
############################################################################
############################################################################

#장르 기반 - mg 데이터셋 구축
m$value = 1
m = m[,-c(1,3)]
mg <- merge(m, g, key='idx', all.y=T)
head(mg)
write.csv(mg, "./data/mg.csv",row.names = F)

final_mg <- spread(mg, key = "genres", value = "value", fill = NA)
final_mg <- final_mg[,-c(1,2)]

write.csv(final_mg, "./data/final_mg.csv",row.names = F)
#final_mg 생성완료
############################################################################
############################################################################

#진행중----------------------------------------------------------------------
# final_mr <- read.csv('./data/final_mr.csv',header=T)
# final_mg <- read.csv('./data/final_mg.csv',header=T)
mr <- read.csv('./data/mr.csv',header=T)
mg <- read.csv('./data/mg.csv',header=T)
m <- read.csv('./data/movies.csv',header=T)
r <- read.csv('./data/ratings.csv',header=T)
t <- read.csv('./data/tags.csv',header=T)
g <- read.csv('./data/genres.csv',header=T)
# 이거 가지고 시각화


#3683개 태그가 존재
t2 = t[,-1]
index = sample(1:nrow(t2), size=nrow(t2)*0.7)
train = t2[index,]
test = t2[-index,]
head(train)

sum(duplicated(train))
sum(duplicated(test))
train <- train[-which(duplicated(train)|duplicated(train,fromLast=T)),]
test = test[-which(duplicated(test)|duplicated(test,fromLast=T)),]

# 태그 보류 ----> 정보 부족 ----> 워드클라우드 정도로 끝