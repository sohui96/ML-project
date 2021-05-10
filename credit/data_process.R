train <- read.csv("./data/train.csv", stringsAsFactors=F)
test <- read.csv("./data/test.csv", stringsAsFactors=F)
#df<- read.csv("./open/sample_submission.csv", stringsAsFactors=F)


# 데이터 탐색(reference: https://rpubs.com/kdmid/ch05_Exploratory_Data_Analysis)

# summary(train)
# FLAG_MOBIL   work_phone         phone       
# Min.   :1    Min.   :0.0000   Min.   :0.0000  
# 1st Qu.:1    1st Qu.:0.0000   1st Qu.:0.0000  
# Median :1    Median :0.0000   Median :0.0000  
# Mean   :1    Mean   :0.2247   Mean   :0.2943  
# 3rd Qu.:1    3rd Qu.:0.0000   3rd Qu.:1.0000  
# Max.   :1    Max.   :1.0000   Max.   :1.0000
# 
# email          
# Min.   :0.00000   
# 1st Qu.:0.00000  
# Median :0.00000 
# Mean   :0.09128
# Max.   :1.00000 

# str(train) 범주형 > 명목형(nominal)
# $ FLAG_MOBIL   : int  1 1 1 1 1 1 1 1 1 1 ... 핸드폰 소유 여부
# $ work_phone   : int  0 0 0 0 0 0 0 0 0 0 ... 업무용 전화 소유 여부
# $ phone        : int  0 0 1 1 0 0 0 0 0 0 ... 가정용 전화 소유 여부
# $ email        : int  0 1 0 0 0 1 1 1 1 0 ... 이메일 소유 여부
