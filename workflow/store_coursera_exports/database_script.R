'
Creating a semi-automated workflow to dump the individual .csv files from Coursera courses into a SQLite database.

Written by: Jasper Ginn
Date : 13-03-2015
Last modified : 17-03-2015
'

# Clean wd
rm(list=ls())
# Load libraries
require(dplyr)
require(RSQLite)

# HELPER FUNCTIONS -----

'
FUNCTION 1: Check if a given path ends with "/". If it does not, add it!
  Parameters :
    - directory (string)
        Directory to check
'

dir_end <- function(directory) {
  # If directory ends with "/" then return original, otherwise add '/'
  direct <- ifelse(substring(directory, 
                             nchar(directory)) == "/", 
                   directory, 
                   paste0(directory,"/"))
  return(direct)
}

# Sample use : dir_end("/users/jasper/documents/github.projects/C4I/projects/Bakker_Terrorism_Installment3/data/stage1")

'
FUNCTION 2: Map the data directory to R. Returns a named list with directories narrowed down by type.
  Parameters : 
    directory (string)
      directory with csv files to map
    folder.structure (string)
      does the directory folder contain folder(s) with file(s)? If yes, choose "MULTIPLE", else "SINGLE".
'

map_files <- function(directory, folder.structure = c("SINGLE", "MULTIPLE")) {
  # Show the top-level folder structure
  folder_mappings <- list.files(directory)
  # Create mappings to the different folders
  fold_mappings <- paste0(directory, folder_mappings)
  # Match argument (no annoying message)
  folder.structure <- match.arg(folder.structure)
  # If singular path, then return the paths straight away, otherwise, look into folders
  if(folder.structure == "SINGLE"){
    files <- paste0(directory, list.files(directory))
    # Return
    return(files)
  } else{
    # For each folder, get a mapping to individual files
    files <- unlist(lapply(fold_mappings, function(x){
      paste0(x, "/", list.files(x))
    }))
    # Return
    return(files)
  }
}

# Sample use : t <- map_files(directory, "SINGLE")

'
FUNCTION 3: Construct SQL header argument (DEPRECEATED) (but useful for later?)
'

SQL_headers <- function(column.names, type, table.name){
  # Replace all the punctuation with underscores
  column.names <- unlist(lapply(column.names, function(x){
    gsub("[[:punct:]]", "_", x)
  }))
  # Create call
  joined.names <- paste(c("CREATE TABLE ", table.name, " (",
                          paste0(column.names[1:(length(column.names)-1)], 
                                 " ", 
                                 type[1:(length(type)-1)], 
                                 ","),
                          paste0(column.names[length(column.names)], 
                                 " ", 
                                 type[length(type)]),
                          ")"), 
                        collapse = "")
  # Return
  return(joined.names)
}

# Sample usage : t <- SQL_headers(colnames(gradebook), "TEXT", "test")

'
FUNCTION 4: Dealing with empty folders
'

empty_ret <- function(directory) {
  # Check if "/" at end of file
  directory <- dir_end(directory)
  # list files
  resp <- list.files(directory)
  # Check length (if 0, then directory is empty)
  if(length(resp) == 0) {
    return("EMPTY")
  } else{
    return("FILE.FOUND")
  }
}

# Sample usage : empty_ret("/users/jasper/documents/github.projects/C4I/database/raw_data/terrorism_bakker_installment1/stage1/Gradebook/")

# MAIN FUNCTIONS -------

'
FUNCTION 1: The Gradebook and the MAP_ID are different in the way they should be sent to the SQLite db. 
  parameters
    directory (string)
      directory where the files are located. If you store the files in one single directory, you should change the map_files function below to "SINGLE"
    db.directory (string)
      directory where you want to store the db
    db.name (string)
      name of the database
'

#directory <- folders[1]
#db.directory <- db.loc
#db.name <- db.names[1]

