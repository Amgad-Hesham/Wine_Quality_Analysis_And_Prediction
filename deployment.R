predict_quality <- function(data_path, preproc_path, model_path) {
  # 1- Load the dataset
  new_data <- read.csv(data_path, header = TRUE, sep = ";")
  
  # 2- remove quality column if it exists
  if("quality" %in% colnames(new_data)){
    new_data$quality <- NULL  
  }
  # 3- Apply preprocessig (scaling)
  preProcessingValues <- readRDS(preproc_path)
  new_data_scaled <- predict(preProcessingValues, new_data)
  new_data_scaled <- as.data.frame(new_data_scaled)
  
  # 4- predict the quality using the saved model
  svm_model <- readRDS(model_path)
  predictions <- predict(svm_model, newdata = new_data_scaled)
  integer_predictions <- round(predictions)
  
  # 5- Add predictions as a new 'quality' column
  new_data_scaled$quality <- integer_predictions
  
  # Return the new dataset with predictions
  return(new_data_scaled)
}

# Example usage:
# put ur own data path for prediction
data_path <- "Data/wine+quality/winequality-white.csv"
preproc_path <- "preprocessing/preProcessingValues.rds"
model_path <- "models/svm_model.rds"
predicted_data <- predict_quality(data_path, preproc_path, model_path)
predicted_data
