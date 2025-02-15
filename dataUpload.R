# Carica le librerie necessarie
library(readr)
library(R.utils)

# URL di base per scaricare i dataset
base_url <- "https://datasets.imdbws.com/"

# Nomi dei file da scaricare
files <- c("name.basics.tsv.gz", "title.akas.tsv.gz", "title.basics.tsv.gz", 
           "title.crew.tsv.gz", "title.episode.tsv.gz", "title.principals.tsv.gz", 
           "title.ratings.tsv.gz")

# Directory temporanea per salvare i file
download_dir <- tempdir()

# Lista per salvare i dataset
datasets <- list()

# Funzione per scaricare, decomprimere e caricare i dati
for (file in files) {
  file_url <- paste0(base_url, file)
  file_path <- file.path(download_dir, file)
  extracted_file <- sub(".gz$", "", file_path)
  
  # Scarica il file
  download.file(file_url, file_path, mode = "wb")
  
  # Decomprimi il file
  gunzip(file_path, destname = extracted_file, remove = FALSE)
  
  # Carica il file in un data.frame
  dataset_name <- sub(".tsv.gz$", "", file)  # Nome senza estensione
  datasets[[dataset_name]] <- read_tsv(extracted_file, col_types = cols(.default = "c"))
}

# Ora i dataset sono caricati in R e accessibili con datasets[["nome_del_dataset"]]
# Esempio: datasets[["title.basics"]]