# Load the data using a more user-friendly approach
gp1 <- read.csv(file.choose(), header = TRUE, stringsAsFactors = TRUE)

# Explore the data structure and summarize key information
summary(gp1)
str(gp1)

# Check unique values for the target variable (Diabetes_012)
unique_diabetes <- unique(gp1$Diabetes_012)

# Preprocessing (Cleaning)

# 1.1. Handle pre-diabetic cases (value 1)
gp1C <- gp1[gp1$Diabetes_012 != 1, ]  # Filter directly, avoiding unnecessary assignment

# 1.2. Recode diabetes (0: No, 1: Yes)
gp1C$Diabetes_012 <- ifelse(gp1C$Diabetes_012 == 2, 1, 0)  # Vectorized replacement

# Verify changes
unique(gp1C$Diabetes_012)

## 1.3. SMOTE (Oversampling for balanced classes)

# Identify positive (diabetes) and negative (no diabetes) samples
pos <- gp1C[gp1C$Diabetes_012 == 1, ]
neg <- gp1C[gp1C$Diabetes_012 == 0, ]

# Sample desired sizes (consider using stratified sampling for better balance)
pos_7k <- sample_n(pos, 7000)
neg_3k <- sample_n(neg, 3000)

# Combine oversampled data
cleaned <- rbind(pos_7k, neg_3k)

# Randomly shuffle rows
cleaned <- cleaned[sample(nrow(cleaned)), ]

## 2. Feature Assessment

# Get column names
colnames(cleaned)

# Define formula for modeling (consider feature engineering if needed)
gcFormula <- Diabetes_012 ~ HighBP + HighChol + CholCheck + BMI + Smoker + Stroke + 
  HeartDiseaseorAttack + PhysActivity + Fruits + Veggies + HvyAlcoholConsump + 
  AnyHealthcare + NoDocbcCost + GenHlth + MentHlth + PhysHlth + DiffWalk + 
  Sex + Age + Education + Income

# Check for correlations (consider alternative methods for high-dimensional data)
if (!require("corrplot")) install.packages("corrplot")
library(corrplot)
corrplot(cor(cleaned, use = "pairwise.complete.obs"))  # Handle missing values appropriately

## 3. Splitting Data

# Set random seed for reproducibility
set.seed(123)

# Split data into training and testing sets (consider using caret package for more options)
library(dplyr)
split_index <- createDataPartition(index = seq_len(nrow(cleaned)), timeslice = 80, seed = 123)  # 80% for training
train <- cleaned[split_index,]
test <- cleaned[-split_index,]


# ------------------##### DO NOT EDIT ABOVE THIS LINE #####---------------------------------

# Load required packages
library(dplyr)  # For data manipulation
library(rpart)   # For decision trees
library(rpart.plot)  # For decision tree visualization
library(e1071)   # For Naive Bayes
library(caret)    # For confusion matrix and performance metrics
library(nnet)     # For neural networks
library(NeuralNetTools)  # For neural network visualization
library(randomForest)  # For random forests

# Preprocessing steps (assuming you have the cleaned data `cleaned`)
# ... (your previous data cleaning steps here)

# Split data into training and testing sets (80% for training)
set.seed(123)
train_index <- createDataPartition(index = seq_len(nrow(cleaned)), timeslice = 80, seed = 123)
train <- cleaned[train_index, ]
test <- cleaned[-train_index, ]

# Feature formula (assuming no feature engineering needed)
formula <- Diabetes_012 ~ HighBP + HighChol + CholCheck + BMI + Smoker + Stroke +
  HeartDiseaseorAttack + PhysActivity + Fruits + Veggies + HvyAlcoholConsump +
  AnyHealthcare + NoDocbcCost + GenHlth + MentHlth + PhysHlth + DiffWalk +
  Sex + Age + Education + Income

## Machine Learning Models

# 1. Decision Tree
# Train the model
dt_model <- rpart(formula, data = train, method = "class")

# Summarize the model
summary(dt_model)

# Visualize the decision tree
rpart.plot(dt_model)

# 1.1. Decision Tree Evaluation

# Predict on test data
dt_predicted <- predict(dt_model, test, type = "class")

# Create confusion matrix
dt_confusion_matrix <- table(dt_predicted, test$Diabetes_012)

# Calculate accuracy
dt_accuracy <- sum(diag(dt_confusion_matrix)) / sum(dt_confusion_matrix)

