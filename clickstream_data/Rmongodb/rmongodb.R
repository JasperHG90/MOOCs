"
Basic script on how to work with rmongodb & mongo

written by: Jasper Ginn
Date: 13-05-2015
"

# prep -----

rm(list=ls())

# install/load packages (run line 14 twice if you need to install packages)
packages <- c("rmongodb", "jsonlite", "data.table")
for(package in packages) if(!require(package, character.only=TRUE)) install.packages(package)

# Create mongo connection to localhost
mongo <- mongo.create()
# Check
mongo
# Check if connected
mongo.is.connected(mongo)
# Get databases
if(mongo.is.connected(mongo) == TRUE) {
  mongo.get.databases(mongo)
}
# Get all collections
if(mongo.is.connected(mongo) == TRUE) {
  db <- "MOOCs"
  colls <- mongo.get.database.collections(mongo, db)
  if(length(colls) == 1) {
    coll <- colls
    print(coll)
  }
}

# Get one data frame
if(mongo.is.connected(mongo) == TRUE) {
  fr <- mongo.find.one(mongo, coll)
}
# Convert to list
fr <- mongo.bson.to.list(fr)
# Get one result where the value of the data == user video action
if(mongo.is.connected(mongo) == TRUE) {
  vid <- mongo.find.one(mongo, coll, '{"key":"user.video.lecture.action"}')
  mongo.bson.to.list(vid)
}
# Query many
query <- mongo.bson.from.list(list('key' = 'user.video.lecture.action'))
query
# Get unique values
if(mongo.is.connected(mongo) == TRUE) {
  urls <- mongo.distinct(mongo, coll, "page_url", query = list('key' = "user.video.lecture.action"))
}
# Find all observations of 1 video
if(mongo.is.connected(mongo) == TRUE) {
  res <- mongo.find.all(mongo, coll, query = list('key' = "user.video.lecture.action", 
                                               'page_url' = urls[1]))
}
# Create a cursor to skip through the data
if(mongo.is.connected(mongo) == TRUE) {
  cur <- mongo.find(mongo, coll, query = list('key' = "user.video.lecture.action", 
                                                  'page_url' = urls[1]))
  # Create a master list
  ml <- list()
  # Iterate through the data
  while (mongo.cursor.next(cur)) {
    # iterate through each and take only variables of interest
    tmp <- mongo.bson.to.list(mongo.cursor.value(cur))
    tmp <- list(id = tmp[1][[1]],
                  value = tmp$value,
                  username = tmp$username) 
    # Append
    ml <- append(ml, list(tmp))
  }
}
# Essentially, the 'value' field for each video is another JSON object that contains the metadata for the event. We can take those out like this:
ml.value <- lapply(ml, function(x){
  fromJSON(x$value)
})
# If we want the resulting list to be a dataframe, that can be done like so:
ml.value.df <- lapply(ml, function(x){
  # Turn JSON into list
  temp <- fromJSON(x$value)
  # Check if playbackrate is NULL. if so, then change to NA
  if(length(temp$playbackRate) == 0){
    temp$playbackRate <-- NA
  }
  # Take variables of interest and turn into df
  data.frame(currentTime = temp$currentTime,
             playbackRate = temp$playbackRate,
             eventTimestamp = temp$eventTimestamp,
             initTimestamp = temp$initTimestamp,
             type = temp$type,
             prevTime = temp$prevTime)
})
# We can now turn this list into a data frame like so:
ml.value.df <- rbindlist(ml.value.df)

# Close connection
mongo.destroy(mongo)
