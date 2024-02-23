# Load necessary libraries
library(readr)
library(dplyr)

# Function to process the second file
process_second_file <- function(file_path) {
  # Read the CSV file starting from row 25 (header names are at row 25)
  data <- read_csv(file_path, skip = 24)

  # Process the data
  processed_data <- data %>%
    group_by(`Trial instance`) %>%
    summarise(
      mean_Fix_Index = mean(`Fixation Index by Stimulus`[`Fixation Index by Stimulus` != 0], na.rm = TRUE),
      mean_Fixation_Duration = mean(`Fixation Duration`[`Fixation Duration` != 0], na.rm = TRUE),
      mean_Saccade_Duration = mean(`Saccade Duration`[`Saccade Duration` != 0], na.rm = TRUE)
    )
  
  return(processed_data)
}


# Function to merge two files
merge_files <- function(file_path1, file_path2, output_file_path, key_data) {
  # Read and process files
  data1 <- read_csv(file_path1)
  data2 <- process_second_file(file_path2)

  # Merging the files based on the 'Trial' column in data1 and 'Trial instance' column in data2
  combined_data <- merge(data1, data2, by.x = "Trial", by.y = "Trial instance")

  # Next Step: Merge with Key Data
  # 'Trial' is the common column in combined_data and key_data
  final_combined_data <- merge(combined_data, key_data, by = "Trial", all.x = TRUE)
  
  # Save the merged data
  write_csv(final_combined_data, output_file_path)
}

# Usage of the function
# Replace with real paths
base_dir <- "/Users/melissacloutier/Library/CloudStorage/Box-
Box/DeLuciaLab/MelissaCloutier/TTCEM/Subject Data/"
imotions_dir <- file.path(base_dir, "imotions data folder")
output_dir <- file.path(base_dir, "Combined data analysis")

# Function to preprocess imotions file names
preprocess_imotions_files <- function(imotions_dir) {
  # List all entries in the directory
  imotions_files <- list.files(imotions_dir, full.names = TRUE)
  
  # Filter out sub-directories, keeping only files
  imotions_files <- imotions_files[!sapply(imotions_files, function(x) file.info(x)$isdir)]

  names_without_prefix <- sapply(imotions_files, function(x) {
    parts <- unlist(strsplit(basename(x), "_"))
    paste(parts[-1], collapse = "_")  # Remove the first three characters and the "_" sign
  })
  names(imotions_files) <- names_without_prefix  # Assign modified names as names of the list
  return(imotions_files)
}

# Automated merging for all subjects and trials
merge_all_files <- function(base_dir, imotions_dir, output_dir, key_data) {
  imotions_files <- preprocess_imotions_files(imotions_dir)
  
  for (subj_id in 1001:1051) {
    subj_dir <- file.path(base_dir, as.character(subj_id))
    if (!dir.exists(subj_dir)) next  # Skip if the folder doesn't exist
    
    for (trial_id in 1:4) {
      subj_file_name <- sprintf("Subj%d_TTC_AV%d_Data.csv", subj_id, trial_id)
      subj_file_path <- file.path(subj_dir, subj_file_name)
      
      if (!file.exists(subj_file_path)) next  # Skip if the file doesn't exist
      
      # Matching imotions file
      imotions_file_name <- gsub("Subj", "", subj_file_name)
      imotions_file_path <- imotions_files[[imotions_file_name]]
      
      if (!is.null(imotions_file_path)) {
        output_file_path <- file.path(output_dir, paste("combined", subj_file_name, sep = "_"))
        merge_files(subj_file_path, imotions_file_path, output_file_path, key_data)
      }
    }
  }
}

# Call to the function
key_file_path <- file.path(base_dir, "Key_to_trialnames_TTCEM.xlsx")
key_data <- read_excel(key_file_path)
merge_all_files(base_dir, imotions_dir, output_dir, key_data)