# Calculate precision, recall, and F1-score
dt_precision <- dt_confusion_matrix[2, 2] / sum(dt_confusion_matrix[, 2])
dt_recall <- dt_confusion_matrix[2, 2] / sum(dt_confusion_matrix[2, ])
dt_f1_score <- 2 * dt_precision * dt_recall / (dt_precision + dt_recall)

# Print evaluation metrics
cat("**Decision Tree Evaluation**\n")
cat("Accuracy:", dt_accuracy, "\n")
cat("Precision:", dt_precision, "\n")
cat("Recall:", dt_recall, "\n")
cat("F1-score:", dt_f1_score, "\n\n")


# 2. Naive Bayes
# Train the model
nb_model <- naiveBayes(formula = formula, data = train)

# View the model and conditional probabilities
nb_model

# Predict on test data
nb_predicted <- predict(nb_model, test)

# Create confusion matrix
nb_confusion_matrix <- table(as.factor(test$Diabetes_012), nb_predicted)

# Print the confusion matrix
print(confusionMatrix(nb_predicted, as.factor(test$Diabetes_012), mode = 'everything', positive = '1'))


# 3. Logistic Regression
# Train the model
log_model <- glm(formula, data = train, family = binomial)

# Summarize the model
summary(log_model)

# Make predictions on test data
log_predictions <- predict(log_model, newdata = test, type = "response")

# Convert predictions to class labels
log_predicted_classes <- ifelse(log_predictions > 0.5, 1, 0)

# Calculate accuracy
log_accuracy <- mean(log_predicted_classes == test$Diabetes_012)

# Create confusion matrix
log_confusion_matrix <- table(log_predicted_classes, test$Diabetes_012)

# Print evaluation metrics
cat("**Logistic Regression Evaluation**\n")
cat("Accuracy:", log_accuracy, "\n\n")
print(confusionMatrix(factor(log_predicted_classes), factor(test$Diabetes_012)))


# 4. Neural Network
# Train the model
nn_model <- nnet(formula = formula, data = train, size = 3, maxit = 10000)

# Summarize the model
summary(nn_model)

# Predict on test data
nn_predicted <- predict(nn_model, test, type = "response")

# Convert predictions to class labels
nn_predicted_classes <- ifelse(nn_predicted > 0.5, 1, 0)

# Create confusion matrix
nn_confusion_matrix <- table(as.factor(test$Diabetes_012), nn_predicted_classes)

# Print the confusion matrix
print(confusionMatrix(factor(nn_predicted_classes), factor(test$Diabetes_012), mode = 'everything', positive = '1'))

# 4.1 Neural Network Evaluation

# Calculate accuracy
nn_accuracy <- mean(nn_predicted_classes == test$Diabetes_012)

# Print evaluation metrics
cat("**Neural Network Evaluation**\n")
cat("Accuracy:", nn_accuracy, "\n\n")


# 5. Random Forest
# Model Tuning (optional, uncomment if needed)
# bestmtry <- tuneRF(train, train$Diabetes_012, stepFactor = 1.2, improve = 0.01, trace = TRUE, plot = TRUE)

# Train the model
rf_model <- randomForest(formula = formula, data = train, ntree = 100, importance = TRUE, nodesize = 2, minsplit = 4, mindiff = 0.01, cutoff = 0.1, allowPartial = TRUE, replace = TRUE, proximity = TRUE, seed = 123)

# Print model information
summary(rf_model)

# Get feature importance
rf_importance <- importance(rf_model)

# Plot feature importance (optional)
# varImpPlot(rf_model)

# Predict on test data
rf_predicted <- predict(rf_model, newdata = test, type = "class")

# Convert predictions to class labels
rf_predicted_classes <- as.factor(ifelse(rf_predicted > 0.5, 1, 0))

# Create confusion matrix
rf_confusion_matrix <- table(as.factor(test$Diabetes_012), rf_predicted_classes)

# Print the confusion matrix
print(confusionMatrix(factor(rf_predicted_classes), factor(test$Diabetes_012), mode = 'everything', positive = '1'))

# 5.1 Random Forest Evaluation

# Calculate accuracy
rf_accuracy <- mean(rf_predicted_classes == test$Diabetes_012)

# Print evaluation metrics
cat("**Random Forest Evaluation**\n")
cat("Accuracy:", rf_accuracy, "\n\n")
