"
Connecting to the database of IP adresses & country codes from within R.

Written by : Jasper Ginn
Affiliation : Online Learning Lab, Leiden Centre for Innovation, Leiden University
Date : 15-05-2015
Last modified : 15-05-2015
Please send suggestions/comments to : Jasperginn@cdh.leidenuniv.nl
"

# Clean wd
rm(list=ls())
# Path to database
dir <- "/users/jasper/desktop/IP_clickstream_metals-001.db"
# Libraries
require(RSQLite)
# Connect to db
db <- dbConnect(SQLite(), dir)
# List tables
dbListTables(db)
# Read table with IP adresses & country codes
temp <- dbReadTable(db, "IPandCC")
# Disconnect db
dbDisconnect(db)
