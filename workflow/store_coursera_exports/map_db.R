'
This script sends calls to the different databases for each course such that it can easily and conveniently retrieve data for the metrics.

Written by: Jasper Ginn (j.h.ginn@cdh.leidenuniv.nl)
Date: 16-03-2015
Last updated: 16-03-2015
'

rm(list=ls())
# Load RSQLite
require(RSQLite)
require(dplyr)

# Constructing convenient calls to the db
res <- dbSendQuery(db, "SELECT * 
                        FROM ID_MAP AS a, GRADEBOOK AS b 
                        WHERE a.coursera_user_id = b.coursera_user_id
                        AND a.in_signature_track = '1'")
res <- fetch(res)
dbDisconnect(db)
