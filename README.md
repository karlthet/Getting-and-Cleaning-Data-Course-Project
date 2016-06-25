# Tidy Data set of Mean and STD values from the Samsung Galaxy data set

## Data
This script uses the data obtained from 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

a description of which can be found here

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Script

The repository contains a script file called 'run_analysis.R'

### Requirements

The script assumed the following data files are in the working directory.

* subject_train   <-  "./train/subject_train.txt"
* X_train         <-  "./train/X_train.txt"
* Y_train         <-  "./train/y_train.txt"
* subject_test    <-  "./test/subject_test.txt"
* X_test          <-  "./test/X_test.txt"
* Y_test          <-  "./test/y_test.txt"
* features        <-  "./features.txt"
* activity_labels <-  "./activity_labels.txt"

It also depends on the following packages:

* dplyr
* reshape2

### Merge the training and the test sets to create one data set.
First the script reads in all the required files. 
The test and train subject tables are appended to their respective data sets. 
Then the test and train activity tables are appended to their respective data sets. 
The test and train tables are then bound to eachother to create one data set.

### Extract only the measurements on the mean and standard deviation for each measurement.
The data set is then reduced to only contain the subject and activity fields as well as any field that is a "mean()" or "std()" value

### Uses descriptive activity names to name the activities in the data set
The activity names are filled in from the activity_labels table using the factor function.

### Appropriately labels the data set with descriptive variable names.
The variable names are then altered to be more descriptive. 

- "^f" -> "frequency"

- "^t" -> "time"

- "Acc" -> "Accelerometer"

- "Gyro" -> "Gyroscope"

- "\\\\.mean\\\\.*" -> "Mean"

- "\\\\.std\\\\.*" -> "Std"

- "(X|Y|Z)$" -> "\\\\1axis"

- "Mag" -> "Magnitude"


### Create a second, independent tidy data set with the average of each variable for each activity and each subject.
Using the melt and dcast functions, alter the data to to be arranged by subject then activity, and average the measurements.