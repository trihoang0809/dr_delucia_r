# Load necessary libraries
library(readr)
library(dplyr)

# Function to process the second file
process_second_file <- function(file_path) {
  data <- read_csv(file_path)

  # Assuming 'AM' is the trial number, 'R', 'W', and 'AC' are the columns to process
  processed_data <- data %>%
    group_by(AM) %>%
    summarise(
      mean_Fix_Index = mean(R[R != 0], na.rm = TRUE),
      mean_Fixation_Duration = mean(W[W != 0], na.rm = TRUE),
      mean_Saccade_Duration = mean(AC[AC != 0], na.rm = TRUE)
    )
  
  return(processed_data)
}

# Function to merge two files
merge_files <- function(file_path1, file_path2, output_file_path) {
  # Read and process files
  data1 <- read_csv(file_path1)
  data2 <- process_second_file(file_path2)

  # Merging the files
  combined_data <- merge(data1, data2, by = "AM") # Replace "AM" with the common column to merge on

  # Save the merged data
  write_csv(combined_data, output_file_path)
}

# Usage of the function
file_path1 <- "/Users/th52/Box/DeLuciaLab/Undergraduate RAs/Tri H/Subject Data"
file_path2 <- "/Users/th52/Box/DeLuciaLab/Undergraduate RAs/Tri H/Subject Data/imotions data folder"
output_file_path <- "/Users/th52/Box/DeLuciaLab/Undergraduate RAs/Tri H/Subject Data/Combined data analysis/"

# Call the function with the file paths
merge_files(file_path1, file_path2, output_file_path)
