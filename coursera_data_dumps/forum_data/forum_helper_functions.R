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

'
This script contains the helper functions used to process the Coursera forum data.

Written by: Jasper Ginn (j.h.ginn@cdh.leidenuniv.nl)
Date: 23-03-2015
'

# PREPROCESS FUNCTIONS --------

'
FUNCTION 1: Convenience function that converts Unix timestamps into date/time stamps
  Parameters:
    object (integer)
      integer in an epoch time format to convert
'

convertunixtm <- function(object) {
  return(as.POSIXct(as.numeric(as.character(object)),
             origin="1970-01-01",tz="GMT"))
  
}

'
FUNCTION 3: Strip all html tags from text 
  parameters:
    string (string)
      Character from which to strip HTML 
'
removehtml <- function(string) {
  return(gsub("<.*?>", " ", string))
}

'
FUNCTION 4: Strip all URLs from a string and replace with ""
  paramters:
    string (string)
      Character from which to strip all URLs
'

removeurl <- function(string) {
  return(gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", string))
}

'
FUNCTION 5: Remove whitespace, punctuation & newlines / tabs
  parameters
    string (string)
      Character from which to strip excess whitespace (e.g. leading and trailing) and punctuation and 
      / or newlines & tabs etc.
'

whiteSpaceFix <- function(string) {
  # Strip punctuation
  temp <- gsub("[[:punct:]]", "", string)
  # Take sentence apart
  temp <- unlist(strsplit(temp, " "))
  # Control statement. If the result of the above is an empty character, then return NULL
  if(length(temp) == 0) {
    # Print message
    print("Empty character. Moving on . . . ")
    # Return empty character
    return("")
  } else{
    # Take out whitespaces
    temp <- temp[sapply(temp, function(b) b != "")]
    # Reconstruct and take out punctuation + newlines etc.
    checkF <- function(z) grepl("[[:punct:]]", z) | grepl("[\r\n\t]", temp)
    temp <- temp[!checkF(temp) == TRUE]
    # Paste & collapse
    paste0(temp, collapse = " ") 
  }
}
