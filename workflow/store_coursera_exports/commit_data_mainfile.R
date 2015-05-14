'
This script creates the calls to send folders with Coursera data to their respective databases

Written by : Jasper Ginn (j.h.ginn@cdh.leidenuniv.nl)
Date : 18-03-2015
'

# Prep work -----

# Load script with functions
source("/users/jasper/documents/github.projects/C4I/Database/database_script.R")
# Location with raw data folders
rawData <- "/users/jasper/documents/github.projects/C4I/Database/raw_data/"
# Folder names in the rawData folder will serve as db names
db.names <- list.files(dir_end(rawData))
# Add identifier
db.names <- paste0("coursera-export-", db.names)
# Get the paths to each folder (use dir_end to make sure the "/" is added at the end of string)
rawData <- dir_end(paste0(rawData,list.files(rawData)))
# Create path where databases are stored
db.loc <- "/users/jasper/documents/github.projects/C4I/Database/databases/"
# Create course names (same as Coursera). This will be added to the db as a reference point. Must match the same order as the db.names and the rawData variables.
course.names <- c("configuringworld-001", 
                  "configuringworld-002",
                  "globalorder-001",
                  "globalorder-002",
                  "introeulaw-001",
                  "metals-001",
                  "terrorism-001",
                  "terrorism-002",
                  "terrorism-003")

# Commit the contents of each folder to its own db ------

# For each folder, do . . .
for( i in 1:length(rawData) ) {
  
  # STAGE 1 -----
  
  # Commit gradebook & user_id_map 
  commit(paste0(rawData[i],'stage1/'), db.loc, db.names[i], course.names[i])
  
  # STAGE 2 -----
  
  # Get all folders names in the 'stage 2' folder
  s2 <- dir_end(paste0(rawData[i],"stage2"))
  folders <- dir_end(paste0(s2, list.files(s2)))
  # Commit all the .csv files in each folder
  lapply(folders, function(x){
    commitCSV(x, db.loc, db.names[i])
  })
}

