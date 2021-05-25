############################################################################
############################################################################
####05월 25일 기준 code file 구조
#(1)movies_확인_0525.R
#(2)movies_탐색_0525.R
############################################################################
############################################################################



#movies에 있는 장르분리 및 장르df생성
g <- data.table()
n <- nrow(m)
for (i in 1:n){
  
  #print(i)
  
  name_index <- as.character(m[i, 1])
  item_index <- as.character(m[i, 3])
  
  item_index_split_temp <- data.frame(strsplit(item_index, split = '\\|'))
  m_temp <- data.frame(cbind(name_index, item_index_split_temp))
  
  names(m_temp) <- c("movieId", "genres")
  
  g <- rbind(g, m_temp)
}
rm(name_index, item_index, item_index_split_temp, m_temp) # delete temp dataset
glimpse(g)
summary(g)

g$movieId <- as.integer(g$movieId)
m <- m[,-3]

#데이터재구조
r <- r[,-4]
t <- t[,-4]

#----------------------------------------------------------------------------
#장르확인
unique(g$genres)
#(no genres listed) -> NA 결측치 처리
g$genres<- gsub("\\(no genres listed\\)", NA, g$genres)
barplot(table(g$genres))
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
write.csv(m, "./data/new_movies.csv",row.names = F)
write.csv(r, "./data/new_ratings.csv",row.names = F)
write.csv(t, "./data/new_tags.csv",row.names = F)
write.csv(g, "./data/new_genres.csv",row.names = F)
#----------------------------------------------------------------------------
