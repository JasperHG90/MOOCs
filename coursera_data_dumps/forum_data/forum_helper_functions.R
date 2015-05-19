'
This script contains all the helper functions used on the forum data that Coursera supplied us with.

Written by: Jasper Ginn (j.h.ginn@cdh.leidenuniv.nl)
Date: 23-03-2015
'

# PREPROCESS FUNCTIONS --------

'
FUNCTION 1: Convenience function that converts Unix timestamps into date/time stamps
'
convertunixtm <- function(object) {
  return(as.POSIXct(as.numeric(as.character(object)),
             origin="1970-01-01",tz="GMT"))
  
}

'
FUNCTION 3: Strip all html tags from text (source: http://stackoverflow.com/questions/17227294/removing-html-tags-from-a-string-in-r)
'
removehtml <- function(string) {
  return(gsub("<.*?>", " ", string))
}

'
FUNCTION 4: Strip all URLs from a string and replace with ""
'

removeurl <- function(string) {
  return(gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", string))
}

'
FUNCTION 5: Remove common terms
'

removeCommonTerms <- function (x, pct) 
{
  stopifnot(inherits(x, c("DocumentTermMatrix", "TermDocumentMatrix")), 
            is.numeric(pct), pct > 0, pct < 1)
  m <- if (inherits(x, "DocumentTermMatrix")) 
    t(x)
  else x
  t <- table(m$i) < m$ncol * (pct)
  termIndex <- as.numeric(names(t[t]))
  if (inherits(x, "DocumentTermMatrix")) 
    x[, termIndex]
  else x[termIndex, ]
}

'
FUNCTION 6: Remove excess whitespace
'

removeExcessWS <- function(string) {
  temp <- gsub("   ", " ", string)
  temp <- gsub("  ", " ", temp)
  return(temp)
}

'
FUNCTION 7: Remove whitespace, punctuation & newlines / tabs
'

whiteSpaceFix <- function(x) {
  # Strip punctuation
  temp <- gsub("[[:punct:]]", "", x)
  # Take sentence apart
  temp <- unlist(strsplit(temp, " "))
  # Take out whitespaces
  temp <- temp[sapply(temp, function(b) b != "")]
  # Reconstruct and take out punctuation + newlines etc.
  checkF <- function(z) grepl("[[:punct:]]", z) | grepl("[\r\n\t]", temp)
  temp <- temp[!checkF(temp) == TRUE]
  # Paste
  paste0(temp, collapse = " ") 
}

'
FUNCTION 7: Remove leading whitespace
'
removeLeading <- function (x)  sub("^\\s+", "", x)

'
FUNCTION 8: Remove trailing whitespace
'
removeTrailing <- function (x) sub("\\s+$", "", x)

'
FUNCTION 9: Remove new lines
'
removeNewLine <- function(x) gsub("[\r\n]", " ", x)

'
FUNCTION 10: Remove tabs
'
removeTabs <- function(x) gsub("[\t]", " ", x)