# Author: Narayan Natarajan
# Coursera: Getting and Cleaning Data Course Project
#
# Read the activity table and set friendly header names for clarity
actdf<-read.table(file("activity_labels.txt"),col.names=c("ID","Activity"))

#> actdf
#ID             Activity
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING

# same treatment for reading features.txt
featdf<-read.table(file("features.txt"),col.names=c("ID","Feature"))
#> head(featdf)
#ID           Feature
#1  1 tBodyAcc-mean()-X
#2  2 tBodyAcc-mean()-Y
#3  3 tBodyAcc-mean()-Z
#4  4  tBodyAcc-std()-X
#5  5  tBodyAcc-std()-Y
#6  6  tBodyAcc-std()-Z

# obtain a filtered dataset of feature that contain either 'std' or 'mean' in their names
# this activity can be tailored to the end set. Note that the current filter will
# include items such as angle(X,gravity*Mean*). This is in my opinion correct since
# it is a metric that is driven by a mean value. If this is an incorrect interpretation,
# then the grep can be tuned with regular expression: 'mean\\(|std\\(' this will force
# the grep to look for the keywords immediately before a '(' character.

gf<-grepl("mean|std",featdf$Feature,ignore.case = T)
# obtain a list of numeric and NULL, NULL allows us to skip columns during read.table
colc<-sapply(gf,function(i) ifelse(i,"numeric","NULL"))

# -- read test data set
# read the subject table as a numeric so it is easier to sort if needed
test_s<-as.numeric(readLines("test/subject_test.txt"))


#pass column names, and column classes with the NULLs to skip columns. This should
# reduce the memory footprint and improve efficiency of data manipulation

test_x<-read.table("test/X_test.txt",colClasses = colc,col.names=featdf$Feature)

# read y_test.txt to a data frame, and in addition set the col name as Activity 
# and set the class as factor so we can apply custom levels from actdf 
test_y<-read.table("test/y_test.txt",col.names=c("Activity"),colClasses=c("factor"))
levels(test_y$Activity)<-actdf$Activity

# > head(test_y)
#Activity
#1 STANDING
#2 STANDING
#3 STANDING
#4 STANDING
#5 STANDING
#6 STANDING

# Column bind the three items, to generate a 'merged' test_m data set
test_m<-cbind(subject=test_s,test_y,test_x)


# -- read train data set
# read the subject table as a numeric so it is easier to sort if needed
train_s<-as.numeric(readLines("train/subject_train.txt"))
                   
#pass column names, and column classes with the NULLs to skip columns. This should
# reduce the memory footprint and improve efficiency of data manipulation
train_x<-read.table("train/X_train.txt",colClasses = colc,col.names=featdf$Feature)

# read y_train.txt to a data frame, and in addition set the col name as Activity 
# and set the class as factor so we can apply custom levels from actdf 
train_y<-read.table("train/y_train.txt",col.names=c("Activity"),colClasses=c("factor"))
levels(train_y$Activity)<-actdf$Activity

# > head(train_y)
#Activity
#1 STANDING
#2 STANDING
#3 STANDING
#4 STANDING
#5 STANDING
#6 STANDING

# Column bind the three items, to generate a 'merged' test_m data set
train_m<-cbind(subject=train_s,train_y,train_x)

#Now rbind the two to generate a single merged data frame 'm'
m<-rbind(train_m,test_m)

#> nrow(m)
#[1] 10299

# run aggregation using mean as function and ignore the first two columns subject and Activity
# 

ag<-aggregate(m[,-c(1,2)],by=m[c("subject","Activity")],FUN=mean,na.rm=TRUE)

# order the data by subject, then activity for cleanliness
agar<-arrange(ag,subject,Activity)
write.table(agar,file="tidy.txt",row.names=FALSE)

