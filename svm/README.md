# Support Vector Machines
This project implements an SVM model to predict diabetes using the `diabetes.csv` dataset. It includes data preprocessing, standardization, model tuning and grid search.
## Dataset
The original dataset has 768 rows or samples and 9 columns including 8 features and 1 outcome. The target variable is an int variable indicating the result with 0 and 1.
## Preprocessing
For dealing with `Null` values in this dataset we use `KNNImputer` from the `sklearn` library. It fills out the missing values using the nearest or closest rows. We add two separate columns to the dataset which indicate which rows have null values for the columns `SkinThickness` and `BMI`. Then for dealing with outliers we remove them using Tukey’s 1.5×IQR rule by calculating first and third Quartiles. At the end we standardize the data so each feature contributes the same to the model.
## Model
This project implements and trains an SVM model for classification with different kernels. At the end with grid search we find the best combination between the two hyperparameters C and the kernel model.
## Results
The accuracy scores for the SVM models with different kernels are printed and for this dataset the accuracy score with a linear kernel is the highest. At the end we find the best combination for hyperparameters with $C = 0.1$ and kernel = `linear` which results in a test accuracy of 0.81.
## How to run
Simply run all the cells inside the notebook in order.

