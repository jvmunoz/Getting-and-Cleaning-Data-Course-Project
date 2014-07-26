---
title: "README.md"
author: "jvmunoz"
date: "Sunday, July 20, 2014"
output:
  html_document:
    theme: cerulean
---

Getting-and-Cleaning-Data-Project
=================================

In this README.md file, you can find how the requirements have been implemented through the code

In any case, you can follow the comments in the code

The requirements are:

Apply the following steps to the UCI HAR Dataset downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1.- Merges the training and the test sets to create one data set.                                 
2.- Extracts only the measurements on the mean and standard deviation for each measurement.       
3.- Uses descriptive activity names to name the activities in the data set.                       
4.- Appropriately labels the data set with descriptive variable names.                            
5.- Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### First of all we set and clean up the workspace.

  - There is an specific folder for this project in my computer

  - I will keep all the input and output files under UCI HAR Dataset subfolder

  - I clean up all the possible data sets in my workspace

### 1.- Merges the training and the test sets to create one data set.

#### 1.1 Reads data from files

- I first read all the raw text data set under UCI HAR Dataset subfolder: features, activityLabels, subjectTrain, subjectTest, xTrain, xTest, yTrain and yTest

#### 1.2 Assigns column names to the previous data

  - In order to combine later the different files, we standardize column names of the read files
  
#### 1.3 Creates the final training set by merging subjectTrain, yTrain and xTrain 

#### 1.4 Creates the final test set by merging subjectTest, yTest, and xTest

#### 1.5 Combines training and test data to create a final data set

### 2.- Extracts only the measurements on the mean and standard deviation for each measurement. 

#### 2.1 Creates a vector for the column names of final data set colNames

  - It will be used to select the desired mean() & std() columns later

#### 2.2 Creates the logical vector variablesIwant that contains:

  - TRUE values for subjectID, activityID, mean() & std()
    - I do not consider variables with meanFreq
  - FALSE for the rest of columns

#### 2.3 Subsets final depending on the vector variablesIwant

  - I keep only the columns in final data set with a TRUE in the vector variablesIwant 
  
### 3. Uses descriptive activity names to name the activities in the data set.

#### 3.1 Merges final data set with activityLabels to add activity description  

#### 3.2 We have added a new variable to final, so I reassign column names to consider this

### 4. Appropriately labels the data set with descriptive variable names. 

#### 4.1 Let's replace variable names by more significant ones 

  - I remove parenthesis and dashes
  - I change mean into Mean
  - I change std into Std
  - I change variables beginning with t into time
  - I change variables beginning with f into freq
  - etc.

#### 4.2 We must update colNames vector again

  - I reassign column names to consider these last changes
  
#### 4.3 Export the final data set 

  - The output file called tidyData1.txt will be located at UCI HAR Dataset subfolder
  - tidyData1.txt is a tab-delimited text file

### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### 5.1 Create a new table, finalNoActivityType without the activityType column

  - In order to compute the mean I remove previously the column activityType
  
#### 5.2 Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject

#### 5.3 Merging the tidyData with activityTLabels to include descriptive acitvity names

  - I merge again the activity description

#### 5.4 Export the tidyData set

  - The output file called tidyData2.txt will be located at UCI HAR Dataset subfolder
  - tidyData2.txt is a tab-delimited text file