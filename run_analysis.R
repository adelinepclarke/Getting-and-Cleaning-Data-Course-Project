#set wd to  the unzipped folder "UCI HAR Dataset"
setwd("\\\\uds/4/aclarke5/Documents/R Working Directory/UCI HAR Dataset")

#PART 1

#read activity test and train data into variables
testActData <- read.table(file.path("test", "Y_test.txt"), header=FALSE)
trainActData <- read.table(file.path("train", "Y_train.txt"), header=FALSE)

#read subject test and train data into variables
testSubData <- read.table(file.path("test", "subject_test.txt"), header=FALSE)
trainSubData <- read.table(file.path("train", "subject_train.txt"), header=FALSE)

#read features test and train data into variables
testFeatData <- read.table(file.path("test", "X_test.txt"), header=FALSE)
trainFeatData <- read.table(file.path("train", "X_train.txt"), header=FALSE)

#merge test and training data for activity, subject and features
ActData<- rbind(testActData, trainActData)
SubData <- rbind(testSubData, trainSubData)
FeatData <- rbind(testFeatData, trainFeatData)

#set names for variables
names(ActData) <- c("activity")
names(SubData) <- c("subject")
FeatNames<- read.table("features.txt", header=FALSE)
names(FeatData) <- FeatNames$V2

#create full merged dataset
MergedData <- cbind(FeatData, SubData, ActData)

#PART 1 COMPLETE

#PART 2
#pull out only features with "mean()" or "std()"
MeanStdFeatNames <- FeatNames$V2[grep("mean\\(\\)|std\\(\\)", FeatNames$V2)]

#subset merged data frame 
SelNames <- c(as.character(MeanStdFeatNames), "subject", "activity")
NewData <- subset(MergedData, select=SelNames)

#PART 2 COMPLETE

#PART 3
#read labels from file "activity_labels.txt"
ActLab <- read.table("activity_labels.txt", header=FALSE)
NewData$activity <- factor(NewData$activity)
NewData$activity <- factor(NewData$activity, labels=as.character(ActLab$V2))

#PART 3 COMPLETE

#PART 4
#replacing names in NewData to be more descriptive
names(NewData)<-gsub("^t", "time", names(NewData))
names(NewData)<-gsub("^f", "frequency", names(NewData))
names(NewData)<-gsub("Acc", "Accelerometer", names(NewData))
names(NewData)<-gsub("Gyro", "Gyroscope", names(NewData))
names(NewData)<-gsub("Mag", "Magnitude", names(NewData))
names(NewData)<-gsub("BodyBody", "Body", names(NewData))

#PART 4 COMPLETE

#PART 5
#create tidy data set containg only the mean of each variable, each activity, each subject based on dataset from 4
Data2<-aggregate(. ~subject + activity, NewData, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
