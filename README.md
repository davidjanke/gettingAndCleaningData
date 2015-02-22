# Analysing UCI HAR dataset

The R script in this folder (run_analysis.R) is intended to solve the project for the [Coursera](http://www.coursera.org/) course Getting and Cleaning data by Jeff Leak.

### Prerequisites
* You will need the dplyr and reshape2 packages to be installed to be able to run.
* navigate to the dataset root directory of the UCI HAR Dataset where the test and train folders can be found

### What you will get
After running you will have a variable in your running environment called *meansPerActivityAndSubject*. It will contain the means per activity and test subject for each measurable mean and standard deviation provided by the original dataset.

The code book for the result can be found in codebook.txt