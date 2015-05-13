"
This script contains helper functions to work with Coursera clickstream data. Basically, these are wrapper functions that make constructing calls to the mongo database simpler. NOTE: I created these functions mainly for my own use. They are not likely to be the most efficient. If you can improve on them, please share with the rest!

Written by: Jasper Ginn (Leiden University)
Date: 13-05-2015
"

"
FUNCTION 1: Queries a mongodb instance and either returns tables within the database or returns the collections within a table
  Parameters:
    return.type (string)
      Return the tables in the mongodb using 'tables' option. Return the collections in a table using the 'collections' option
    table (string)
      Table name for which you want to query the collections. Only necessary if you want to query collections in a table. 
"

mongoMeta <- function(return.type = c("tables", "collections"), table = NULL) {
  # match arguments
  return.type <- match.arg(return.type)
  # Check if statement is illegal
  if(!return.type %in% c("tables", "collections")){
    print("Please specify return.type to be either 'tables' or 'collections'")
    return(NULL)
  }
  # Create mongo connection to localhost
  mongo <- mongo.create()
  # Query
  if(return.type == "tables") {
    # Get databases
    if(mongo.is.connected(mongo) == TRUE) {
      tabs <- mongo.get.databases(mongo)
      # Destroy mongo connection
      mongo.destroy(mongo)
      return(tabs)
    } else{
      print("Cannot connect to mongo database. Please consult rmongodb documentation")
      return(NULL)
    }
  } else{
    if(length(table) == 0) {
      print("Please select a table for which you want to see the collections")
      return(NULL)
    } else{
      if(mongo.is.connected(mongo) == TRUE) {
        colls <- mongo.get.database.collections(mongo, table)
        # Destroy mongo connection
        mongo.destroy(mongo)
        if(length(colls) >= 1) {
          return(colls)
        } else{
          print("There are no collections present in the table you selected. Please double-check whether you selected the correct table")
          return(NULL)
        }
      }
    }
  }
}

"
FUNCTION 2: For a given video URL, return the user actions
  Parameters: 
    collection (string)
      specify which collection you from which you want to query
    url (string)
      url of a video for which you want the clickstream actions
    return.type (string)
      specify whether you would like the function to return a data frame or a list. Defaults to 'list'
    include.username (logical)
      specify whether you want the user session IDs to be included for each action. Defaults to FALSE
"

QueryuserActions <- function(collection, url, return.type = c("list", "data.frame"), include.username = c(FALSE,TRUE)) {
  # Match arguments
  return.type <- match.arg(return.type)
  # Check if statement is illegal
  if(!return.type %in% c("list", "data.frame")){
    print("Please specify return.type to be either a 'list' or a 'data.frame'")
    return(NULL)
  }
  # Create mongo connection to localhost
  mongo <- mongo.create()
  # Create cursor
  if(mongo.is.connected(mongo) == TRUE) {
    # Create a cursor for the query
    cur <- mongo.find(mongo, collection, query = list('key' = "user.video.lecture.action", 
                                                          'page_url' = url))
  } else{
    print("Cannot connect to mongo database. Please consult rmongodb documentation")
    return(NULL)
  }
  # Master list
  ml <- list()
  # Iterate through the data
  while (mongo.cursor.next(cur)) {
    # iterate through each and take only variables of interest
    temp <- mongo.bson.to.list(mongo.cursor.value(cur))
    # Include username (if specified)
    if(include.username == TRUE){
      us <- temp$username
      # Convert value field to JSON format
      temp <- fromJSON(temp$value)
      # Add username
      temp$username <- us
    } else{
      # Convert value field to JSON format
      temp <- fromJSON(temp$value)
    }
    # Check if playbackrate, networkState & readyState are NULL. if so, then change to NA
    if(length(temp$playbackRate) == 0){
      temp$playbackRate <-- NA
    }
    if(length(temp$networkState) == 0){
      temp$networkState <-- NA
    }
    if(length(temp$readyState) == 0){
      temp$readyState <-- NA
    }
    # Change Error value. 0 if no error occurred, 1 if error occurred
    if(length(temp$error) == 0){
      temp$error <- "0"
    } else{
      temp$error <- "1"
    }
    # Add to list
    ml <- append(ml, list(temp))
  }
  # Destroy connection
  mongo.destroy(mongo)
  # Return list or dataframe
  if(return.type == "list"){
    return(ml)
  } else{
    return(rbindlist(ml))
  }
}

"
FUNCTION 3: Function to convert the time at which actions occur. NOTE: this is a temporary function, it isn't completely accurate due to the rounding of minutes & seconds. Returns a character in the format 'Hours:Minutes:Seconds'
  Parameters:
    ob (numeric)
      Number of seconds given by either the 'currentTime' or the 'prevTime' variable
"

# Function to convert video time
vidTime <- function(ob) {
  # If the number is 0, then the result is zero as well
  if(ob == 0) {
    tm.f <- format(strptime("2015-03-26 00:00:00", format="%Y-%m-%d %H:%M:%S"), 
                   "%H:%M:%S")
    return(tm.f)
  }
  # Ok, let's convert to seconds and minutes! divide by 60
  min <- round(ob/60, digits = 0)
  # Function to convert seconds
  secondConvert <- function(number) {
    # Convert to character
    r <- as.character(round(number, digits=2))
    # Split
    rb <- strsplit(r, ".", fixed=TRUE)
    # Take seconds
    rb <- as.numeric(rb[[1]][2])
    # Convert
    rb <- (rb / 100) * 60
    # Return
    return(round(rb, digits=0))
  }
  # Convert second
  sec <- secondConvert(ob)
  # If NA, return NA
  statement <- sec < 10
  if(is.na(statement)){
    return(NA)
  }
  # If length is 1, add a zero
  if(sec < 10){
    tm <- paste0(as.character(min),":0",as.character(sec))
  } else{
    tm <- paste0(as.character(min),":",as.character(sec))
  }
  # Create time object
  tm.f <- format(strptime(paste0('2015-01-01 00:',tm), format="%Y-%m-%d %H:%M:%S"), 
                 format="%H:%M:%S")
  # Return
  return(tm.f)
}
