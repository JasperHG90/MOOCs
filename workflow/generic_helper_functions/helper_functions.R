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
FUNCTION 2: Quick access to a sqlite OR mysql table.
  Parameters :
    - db.name (string) 
        Directory (including name and extension of db) 
    - table (string)
        Name of table to be extracted. Defaults to NULL
    - show.table (logical)
        Show tables in db?
    - db.type (string)
        Query from SQLite database or MySQL database?
    - ...
        Any other arguments needed to connect to a database. For example, username, password, host 
        name etc.
'

dbQA <- function(db.name, table = NULL, show.table = c(FALSE, TRUE), db.type = c("sqlite","mysql"), ...) {
  # Check if query is legal
  if(length(table) == 0 && show.table == FALSE){
    print("Please specify a table name to query.")
    return(NULL)
  }
  # Sqlite or mysql
  db.type <- match.arg(db.type)
  # if sqlite . . . 
  if(db.type == "sqlite") {
    # Connect
    db <- dbConnect(SQLite(), dbname = db.name, ...)
    # If table is true, return 
    if(show.table == TRUE){
      tabs <- dbListTables(db)
      dbDisconnect(db)
      return(tabs)
    } else{
      # Select table
      t <- dbReadTable(db, table)
      # Disconnect db
      dbDisconnect(db)
      # Return
      return(t)
    }
  } 
  if(db.type == "mysql") {
    # Connect to mySQL
    con = dbConnect(MySQL(), dbname = db.name, ...)
    # If table = TRUE, return:
    if(show.table == TRUE) {
      # Get tables
      tabs <- dbListTables(con)
      # Disconnect
      dbDisconnect(con)
      # Return
      return(tabs)
    } else{
      # Select table
      t <- dbReadTable(con, table)
      # Disconnect db
      dbDisconnect(con)
      # Return
      return(t)
    }
  }  
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