## load the dplyr library for easy manipulations
library(dplyr)
library(reshape2)

## read in the activity labels
activity_labels <- read.table("./activity_labels.txt")

## read in the feature labels
## these will be the column names for the data frames
features <- read.table("./features.txt")

## read in the test and train data using the features as column names
test <- read.table("./test/X_test.txt",col.names = features[,2])
train <- read.table("./train/X_train.txt",col.names = features[,2])

## read in the subject data for test and train
test_subjects <- read.table("./test/subject_test.txt")
train_subjects <- read.table("./train/subject_train.txt")

## add the subject id's to their respective tables
test$subject <- test_subjects[[1]]
train$subject <- train_subjects[[1]]

## remove the subject id tables because we are done with them
rm(test_subjects)
rm(train_subjects)

## read in the activity data for test and train
test_activity <- read.table("./test/y_test.txt")
train_activity <- read.table("./train/y_train.txt")

## add the activity id's to their respective tables
test$activity <- test_activity[[1]]
train$activity <- train_activity[[1]]

## remove the activity id tables because we are done with them
rm(test_activity)
rm(train_activity)

## merge the two data frames 
combined <- rbind(test,train)

## remove test and train now that we have all the data in one frame
rm(test)
rm(train)

## extract only the mean() and std() measurements 
## while keeping the subject and activity values
fieldsToKeep <- grep("mean\\(\\)|std\\(\\)",features[[2]])
combined <- select(combined, subject, activity, fieldsToKeep)

## remove temporary vector and also done with the features vector
rm(fieldsToKeep)
rm(features)

## fill in descriptive names to the activity column
## labes taken from the activity_labels data frame
combined$activity <- factor(combined$activity,levels = activity_labels[[1]],labels = activity_labels[[2]])

## remove activity_labels, now that its no longer needed
rm(activity_labels)

## rename the variable names by expanding on abbreviations
## and removing unnecessary .'s
newnames <- colnames(combined)
newnames <- sub("^f","frequency",newnames)
newnames <- sub("^t","time",newnames)
newnames <- sub("Acc","Accelerometer", newnames)
newnames <- sub("Gyro","Gyroscope", newnames)
newnames <- sub("\\.mean\\.*","Mean",newnames)
newnames <- sub("\\.std\\.*","Std",newnames)
newnames <- sub("(X|Y|Z)$","\\1axis",newnames)
newnames <- sub("Mag","Magnitude",newnames)
colnames(combined) <- newnames

## cleanup temporary vector
rm(newnames)

## make a new data frame that contains the average of
## each variable for each activity and each subject
grouped <- melt(combined,id.vars = c("subject","activity"),na.rm = TRUE)
grouped <- dcast(grouped,subject+activity ~ variable,mean)

#output result
write.table(grouped,file="averagesBySubjectAndActivity.txt",row.names=FALSE)