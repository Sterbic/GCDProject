# Get the data

data.dir = "data"
data.zip.path = sprintf("%s/dataset.zip", data.dir)

dir.create(data.dir, showWarnings = FALSE)

download.file(
    url = paste("https://d396qusza40orc.cloudfront.net/", 
                "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                sep = ""
                ),
    destfile = data.zip.path,
    method = "curl",
    quiet = TRUE
    )

unzip(data.zip.path, exdir = "data")
unlink(data.zip.path)

# Read the data

subjects = numeric(0)
data = matrix(nrow = 0, ncol = 561)
labels = numeric(0)

for(set.origin in c("train", "test")) {
    set.origin.dir = sprintf("%s/UCI HAR Dataset/%s", data.dir, set.origin)
    
    subjects.part = read.table(sprintf("%s/subject_%s.txt",
                                       set.origin.dir, set.origin))
    data.part = read.table(sprintf("%s/X_%s.txt", set.origin.dir, set.origin),
                           colClasses = "numeric")
    labels.part = read.table(sprintf("%s/y_%s.txt", set.origin.dir,
                                     set.origin))
    
    subjects = rbind(subjects, subjects.part)
    data = rbind(data, data.part)
    labels = rbind(labels, labels.part)
}

dataset = data.frame(subjects, labels, data)

# Extract mean and stdev measurements

features = read.table(sprintf("%s/UCI HAR Dataset/features.txt", data.dir))

features.mean = grep("mean\\(\\)", features[, 2])
features.stdev = grep("std\\(\\)", features[, 2])

features.extract = sort(union(features.mean, features.stdev))
col.names = c("subject", "label.id",
              as.character(features[features.extract, 2]))

dataset = dataset[, c(1, 2, features.extract + 2)]
colnames(dataset) = col.names

# Descriptive activity labels

labels.path = sprintf("%s/UCI HAR Dataset/activity_labels.txt", data.dir)
labels = read.table(labels.path, col.names = c("id", "activity"))

dataset = merge(dataset, labels, by.x = "label.id", by.y = "id")
dataset = dataset[, -which("label.id" %in% names(dataset))]

# Write to file

write.table(dataset, "tidy-dataset.txt", row.names = FALSE)

# Summarize by subject and activity

dataset.mean = aggregate(
    x = dataset[, -which(colnames(dataset) %in% c("subject", "activity"))],
    by = list(dataset$subject, dataset$activity),
    mean
    )

colnames(dataset.mean)[1:2] = c("subject", "activity")

# Write summary to file

write.table(dataset.mean, "tidy-dataset-avg.txt", row.names = FALSE)
