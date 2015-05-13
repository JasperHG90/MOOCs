'
This script contains all the general helper functions for the Coursera data. Specific helper functions for specific data are added to the project folder helper functions.

Written by: Jasper Ginn (j.h.ginn@cdh.leidenuniv.nl)
Date: 23-03-2015
'

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

'
FUNCTION 2: Quick access to a sqlite table.
  Parameters :
    - db.name (string) 
        Directory (including name and extension of db) 
    - table (string)
        Name of table to be extracted
'

dbQA <- function(db.name, table) {
  # Connect
  db <- dbConnect(SQLite(), dbname = db.name)
  # Select table
  t <- dbReadTable(db, table)
  # Disconnect db
  dbDisconnect(db)
  # Return
  return(t)
}

'
FUNCTION 3: Return a data frame with metadata to send to sqlite db
  Parameters :
    - date.created : string
        date at which table is created. Defaults to system date
    - owner : string
        Who initiated the database
    - Position : string
        job title
    - Organization : string
        which organization?
    - email : string
        email address
    - for.u : string
        for whom was the database created?
    - reason : string
        why was the database created
    - uniqueID : string
        unique ID of the database
'

provdf <- function( date.created = as.character(Sys.Date()),
                    owner = "Jasper Ginn",
                    position = "Data Analyst & Data Visualization Expert",
                    organization = "Online Learning Lab (OLL), CFI",
                    email = "j.h.ginn@cdh.leidenuniv.nl",
                    for.u = "own use",
                    reason,
                    uniqueID) {
  # Add a table with metadata
  t <- data.frame( info = c("Date created",
                            "Owner",
                            "Position",
                            "Organization",
                            "Email",
                            "for.u",
                            "Reason",
                            "uniqueID"),
                   data = c(date.created,
                            owner,
                            position,
                            organization,
                            email,
                            for.u,
                            reason,
                            uniqueID))
}