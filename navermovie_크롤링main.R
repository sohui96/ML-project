##
library(XML)
library(stringr)
url_base <- 'https://movie.naver.com/movie/sdb/rank/rmovie.nhn?sel=pnt&date=20210519&page=' #네이버 영화 랭킹 목록

all.codes <- c() #영화 코드 목록
all.titles <- c() #영화 이름 목록
all.points <- c() #영화 평점 목록

# 1-40페이지 영화 목록 수집
for(page in 1:40){
  
  url <- paste(url_base, page, sep='')
  txt <- readLines(url, encoding="euc-kr")
  
  movie_info <- txt[which(str_detect(txt, "class=\"tit5\""))+1] #tit5클래스 아래 1줄 아래에는 영화 고유코드와 제목이 있다.
  points <- txt[which(str_detect(txt, "class=\"tit5\""))+7] #tit5클래스 아래 7줄 아래에는 평점이 있다.
  
  #titles #print
  #points #print
  
  codes <- substr(movie_info, 40, 50) #일부 코드를 선택
  codes <- gsub("\\D","",codes) #코드 중 숫자만 남기고 지우기
  titles <- gsub("<.+?>|\t", "", movie_info) # 텍스트만 남기고 코드 지우기 (이렇게하면 소스코드인식을 안하는듯)
  points <- gsub("<.+?>|\t", "", points) # 텍스트만 남기고 코드 지우기
  
  all.codes <-  c(all.codes, codes) #영화 코드값 저장
  all.titles <- c(all.titles, titles) #영화 이름 저장
  all.points <- c(all.points, points) #영화 평점 저장
}

#txt 파일로 출력
x <- cbind(all.codes, all.titles, all.points)
colnames(x) <- c("code", "movie_title", "point")
x <- as.data.frame(x)
#x <- data.frame(code=c(all.codes), movie_title=c(all.titles),point=c(all.points))

write.csv(x, "./data/movie_list.csv")
