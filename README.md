# Getting-and-Cleaning-Data Course Project

## Installation:
The "run_analysis.R" file must exist in the root directory where the data has been unzipped.

## Aim:
The goal of this code is to produce a summary of the mean values of all the measurements grouped by subject and by the activity performed by the subject. The result is expected to be a tidy data set with clear field names and values.

## run_analysis explanation:
Note: For information regarding the data from UCI see the README.txt within the unzipped data.

Activities are performed in the following order:
* Read activity labels
* Read feature labels
* Clean the feature lables off of the '(' and ')' chars as they become dots and are not clean looking.
<p><code>
head(featclean)
[1] "tBodyAcc-mean-X" "tBodyAcc-mean-Y" "tBodyAcc-mean-Z" "tBodyAcc-std-X"  "tBodyAcc-std-Y" 

[6] "tBodyAcc-std-Z" 
</code>
</p>
* From th clean feature names, create a Logical vector of true/falses indicating a match for 'mean' or 'std'.
* Using the above logical vector, create a column class vector with 'numeric' and 'NULL'. A table read with column class defined as NULL will ignore the field. This is good for efficiency as there are 561 columns and only about 1/5 we are interested in. And should reduce memory footprint.
* Use a plain numeric vector to first read the subject file from test folder
* Use the column class vector to read the test_x along with the setting the clean feature names list. This in a single operation will read in only the interesting data fields as well as name the fields with the clean feature names.




