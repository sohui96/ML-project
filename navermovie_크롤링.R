#library(rvest)
library(XML)
library(stringr)

all_reviews <- NULL
code <- 17421
url_base <- paste0('http://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=',code,'&type=after&onlyActualPointYn=N&order=newest&page=')

#https://movie.naver.com/movie/bi/mi/review.nhn?code=200052

for (i in 1:2) { #2->100, 100페이지*10건리뷰
  temp <- NULL
  url <- paste(url_base, i, sep='')
  txt <- readLines(url, encoding="UTF-8")
  
  points <- txt[which(str_detect(txt, "class=\"star_score\""))+2]
  points <- gsub("<.+?>|\t","", points)
  points <- points[c(2:11)]  #한 리뷰 페이지당 데이터가 11건이 나옴 (첫번째의 불필요한행 존재. 때문에 2번째 행부터 11번째 행의 값만 가져옴)
  
  reviews <- txt[which(str_detect(txt, "class=\"score_reple\""))+1]
  reviews <- gsub("<.+?>|\t","", reviews)
  
  temp <- cbind(points, reviews)
  all_reviews <- rbind(all_reviews, temp)
}

write.table(all_reviews, "./Temp/movie_review.txt")