commit <- function(directory, db.directory, db.name, course.name){
  # Check 
  directory <- dir_end(directory)
  # Map files
  data <- map_files(directory, "MULTIPLE")
  # Load data
  data <- lapply(data, function(x){
    read.csv(x, header=T, sep=",")
  })
  # Load gradebook
  gradebook <- data.frame(data[1])
  # Load user_id_map
  user_id <- data.frame(data[2])
  # Merge
  temp <- merge(gradebook, user_id, by="coursera_user_id")
  # replace user_id with added signature track identifier
  vars <- c("coursera_user_id","session_user_id.x","forum_user_id","In.Signature.Track")
  user_id <- temp[,vars]
  # Take out signature track from gradebook
  gradebook <- gradebook[,-length(colnames(gradebook))]
  # Colnames
  colnames(user_id) <- c("coursera_user_id","session_user_id","forum_user_id","in_signature_track")
  # Construct SQL headers
  idMap <- "CREATE TABLE ID_MAP
            (coursera_user_id INTEGER PRIMARY KEY,
            session_user_id TEXT,
            forum_user_id TEXT,
            in_signature_track INTEGER)"
  # Commit to db
  db <- dbConnect(SQLite(), 
            dbname = paste0(dir_end(db.directory),db.name,".sqlite"))
  # Map
  dbSendQuery(conn = db, idMap)
  # Append table
  dbWriteTable(conn = db,
               name = "ID_MAP",
               value = user_id,
               append=TRUE,
               row.names=F
  )
  # Create gradebook SQL headers
  types <- SQL_headers(colnames(gradebook), "TEXT", "GRADEBOOK")
  # Commit to db
  dbSendQuery(conn = db, types)
  # Append table
  dbWriteTable(conn = db,
               name = "GRADEBOOK",
               value = gradebook,
               append = TRUE,
               row.names=F)
  # Create table with meta-information
  # Add provenance measure
  version <- "v001.20032015"
  compiled.by <- "jasper ginn (j.h.ginn@cdh.leidenuniv.nl)"
  # Create table
  meta <- data.frame(c("Course Name", "Version", "Compiled By"),c(course.name, version,compiled.by))
  names(meta) <- c("Var", "Value")
  # Append table
  dbWriteTable(conn = db,
               name = "META",
               value = meta,
               append = F,
               row.names=F)
  # Disconnect db
  dbDisconnect(db)
}

# Sample usage :  commit('/users/jasper/documents/github.projects/C4I/projects/Bakker_Terrorism_Installment3/data/stage1/', "/users/jasper/documents/github.projects/C4I/database", "bakker_terrorism_installment3")

'
FUNCTION 2: commit all csv files in a particular folder to the database
  parameters
    directory (string)
      directory where the files are located. If you store the files in one single directory, you should change the map_files function below to "SINGLE"
    db.directory (string)
      directory where you want to store the db
    db.name (string)
      name of the database
'

commitCSV <- function(directory, db.directory, db.name) {
  # Check 
  directory <- dir_end(directory)
  # Check if directory is empty
  check <- empty_ret(directory)
  # If directory is empty, break. Else continue
  if(check == "EMPTY") {
    print("Directory is empty. Please check and try again. If problem persists, then this function is probably broken.")
    return("")
  } 
  # Map files
  data <- map_files(directory, "SINGLE")
  # Load data
  for(i in 1:length(data)) {
    # split filepath
    split <- unlist(strsplit(data[i], "/"))
    # Grep csv
    file.name <- split[grep(".csv", split)]
    # remove the ".csv"
    file.name <- gsub(".csv", "", file.name)
    # Load data 
    assign(file.name,read.csv(data[i],header=TRUE,sep=","))
    # Send to db
    db <- dbConnect(SQLite(), 
                    dbname = paste0(dir_end(db.directory),db.name,".sqlite"))
    # Write table
    dbWriteTable(conn = db,
                 name = file.name,
                 value = eval(parse(text=file.name)),
                 append=TRUE,
                 row.names=F)
    # Disconnect
    dbDisconnect(db)
    # Rm from wd
    rm(list=ls(pattern=file.name))
  }
}

# Sample usage :  commitCSV('/users/jasper/documents/github.projects/C4I/projects/Bakker_Terrorism_Installment3/data/stage1/', "/users/jasper/documents/github.projects/C4I/database", "bakker_terrorism_installment3")