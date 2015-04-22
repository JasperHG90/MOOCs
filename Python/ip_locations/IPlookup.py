'''
This script looks up the IP address information for MOOC users
Written by : Jasper Ginn
Date : 23-03-2015
Last modified : 23-03-2015
Please send suggestions/comments to : Jasperginn@cdh.leidenuniv.nl
'''

# --------------------------------------------------------------------------------

'''
Import modules
'''

# Import IPwhois
from ipwhois import IPWhois
# Import SQLite
import sqlite3 as lite

'''
+++ MAIN FUNCTIONS +++
'''

# Connect to db
# Get all IP addresses in a list
# Look up for list
# Run thorugh IP whois
# Take outcome dictionaries and store as list
# Commit to db


'''
+++ HELPER FUNCTIONS +++
'''

'''
FUNCTION 10 : Helper function that creates the path for the database. It evaluates whether the path specified by the user ends with
'/'. If yes, then paste. If no, then add the '/' to avoid problems.
    parameters :
        dbname : string
            name of the database
        path : string
            system path where the database is stored. Defaults to '~/desktop'
'''

def pathMaker(dbname, path):
    if path.endswith('/'):
        return(path + dbname + '.db')
    else:
        return(path + '/' + dbname + '.db')

'''
FUNCTION 5 : Insert results form each page to the database
    Parameters :
        values_list : list 
            list of values to send to the database
        dbname      : string
            name of the database
        tablename   : string
            name of the table in which to store results
        path        : string
            path to the database. Defaults to '/home/vagrant/Documents/'
'''

def dbInsert(values_list, dbname, tablename , path = '~/desktop/'):
	# Path to db
    pathfile = pathMaker(dbname, path)
    # Try connecting and inserting
    try:
        con = lite.connect(pathfile) 
        with con:  
            # Cursor file
            cur = con.cursor()
            # Write values to db
            cur.executemany("INSERT INTO {} (URL, Date, Location, Longitude, Latitude, Title, Report, Verified, Category, Time , Scrapedate) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);".format(tablename), values_list)
            # Commit (i.e. save) changes
            con.commit()
        # Close connection
        con.close()           
    except:
        print 'Error while setting up the database. Quitting the script now . . . '

'''
+++ RUN +++
'''