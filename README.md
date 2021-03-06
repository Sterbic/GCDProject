# GCDProject

Repository for the [Getting and Cleaning Data][1] Coursera project.

## Run

To run the script use `source("run_analysis.R")` from the R console.

The script has been tested with R 3.1.1 and RStudio 0.98 on OS X 10.9.4.

## Code Book

See `CodeBook.md` for details.

## Description

The script will download and unzip the [Human Activity Recognition Using Smartphones Data Set][2] into the `data` directory. The zip archive is deleted after decompression.

Both train and test data sets are read into R and merged into one table. At this point the table contains subject IDs, activity IDs and a set of 561 numeric features.

Feature descriptions are pulled from the `features.txt` file and only features which inlcude `"mean()"` or `"std()"` in their description are retained. Such descriptions are set as column names.

Numeric activity IDs are removed in favor of descriptive activity identifiers (ex. WALKING) fetched from the `activity_labels.txt` file. At this point a tidy data set is saved to `tidy-dataset.txt`.

An independent data set with the average of each feature for each activity and each subject is computed and saved to `tidy-dataset-avg.txt`. 

[1]: https://www.coursera.org/course/getdata "Getting and Cleaning Data"
[2]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Human Activity Recognition Using Smartphones Data Set"
