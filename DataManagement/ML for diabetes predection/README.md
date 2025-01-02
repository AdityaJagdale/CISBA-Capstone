##  Diabetes Prediction Project

This project explores the use of machine learning models to predict diabetes based on a publicly available dataset. The code provides a step-by-step approach to data loading, cleaning, pre-processing, model building, and evaluation.

### Dataset Source

The data used in this project is from the **"Diabetes Health Indicators Dataset"** available on Kaggle: [https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset)

### Getting Started

1. **Prerequisites:** Ensure you have R and required packages (`dplyr`, `rpart`, `rpart.plot`, `e1071`, `caret`, `nnet`, `NeuralNetTools`, `randomForest`) installed.

2. **Data:** Replace the placeholder `# Load required packages` section with the code to load your diabetes dataset (consider using the one from Kaggle mentioned above).

### Running the Script

1. Execute the script in your R environment.

2. The script performs the following steps:

   - Loads the data using `file.choose()`, providing a user-friendly interface for data selection.
   - Explores data structure and summarizes key information.
   - Cleans the data by handling pre-diabetic cases, recoding diabetes labels, and performing SMOTE for balanced classes.
   - Assesses features, including generating a correlation matrix.
   - Splits the data into training and testing sets.
   - Builds and evaluates five machine learning models:
      - Decision Tree
      - Naive Bayes
      - Logistic Regression
      - Neural Network
      - Random Forest
   - Prints performance metrics (accuracy, confusion matrix) for each model.


###  Note

- This is a basic framework. You can customize the feature engineering, model tuning (e.g., Random Forest hyperparameter tuning using `tuneRF`), and evaluation metrics based on your specific needs.
