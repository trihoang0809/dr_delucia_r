# Load necessary libraries
library(readr)
library(dplyr)
library(stringr)

# Define directories
subject_data_folder <- "path/to/SubjectDataFolder"
imotions_data_folder <- "path/to/imotions data folder"

# Function to get the corresponding imotion file name
get_imotion_filename <- function(subject_id) {
  pattern <- sprintf("^.{3}%s.*\\.csv$", subject_id)
  imotions_files <- list.files(path = imotions_data_folder, full.names = TRUE, pattern = pattern)
  if (length(imotions_files) > 0) {
    return(imotions_files[1])  # Return the first matched file
  } else {
    return(NULL)
  }
}

# Function to read and merge data from subject folder and imotion folder
process_files <- function(subject_id) {
  subject_file_path <- file.path(subject_data_folder, subject_id, paste0("Subj", subject_id, "_TTC_AV1_Data.csv"))
  imotion_file_path <- get_imotion_filename(subject_id)
  
  if (!is.null(imotion_file_path)) {
    subject_data <- read_csv(subject_file_path)
    imotion_data <- read_csv(imotion_file_path)
    
    # Replace 'common_column' with the actual column name for merging
    combined_data <- merge(subject_data, imotion_data, by = 'common_column')
    
    # Additional processing can be added here
  
    return(combined_data)
  } else {
    warning(sprintf("No matching imotion file found for subject %s", subject_id))
    return(NULL)
  }
}

# Main loop to process each subject folder
for (subject_id in 1001:1051) {
  combined_data <- process_files(as.character(subject_id))
  
  # Save or further process the combined data
  if (!is.null(combined_data)) {
    output_file_path <- file.path("path/to/output/folder", paste0(subject_id, "_combined.csv"))
    write.csv(combined_data, output_file_path, row.names = FALSE)
  }
}
