#무비렌즈 100,000 ratings
#943유저*1664영화
#1997.9.19 ~ 1998.4.22

#데이터 불러오기
m <- read.csv('./data/MovieLense.csv', stringsAsFactors=F)

#데이터 탐색
View(m)
str(m)
dim(m)
nrow(m)
ncol(m)
head(m)

#원소 총 갯수
nrow(m) * ncol(m)

#NA
sum(is.na(m))
sum(!is.na(m)) #sparse matrix 0(na)이많은

#영화별 평균 평점 히스토그램
hist(colMeans(m, na.rm = T), breaks = 50)

#개인당 몇 개의 영화에 대하여 평점을 매겼을까?
hist(apply(m, 1, function(x) sum(!is.na(x))), breaks = 50,
     main="개인당 평점을 매긴 영화갯수")

colMeans(m, na.rm=T)
#apply(m, 행1열2, func)
apply(m, 2, mean, na.rm=T)
apply(m, 2, median, na.rm=T)

#영화별 사용자 평점 히스토그램
hist(m[,1], main = colnames(m)[1])
hist(m[,2], main = colnames(m)[2])
hist(m[,3], main = colnames(m)[3])
hist(m[,4], main = colnames(m)[4])
hist(m[,999], main = colnames(m)[999])















#https://statkclee.github.io/ml/ml-text-movielens.html

# 0. 환경설정 --------------------------------
library(tidyverse)
library(lubridate)
library(skimr)
library(ggthemes)
library(wordcloud)
library(XML)
library(stringr)
library(rvest)
library(tidytext)
library(extrafont)
loadfonts()
library(doParallel)
library(dplyr)

# 1. 데이터 가져오기 -------------------------
## 1.1. 가져올 데이터 설정
url <- "http://files.grouplens.org/datasets/movielens/"
dataset_small <- "ml-latest-small"
dataset_full <- "ml-latest"
data_folder <- "data"
archive_type <- ".zip"

## 1.2. 작업 데이터 지정
dataset <- dataset_small
dataset_zip <- paste0(dataset, archive_type)

## 1.3. 데이터 가져와서 압축풀기
if (!file.exists(file.path(data_folder, dataset_zip))) {
  download.file(paste0(url, dataset_zip), file.path(data_folder, dataset_zip))
}

unzip(file.path(data_folder, dataset_zip), exdir = "data", overwrite = TRUE)

## 1.4. 작업결과 재확인
list.files('data/', recursive=TRUE)

## 1.5. 데이터 크기 확인
dataset_files <- c("movies", "ratings", "links", "tags")
suffix <- ".csv"

for (f in dataset_files) {
  path <- file.path(data_folder, dataset, paste0(f, suffix))
  assign(f, read_csv(path, col_types = cols()))
  print(paste(f, "파일크기:", format(object.size(get(f)), units="Mb")))
}

# 2. 데이터 전처리 -------------------------------
## 2.1. 사용자 평점 데이터 
ratings_df <- ratings %>%
  mutate(timestamp = as_datetime(timestamp))

glimpse(ratings_df)
skim(ratings_df)

## 2.2. 영화 데이터
movies_df <- movies %>%
  mutate(title = str_trim(title)) %>%
  extract(title, c("title_tmp", "year"), regex = "^(.*) \\(([0-9 \\-]*)\\)$", remove = FALSE) %>%
  mutate(year = ifelse(str_length(year) > 4, as.integer(str_split(year, "-", simplify = TRUE)[1]), as.integer(year))) %>%
  mutate(title = ifelse(is.na(title_tmp), title, title_tmp)) %>%
  select(-title_tmp)  %>%
  mutate(genres = ifelse(genres == "(no genres listed)", `is.na<-`(genres), genres))

glimpse(movies_df)
skim(movies_df)

## 2.3. 태그 데이터
tags_df <- tags %>%
  mutate(timestamp = as_datetime(timestamp))

glimpse(tags_df)
skim(tags_df)

## 2.4. 링크 데이터
glimpse(links)
skim(links)

# 3. 탐색적 데이터 분석 --------------------------------------
## 3.1. 연도별 영화 출하 분석 --------------------------------
movies_per_year <- movies_df %>%
  na.omit() %>%
  select(movieId, year) %>%
  group_by(year) %>%
  summarise(count = n())  %>%
  arrange(year)

movies_per_year %>%
  complete(year = full_seq(year, 1), fill = list(count = 0)) %>% 
  filter(year <=2015) %>% 
  ggplot(aes(x = year, y = count)) +
  geom_line(color="blue", size=1.5) +
  scale_y_continuous(labels=scales::comma) +
  theme_tufte(base_family="NanumGothic") +
  labs(x="", y="연도별 출시 영화빈도수")


