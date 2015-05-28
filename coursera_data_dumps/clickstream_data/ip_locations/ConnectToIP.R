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
