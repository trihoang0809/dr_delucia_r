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
merge_files <- function(file_path1, file_path2, output_file_path) {
  # Read and process files
  data1 <- read_csv(file_path1)
  data2 <- process_second_file(file_path2)

  # Merging the files based on the 'Trial' column in data1 and 'Trial instance' column in data2
  combined_data <- merge(data1, data2, by.x = "Trial", by.y = "Trial instance")

  # Save the merged data
  write_csv(combined_data, output_file_path)
}

# Usage of the function
file_path1 <- "/Users/trihoang/Downloads/Subj1038_TTC_AV1_Data.csv"
file_path2 <- "/Users/trihoang/Downloads/021_1038TTCAV1.csv"
output_file_path <- "/Users/trihoang/Downloads/combined_data_test.csv"

# Call the function with the file paths
merge_files(file_path1, file_path2, output_file_path)