## 3.1. 연도별 영화 쟝르 출하 분석 --------------------------------
movies_df %>%
  separate_rows(genres, sep = "\\|") %>% 
  count(genres) %>% 
  arrange(desc(n)) %>% 
  mutate(비율 = scales::percent(n/sum(n, na.rm=TRUE)),
           누적비율 = scales::percent(cumsum(n/sum(n, na.rm=TRUE)))) %>% 
  select(영화장르 = genres, 쟝르빈도수=n, 쟝르비율=비율, 누적비율) %>% 
  DT::datatable() %>% 
  DT::formatRound("쟝르빈도수", interval=3, digits=0)


movies_df %>%
  separate_rows(genres, sep = "\\|") %>%
  na.omit() %>% 
  mutate(genres = as.factor(genres)) %>% 
  group_by(year, genres) %>%
  summarise(number = n()) %>%
  complete(year = full_seq(year, 1), genres, fill = list(number = 0)) %>% 
  filter(genres %in% c("Drama", "Comedy", "Thriller", "Romance", "Action", "Horror")) %>%
  filter(year >= 1900 & year <= 2015) %>% 
  ggplot(aes(x = year, y = number)) +
  geom_line(aes(color=genres)) +
  scale_fill_brewer(palette = "Paired") +
  theme_tufte(base_family="NanumGothic") +
  labs(x="", y="연도별 출시 영화빈도수", color="쟝르") +
  theme(legend.position = "top")

## 3.3. 각 쟝르별 태그 --------------------------------
genres_tags <- movies_df %>%
  na.omit() %>%
  select(movieId, year, genres) %>%
  separate_rows(genres, sep = "\\|") %>%
  inner_join(tags_df, by = "movieId") %>%
  select(genres, tag) %>%
  group_by(genres) %>%
  nest()

genre<-"Action"
genre_words <- genres_tags %>%
  filter(genres == genre) %>%
  unnest() %>%
  mutate(tag = str_to_lower(tag, "en")) %>%
  anti_join(tibble(tag=c(tolower(genre)))) %>%
  count(tag)

wordcloud(genre_words$tag, genre_words$n, max.words = 50, colors=brewer.pal(8, "Dark2"))

## 3.4. 사용자 평점에 기초한 시대별 최고 영화
# https://districtdatalabs.silvrback.com/computing-a-bayesian-estimate-of-star-rating-means

avg_rating <- ratings_df %>%
  inner_join(movies_df, by = "movieId") %>%
  na.omit() %>%
  select(movieId, title, rating, year) %>%
  group_by(movieId, title, year) %>%
  summarise(count = n(), mean = mean(rating), min = min(rating), max = max(rating)) %>%
  ungroup() %>%
  arrange(desc(mean))

weighted_rating <- function(R, v, m, C) {
  return (v/(v+m))*R + (m/(v+m))*C
}

# R = average for the movie (mean) = (Rating)
# v = number of votes for the movie = (votes)
# m = minimum votes required to be listed in the Top 250
# C = the mean vote across the whole report
avg_rating <- avg_rating %>%
  mutate(wr = weighted_rating(mean, count, 500, mean(mean))) %>%
  arrange(desc(wr))

avg_rating 

avg_rating %>%
  mutate(decade = year  %/% 10 * 10) %>%
  arrange(year, desc(wr)) %>%
  group_by(decade) %>%
  summarise(title = first(title), wr = first(wr), mean = first(mean), count = first(count)) %>% 
  DT::datatable() %>% 
  DT::formatRound("count", digits = 0, interval = 3)

## 3.5. 사용자 평점에 기초한 쟝르별 최고 영화

genres_rating <- movies_df %>%
  na.omit() %>%
  select(movieId, year, genres) %>%
  inner_join(ratings_df, by = "movieId") %>%
  select(-timestamp, -userId) %>%
  mutate(decade = year  %/% 10 * 10) %>%
  separate_rows(genres, sep = "\\|") %>%
  group_by(year, genres) %>%
  summarise(count = n(), avg_rating = mean(rating)) %>%
  ungroup() %>%
  mutate(wr = weighted_rating(mean, count, 500, mean(mean))) %>%
  arrange(year)

genres_rating %>%
  filter(genres %in% c("Action", "Romance", "Sci-Fi", "Western")) %>%
  ggplot(aes(x = year, y = wr)) +
  geom_line(aes(group=genres, color=genres)) +
  geom_smooth(aes(group=genres, color=genres)) +
  facet_wrap(~genres)
