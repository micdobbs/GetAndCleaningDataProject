library(dplyr)

#download and expand the raw data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "rawdata.zip", method="curl")
unzip("rawdata.zip")

#Read the names of the activity labels and features
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", sep=" ", col.names=c("id", "activity_label"), colClasses=c("numeric", "character"), header=FALSE)
features = read.table("UCI HAR Dataset/features.txt", col.names=c("id", "feature"), colClasses=c("numeric", "character"), header=FALSE)


#Read the raw test data
test_labels = read.table("UCI HAR Dataset/test/y_test.txt", sep=" ", col.names=c("activity_id"), colClasses=c("numeric"), header=FALSE)
test_subjects = read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject_id"), colClasses=c("numeric"), header=FALSE)
test_data = read.table("UCI HAR Dataset/test/X_test.txt", col.names=features$feature, header=FALSE)

#join the test labels with the activity names and add that as a column to test_data
test_data$activity<-merge(activity_labels, test_labels, by.x="id", by.y="activity_id")$activity_label
#copy over the subject id to test_data
test_data$subject<-test_subjects$subject_id

#Read the raw training data
train_labels = read.table("UCI HAR Dataset/train/y_train.txt", sep=" ", col.names=c("activity_id"), colClasses=c("numeric"), header=FALSE)
train_subjects = read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject_id"), colClasses=c("numeric"), header=FALSE)
train_data = read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$feature, header=FALSE)

#join the training labels with the activity names and add that as a column to train_data
train_data$activity<-merge(activity_labels, train_labels, by.x="id", by.y="activity_id")$activity_label
#copy over the subject id to train_data
train_data$subject<-train_subjects$subject_id

#Pick the columns we want to export
export_columns=c("activity", "subject")
#We only want to export mean and stddeviation
export_columns=c(export_columns, names(train_data)[grep("(mean\\.\\.\\.|std\\.\\.\\.)", names(train_data))])

#combine the test and training data sets and only pick the columns we're interested in
merged_dataset = rbind(train_data[,export_columns], test_data[,export_columns])

#calculate the averages of each measurement per subject and activity
final_data=group_by(merged_dataset, subject, activity) %>% summarise_each(funs(mean))
write.table(final_data, "output.txt", row.name=FALSE)
