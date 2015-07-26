### Introduction
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.


### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

### Transformations and Processing

#### Download and unzip the file

The files are first acquired by downloading a zip and extracting it

```
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "rawdata.zip", method="curl")
unzip("rawdata.zip")
```

#### Extracting data common to testing and training

`activity_labels.txt` contains a mapping of activity_id to activity_name.  This file is loaded as a dataframe
`features.txt` contains the list of features.  This dataset will be used later to assign meaningful column names.

```
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", sep=" ", col.names=c("id", "activity_label"), colClasses=c("numeric", "character"), header=FALSE)
features = read.table("UCI HAR Dataset/features.txt", col.names=c("id", "feature"), colClasses=c("numeric", "character"), header=FALSE)
```

#### Read the meat of the data
The test and train data sets are each independently loaded and massaged to a uniform format.  Since this is common functionality it could be a future improvement to abstract this logic to a function

The raw data gets loaded in to dataframes.  Note that test_data is loaded with column names from features.txt
```
test_labels = read.table("UCI HAR Dataset/test/y_test.txt", sep=" ", col.names=c("activity_id"), colClasses=c("numeric"), header=FALSE)
test_subjects = read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject_id"), colClasses=c("numeric"), header=FALSE)
test_data = read.table("UCI HAR Dataset/test/X_test.txt", col.names=features$feature, header=FALSE)
```

The activity column gets added to test_data by joining activity_labels and test_labels on activity_id

```
test_data$activity<-merge(activity_labels, test_labels, by.x="id", by.y="activity_id")$activity_label
```

The subject colum gets added to test_data.  

```
test_data$subject<-test_subjects$subject_id
```

The raw data gets loaded in to dataframes.  Note that train_data is loaded with column names from features.txt

```
train_labels = read.table("UCI HAR Dataset/train/y_train.txt", sep=" ", col.names=c("activity_id"), colClasses=c("numeric"), header=FALSE)
train_subjects = read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject_id"), colClasses=c("numeric"), header=FALSE)
train_data = read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$feature, header=FALSE)
```

The activity column gets added to test_data by joining activity_labels and test_labels on activity_id

```
train_data$activity<-merge(activity_labels, train_labels, by.x="id", by.y="activity_id")$activity_label
```

The subject colum gets added to test_data.  

```
train_data$subject<-train_subjects$subject_id
```

#### Pick which columns to export

```
export_columns=c("activity", "subject")
export_columns=c(export_columns, names(train_data)[grep("(mean\\.\\.\\.|std\\.\\.\\.)", names(train_data))])
```

#### Merge the test and training datasets

Note that only the desired columns are being selected

```
merged_dataset = rbind(train_data[,export_columns], test_data[,export_columns])
```

#### Calculate the averages of each measurement per subject and activity

```
final_data=group_by(merged_dataset, subject, activity) %>% summarise_each(funs(mean))
```
