###############################################################################
# Gyro data analisys for data cleaning and getting course on coursera
#
# The script assumes you are in the root directory of the UCI HAR dataset
#
# This script requires the dplyr and reshape2 packages to be installed
#
###############################################################################
library(dplyr)
library(reshape2)

###############################################################################
# a generic function that will create a character vector containing 
# originalColClass where the columns vector mathces the pattern, and
# "NULL" in other places
###############################################################################
getColClassesFiltering <- function(columns, originalColClass, pattern) {
    matchingColumns <- grepl(pattern, columns)
    sapply(matchingColumns, function(x){ if(x) { originalColClass } else { "NULL" } })
}


###############################################################################
# Read the data from a directory in the dataset
#
# It will read and bind data by columns.
#
# directory is the directory where the data needs to be parsed from
# colClassesFilter is the column filter by which the data will be read
# 
# Assuming that all directories have a coherent file naming structure as
# described in the helpfile
###############################################################################
readPartialDataSet <- function(directory, colClassesFilter) {
    originalDir <- getwd()
    setwd(directory)
    
    # predefine the file name patterns so we can reuse later for multiple directories
    trainingDataFilePattern <- "X_DIRNAME.txt"
    subjectKeyFilePattern <- "subject_DIRNAME.txt"
    trainingKeyFilePattern <- "y_DIRNAME.txt"
    
    trainingData <- read.table(sub("DIRNAME", directory, trainingDataFilePattern), colClasses = colClassesFilter)
    subjectKey <- read.table(sub("DIRNAME", directory, subjectKeyFilePattern))
    trainingKey <- read.table(sub("DIRNAME", directory, trainingKeyFilePattern))
    
    setwd(originalDir)
    
    # bind the data, asssuming they have all the same number of datarows
    cbind(subjectKey, trainingKey, trainingData)
    
}


# let's define the column pattern as a constant
columnPattern = "(mean|std)[({2})]"

# read the feature set
features <- read.table("features.txt", colClasses = c("NULL", "character"))

# Let's save some memory in the first place.
# I know whan could read the whole data and then use the select statement in the dplyr
# package to pick our columns, but given the huge amount of data, I don't think
# that is an adequate approach at this point.

# Create a column class vector that contains "numeric" for columsn to be read and
# "NULL" for others. That will tell read.table to omit columsn where the class is "NULL"
columnClassesToBeRead <- getColClassesFiltering(features[,1], "numeric", columnPattern)
columnNamesToBeRead <- grep(columnPattern, features[,1], value = T)

# read and put the two datasets together
allTrainingData <- rbind(readPartialDataSet("test", columnClassesToBeRead), readPartialDataSet("train", columnClassesToBeRead))
# set the column names
names(allTrainingData) <- c("subject_ID", "trainingKey", columnNamesToBeRead)

# Read the training key to description mapping
trainingKeys <- read.table("activity_labels.txt", col.names = c("trainingKey", "Training_Name"))

# merge the raw data with the training names and remove the training key, as we don't need it
allTrainingData <- select(merge(trainingKeys, allTrainingData), -trainingKey)

# melt the data by the training names and subjects so we can simply run stats on it
trainMelt <- melt(allTrainingData, id=c("Training_Name", "subject_ID"))

# create the means per training name and test subject
meansPerActivityAndSubject <- dcast(trainMelt, Training_Name + subject_ID ~ variable, mean)