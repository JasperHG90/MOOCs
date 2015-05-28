'
Copyright (C) 2015  Leiden University

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [http://www.gnu.org/licenses/].
'

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

mongoMeta <- function(return.type = c("tables", "collections"), table = NULL, ...) {
  # match arguments
  return.type <- match.arg(return.type)
  # Check if statement is illegal
  if(!return.type %in% c("tables", "collections")){
    print("Please specify return.type to be either 'tables' or 'collections'")
    return(NULL)
  }
  # Create mongo connection to localhost
  mongo <- mongo.create(...)
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

QueryuserActions <- function(collection, url, return.type = c("list", "data.frame"), include.username = c(FALSE,TRUE), ...) {
  # Match arguments
  return.type <- match.arg(return.type)
  # Check if statement is illegal
  if(!return.type %in% c("list", "data.frame")){
    print("Please specify return.type to be either a 'list' or a 'data.frame'")
    return(NULL)
  }
  # Create mongo connection to localhost
  mongo <- mongo.create(...)
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
FUNCTION 3: Function to convert the time at which actions occur. Returns a character in the format 'Hours:Minutes:Seconds'
  Parameters:
    number.seconds (numeric)
      Number of seconds given by either the 'currentTime' or the 'prevTime' variable
"

# Function to convert video time
vidTime <- function(number.seconds) {
  # Calculate seconds
  seconds <- round(number.seconds %% 60, digits=0)
  # Calculate minutes
  minutes <- ((number.seconds - (number.seconds %% 60)) / 60)
  # If < 10, add extra 0 . . . 
  if ( minutes < 10 ) {
    minutes <- paste0("0",minutes)
  } 
  if ( seconds < 10 ) {
    seconds <- paste0("0", seconds)
  }
  # Return
  time <- paste0("00:", minutes, ":", seconds)
  return(time)
}