# Install the dplyr package if not installed
install.packages("dplyr")

# Load the necessary libraries
library(readr)  # For reading .tsv files
library(R.utils)  # For extracting .gz files
library(dplyr)  # For data manipulation

# Base URL for downloading the datasets
base_url <- "https://datasets.imdbws.com/"

# List of dataset filenames to download
files <- c("name.basics.tsv.gz", "title.akas.tsv.gz", "title.basics.tsv.gz", 
           "title.crew.tsv.gz", "title.episode.tsv.gz", "title.principals.tsv.gz", 
           "title.ratings.tsv.gz")

# Temporary directory to store downloaded files
download_dir <- tempdir()

# List to store the loaded datasets
datasets <- list()

# Loop to download, extract, and load each dataset
for (file in files) {
  file_url <- paste0(base_url, file)  # Create the full URL
  file_path <- file.path(download_dir, file)  # Define the local path for the file
  extracted_file <- sub(".gz$", "", file_path)  # Define the extracted file name
  
  # Download the compressed file
  download.file(file_url, file_path, mode = "wb")
  
  # Extract the .gz file
  gunzip(file_path, destname = extracted_file, remove = FALSE)
  
  # Load the dataset into a data frame
  dataset_name <- sub(".tsv.gz$", "", file)  # Extract dataset name without extensions
  datasets[[dataset_name]] <- read_tsv(extracted_file, col_types = cols(.default = "c"))
}

# Now, datasets are loaded into R and can be accessed using datasets[["dataset_name"]]
# Example: datasets[["title.basics"]]

# List all extracted .tsv files in the temporary directory
list.files(download_dir, pattern = "*.tsv")

# Check the names of the loaded datasets
names(datasets)

# Show the full paths of all extracted .tsv files
list.files(download_dir, pattern = "*.tsv", full.names = TRUE)

# Display the structure of the "title.basics" dataset
str(datasets[["title.basics"]])

# Show the first few rows of the "title.basics" dataset
head(datasets[["title.basics"]])

# Clean and transform specific columns in the "title.basics" dataset
datasets[["title.basics"]] <- datasets[["title.basics"]] %>%
  mutate(
    startYear = as.integer(ifelse(startYear == "\\N", NA, startYear)),  # Convert startYear to integer, replacing "\N" with NA
    endYear = as.integer(ifelse(endYear == "\\N", NA, endYear)),  # Convert endYear to integer, replacing "\N" with NA
    runtimeMinutes = as.integer(ifelse(runtimeMinutes == "\\N", NA, runtimeMinutes)),  # Convert runtimeMinutes to integer, replacing "\N" with NA
    isAdult = as.integer(isAdult)  # Convert isAdult to integer (0 or 1)
  )

# Check the updated structure of the "title.basics" dataset after transformations
str(datasets[["title.basics"]])

