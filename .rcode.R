
#Reading the data

subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
X_test <- read.table("test/X_test.txt")
X_train <- read.table("train/X_train.txt")
y_test <- read.table("test/y_test.txt")
y_train <- read.table("train/y_train.txt")

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")  

#Merge test and train
labels<-rbind(y_train,y_test)
data<-rbind(X_train,X_test)
subject<-rbind(subject_train,subject_test)
colnames(subject)<-'subject'
colnames(data)<-features$V2


mean_std<-data[,grepl('mean|std',colnames(data))]


#Uses descriptive activity names to name the activities in the data set

library(dplyr)

mean_std<-cbind(mean_std,labels,subject)

mean_std<-merge(mean_std,activity_labels, by ='V1')

colnames(mean_std)[82]<-'activity'


#Appropriately labels the data set with descriptive variable names.

names(mean_std)<-gsub('Acc','Acceleration',names(mean_std))
names(mean_std) <- gsub("Acc", "Acceleration", names(mean_std))
names(mean_std) <- gsub("^t", "Time", names(mean_std))
names(mean_std) <- gsub("^f", "Frequency", names(mean_std))
names(mean_std) <- gsub("BodyBody", "Body", names(mean_std))
names(mean_std) <- gsub("mean", "Mean", names(mean_std))
names(mean_std) <- gsub("std", "Std", names(mean_std))
names(mean_std) <- gsub("Freq", "Frequency", names(mean_std))
names(mean_std) <- gsub("Mag", "Magnitude", names(mean_std))


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata<-ddply(mean_std,c('subject','activity'),numcolwise(mean))

write.table(tidydata,file="tidydata.txt",row.name=FALSE)

