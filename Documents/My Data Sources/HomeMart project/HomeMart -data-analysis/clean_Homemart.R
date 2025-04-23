# Đọc file Customer_Behavior
Customer_Behavior_0 <- read.csv("C:/Users/AD/Documents/My Data Sources/HomeMart project/03_Customer_Behavior_Data.csv", header=TRUE)
head(Customer_Behavior_0)

# Đọc file Item_Information
Item_Information_0 <- read.csv("C:/Users/AD/Documents/My Data Sources/HomeMart project/03_Item_Information_Data.csv", header=TRUE)

# Đọc file Shelf_Information
Shelf_Information_0 <- read.csv("C:/Users/AD/Documents/My Data Sources/HomeMart project/03_Shelf_Information_Data.csv", header=TRUE)


#cấu trúc của bảng (loại data, định dạng)
str(Customer_Behavior_0)  

library(lubridate)
# Chuyển đổi timestamp
Customer_Behavior_0$Timestamp <- as_datetime(Customer_Behavior_0$Timestamp, tz="Asia/Ho_Chi_Minh")

# Kiểm tra kết quả
head(Customer_Behavior_0)

summary(is.na(Customer_Behavior_0)) #Tìm các gía trị NA

library(dplyr)


#-------- XỬ LÝ CÁC GIÁ TRỊ NA -----------------
Customer_Behavior_0 <- Customer_Behavior_0[!(is.na(Customer_Behavior_0$Putting.item.into.bag) & 
                                               is.na(Customer_Behavior_0$Taking.item.out.of.bag) & 
                                               is.na(Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time)), ]

#Nếu cột Putting item into bag = False, điền giá trị trong 2 cột Taking item into bag và Putting item into bag in the 2nd time là False nếu Null
Customer_Behavior_0$Taking.item.out.of.bag[Customer_Behavior_0$Putting.item.into.bag == FALSE & 
                                               is.na(Customer_Behavior_0$Taking.item.out.of.bag)] <- FALSE

Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time[Customer_Behavior_0$Putting.item.into.bag == FALSE & 
                                                              is.na(Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time)] <- FALSE

#Nếu cột Putting item into bag = True và cột Taking item out of bag = False, thì điền giá trị trong cột Putting item into bag in the 2nd time = False nếu Null.
Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time[
  Customer_Behavior_0$Putting.item.into.bag == TRUE & 
    Customer_Behavior_0$Taking.item.out.of.bag == FALSE & 
    is.na(Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time)
] <- FALSE

#Nếu cột Putting item into bag = True và cột Putting item into bag in the 2nd time = False, điền giá trị trong cột Taking item out of bag = True nếu Null
Customer_Behavior_0$Taking.item.out.of.bag[
  Customer_Behavior_0$Putting.item.into.bag == TRUE & 
    Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time == FALSE & 
    is.na(Customer_Behavior_0$Taking.item.out.of.bag)
] <- TRUE

#Nếu cột Taking item out of bag = True và cột Putting item into bag in the 2nd time = True, thì điền giá trị cột Putting item into bag = True nếu Null.
Customer_Behavior_0$Putting.item.into.bag[
  Customer_Behavior_0$Taking.item.out.of.bag== TRUE & 
    Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time == TRUE & 
    is.na(Customer_Behavior_0$Putting.item.into.bag)
] <- TRUE


#Xóa các dòng khi có cả 2 cột Taking item out of bag và Putting item into bag the 2nd time đều Null. 
Customer_Behavior_0 <- Customer_Behavior_0[!(is.na(Customer_Behavior_0$Taking.item.out.of.bag) & 
                                               is.na(Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time)), ]

#Xóa các dòng còn lại nếu không thuộc các Trường hợp trên nếu vẫn chứa giá trị Null ở 1 trong 3 cột trên. 
Customer_Behavior_0 <- Customer_Behavior_0 %>% 
  filter(!is.na(Putting.item.into.bag) & 
           !is.na(Taking.item.out.of.bag) & 
           !is.na(Putting.item.into.bag.in.the.2nd.time))

#Nếu cột Putting item into bag = True và cột Putting item into bag in the 2nd time = False, điền giá trị trong cột Taking item out of bag = True nếu Null
Customer_Behavior_0$Taking.item.out.of.bag[Customer_Behavior_0$Putting.item.into.bag == TRUE & 
                                               Customer_Behavior_0$Putting.item.into.bag.in.the.2nd.time == FALSE & 
                                               is.na(Customer_Behavior_0$Taking.item.out.of.bag)] <- TRUE


summary(is.na(Customer_Behavior_0)) #Tìm các gía trị NA sau khi xử lý

write.csv(Customer_Behavior_0, "C:/Users/AD/Downloads/cleaned_data.csv", row.names = FALSE)


length(unique(Customer_Behavior_0$Person.ID))


summary(is.na(Item_Information_0)) #Tìm các gía trị NA

write.csv(Shelf_Information_0, "C:/Users/AD/Downloads/Shelf_data.csv", row.names = FALSE)





