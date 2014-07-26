##########################################################################################################
##                                                                                                      ##  
## title: "run_analysis.R"                                                                              ##
## author: "jvmunoz"                                                                                    ## 
## date: "Sunday, July 20, 2014"                                                                        ##  
## Description:                                                                                         ##
##    This programm applies the following steps to the UCI HAR Dataset downloaded from                  ##
##    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip            ## 
##    1.- Merges the training and the test sets to create one data set.                                 ##
##    2.- Extracts only the measurements on the mean and standard deviation for each measurement.       ##
##    3.- Uses descriptive activity names to name the activities in the data set.                       ##
##    4.- Appropriately labels the data set with descriptive variable names.                            ##
##    5.- Creates a second, independent tidy data set with the average of each variable for each        ##
##        activity and each subject.                                                                    ##
##                                                                                                      ##
##########################################################################################################


# First of all we set and clean up the workspace. 

if(getwd()!="C:/Users/JoseVicente/Desktop/Data Science/Johns Hopkins/Getting and Cleaning Data/Getting-and-Cleaning-Data-Course-Project")
{
   setwd("C:/Users/JoseVicente/Desktop/Data Science/Johns Hopkins/Getting and Cleaning Data/Getting-and-Cleaning-Data-Course-Project")
}

rm(list=ls())


# 1.- Merges the training and the test sets to create one data set.

# 1.1 Reads data from files

features       <- read.table('./UCI HAR Dataset/features.txt',header=FALSE)            #imports features.txt

activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE)     #imports activity_labels.txt

subjectTrain   <- read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE) #imports subject_train.txt
subjectTest    <- read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE)   #imports subject_test.txt

xTrain         <- read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE)       #imports x_train.txt
xTest          <- read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE)         #imports x_test.txt

yTrain         <- read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE)       #imports y_train.txt
yTest          <- read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE)         #imports y_test.txt

# 1.2 Assigns column names to the previous data

colnames(activityLabels)  <- c('activityId','activityType')

colnames(subjectTrain)    <- "subjectId"
colnames(subjectTest)     <- "subjectId"

colnames(xTrain)          <- features[,2] 
colnames(xTest)           <- features[,2]

colnames(yTrain)          <- "activityId"
colnames(yTest)           <- "activityId"

# 1.3 Creates the final training set by merging subjectTrain, yTrain and xTrain 

training <- cbind(subjectTrain,yTrain,xTrain)

# 1.4 Creates the final test set by merging subjectTest, yTest, and xTest

test <- cbind(subjectTest,yTest,xTest)

# 1.5 Combines training and test data to create a final data set

final <- rbind(training,test)


# 2.- Extracts only the measurements on the mean and standard deviation for each measurement. 

# 2.1 Creates a vector for the column names of final 
#     it will be used to select the desired mean() & std() columns

colNames <- colnames(final)

# 2.2 Creates a vector that contains TRUE values for subjectID, activityID, 
#     mean() & std() and FALSE for the rest
#     we do not consider variables with meanFreq 

variablesIwant <- (
        grepl("subject..",colNames) |         
        grepl("activity..",colNames) |
        (grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames)) |
        grepl("-std..",colNames)
        )

# 2.3 Subsets final depending on the vector variablesIwant

final <- final[variablesIwant==TRUE]


# 3. Uses descriptive activity names to name the activities in the data set.

# 3.1 Merges final with activityLabels to add activity description

final <- merge(final,activityLabels,by='activityId',all.x=TRUE)

# 3.2 We have added a new variable to final, so
#     we must update colNames vector to consider this

colNames <- colnames(final)


# 4. Appropriately labels the data set with descriptive variable names. 

# 4.1 Let's replace variable names by more significant ones 

for (i in 1:length(colNames)) 
{

        colNames[i] <- gsub("[()-]","",colNames[i])      # removes parenthesis and dashes
        
        colNames[i] <- gsub("mean","Mean",colNames[i])   # changes mean into Mean
        colNames[i] <- gsub("std","Std",colNames[i])     # changes std into Std
      

        colNames[i] <- gsub("^(t)","time",colNames[i])   # changes variables beginning with t into time
        colNames[i] <- gsub("^(f)","freq",colNames[i])   # changes variables beginning with f into freq
        
        colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] <- gsub("[Aa]cc","Acc",colNames[i])
        colNames[i] <- gsub("[Mm]ag","Magnitude",colNames[i])
        colNames[i] <- gsub("[Jj]erk","Jerk",colNames[i])
}

# 4.2 We must update colNames vector again

colnames(final) <- colNames

# 4.3 Export the final data set 

write.table(final, "./UCI HAR Dataset/tidyData1.txt",row.names=FALSE,sep='\t')


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 5.1 Create a new table, finalNoActivityType without the activityType column

finalNoActivityType <- final[,names(final) != 'activityType']

# 5.2 Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject

tidyData <- aggregate(finalNoActivityType[,names(finalNoActivityType) != c('activityId','subjectId')],
                      by=list(activityId=finalNoActivityType$activityId,subjectId = finalNoActivityType$subjectId),
                      mean)

# 5.3 Merging the tidyData with activityLabels to include descriptive acitvity names

tidyData <- merge(tidyData,activityLabels,by='activityId',all.x=TRUE)

# 5.4 Export the tidyData set 

write.table(tidyData, "./UCI HAR Dataset/tidyData2.txt",row.names=FALSE,sep='\t')