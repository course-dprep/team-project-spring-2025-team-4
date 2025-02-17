# Install the dplyr package if not installed
install.packages("dplyr")

# Load the necessary libraries
library(readr)  # For reading .tsv files
library(R.utils)  # For extracting .gz files
library(dplyr)  # For data manipulation

# Base URL for downloading the datasets
base_url <- "https://datasets.imdbws.com/"

# List of dataset filenames to download
files <- c( "title.basics.tsv.gz", 
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

# Clean and transform specific columns in the "title.basics" dataset
datasets[["title.basics"]] <- datasets[["title.basics"]] %>%
  mutate(
    startYear = as.integer(ifelse(startYear == "\\N", NA, startYear)),  # Convert startYear to integer, replacing "\N" with NA
    endYear = as.integer(ifelse(endYear == "\\N", NA, endYear)),  # Convert endYear to integer, replacing "\N" with NA
    runtimeMinutes = as.integer(ifelse(runtimeMinutes == "\\N", NA, runtimeMinutes)),  # Convert runtimeMinutes to integer, replacing "\N" with NA
    isAdult = as.integer(isAdult)  # Convert isAdult to integer (0 or 1)
  )

# Clean and transform specific columns in the "title.ratings" dataset
datasets[["title.ratings"]] <- datasets[["title.ratings"]] %>%
  mutate(
    averageRating = as.numeric(ifelse(averageRating == "\\N", NA, averageRating)),  # Convert averageRating to numeric, replacing "\N" with NA
    numVotes = as.integer(ifelse(numVotes == "\\N", NA, numVotes))  # Convert numVotes to integer, replacing "\N" with NA
  )

# Check the updated structure of the datasets after transformations
str(datasets[["title.basics"]])
str(datasets[["title.ratings"]]) 

# Show the first few rows of each dataset
head(datasets[["title.basics"]])
head(datasets[["title.ratings"]])
