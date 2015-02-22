# Analysing UCI HAR dataset

The R script in this folder (run_analysis.R) is intended to solve the project for the [Coursera](http://www.coursera.org/) course Getting and Cleaning data by Jeff Leak.

### Prerequisites
* You will need the dplyr and reshape2 packages to be installed to be able to run.
* navigate to the dataset root directory of the UCI HAR Dataset where the test and train folders can be found

### What you will get
After running you will have a variable in your running environment called *meansPerActivityAndSubject*. It will contain the means per activity and test subject for each measurable mean and standard deviation provided by the original dataset.

You can specify a variable before running the script to clean up the data that is created while the script is running. It's name is cleanUpIntermediaryData and it has to be set to TRUE to achieve this. It will however not remove the result data.

The code book for the result can be found in codebook.txt

## How it works
There are two utility functions in the script.
* getColClassesFiltering function is to create a vector of column classes. As described in the script itself this is to save some memory. _read.table_ can omit certain columns if the corresponding column class is "NULL". This method takes a vector of column names, a column class and regular expression. It will return a vector of column classes, where matching columns will get the passed column class and everything else just will be NULL.

* readPartialDataSet function will return a nameless dataframe. The reason for this function is to not code the binding of raw data, training name and subject ID twice, but leverage the standardised folder structure. If we more than two folders, we could easily use this function to iterate through them and bind all the data.

Other than the utility functions there script does the following:
- create the pattern to filter the column names for
- read the measurement column names
- create the col classes vector to be able to omit unnecessary columns based on the pattern
- store the names of the pattern matching columns
- read the data from the two folders and rowbind them
- set the column names (prepend with the training name and subject ID)
- read the training names and keys
- merge the training names with the raw data (and remove the ID of thre training type)
- melt the result data, use training names and subject IDs as the IDs, everything else is values
- cast the means from the melted data