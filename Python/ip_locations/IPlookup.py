
# coding: utf-8

# In[93]:

'''
This script looks up the IP address information for MOOC users
Written by : Jasper Ginn
Date : 23-03-2015
Last modified : 24-03-2015
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


# In[118]:

'''
+++ MAIN FUNCTION +++
'''

def mainFunction(dbname, dbpath, tablename_o, tablename_n, override = "TRUE"):
    # Setup database
    dbSetup(dbname, tablename_n, path = dbpath, override = override)
    # Get IP addresses
    q = getIPs(dbname, dbpath, tablename_o)
    # For each IP, get country code
    for IP in q:
        # Check if there is more than 1 IP address
        iplen = len(IP.split(','))
        # If longer than 1, then we have more IP addresses
        if iplen > 1:
            # For every IP, do . . .
            for ipobs in IP.split(','):
                # Replace whitespace
                ipobs = ipobs.replace(" ", "")
                # Check if already in db
                res = dbCheck(ipobs, dbname, tablename_n, dbpath)
                if res != None and override == "FALSE":
                    continue
                else:
                    try:
                        # Look up
                        vals = [ ( ipobs, IPtoCC(ipobs) ) ]
                        # Insert into database
                        dbInsert(vals, dbname, tablename_n , path = dbpath)
                    except: # IPdefinedError
                        print('There was an error . . . moving on')
        else:
            # Check if already in db
            res = dbCheck(IP, dbname, tablename_n, dbpath)
            if res != None and override == "FALSE":
                continue
            else:
                try:
                    # Look up
                    vals = [ ( IP, IPtoCC(IP) ) ]
                    # Insert into database
                    dbInsert(vals, dbname, tablename_n , path = dbpath)
                except: # IPdefinedError
                    print('There was an error . . . moving on')


# In[111]:

'''
+++ HELPER FUNCTIONS +++
'''

'''
FUNCTION 1 : Helper function that creates the path for the database. It evaluates whether the path specified by the user ends with
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
FUNCTION 2 : Helper function that retrieves all the IP addresses from the database, stores them in a list. 
    parameters :
        db_name : string
            name of database
        db_path : string
            path to the database
        table_name : string
            table in which IP addresses are stored
'''

def getIPs(db_name, db_path, table_name):
    # Create path to db
    dbpath = pathMaker(db_name, db_path)
    # Connect
    conn = lite.connect(dbpath)
    # With connection, do . . .
    with conn:    
        # Cursor
        cur = conn.cursor()
        # Select all observations in the db
        cur.execute("SELECT * FROM {}".format(table_name))
        # Fetch the rows
        rows = cur.fetchall()
        # Store tuples in list
        IPs = [ row[0] 
                for row in rows ]
    # Close connection
    conn.close()
    # Return
    return(IPs)

'''
FUNCTION 3 : Convert IP address to country code (two-letter cc)
    parameters :
        IP_address : string
            IPv4 or IPv6 address to convert 
'''

def IPtoCC(IP_address):
    # Look up the address
    obj = IPWhois(IP_address)
    results = obj.lookup()
    # return cc
    return(results['asn_country_code'])

'''
FUNCTION 4 : create the SQLite database and commit headers
    Parameters :
        dbname    : string
            name of the database
        tablename : string
            name of the table in which to store results
        path  : string
            path to store database. Defaults to '/home/vagrant/Documents/'
'''

def dbSetup(dbname, tablename, path = '~/desktop', override = "TRUE"):
    # Want to replace the database?
    if override == 'TRUE':
        pathfile = pathMaker(dbname, path)
        con = lite.connect(pathfile)
        cur = con.cursor()
        # send headers and create table
        cur.execute("DROP TABLE IF EXISTS {};".format(tablename))
        cur.execute("CREATE TABLE {}(IP TEXT, CC TEXT);".format(tablename))
        # Commit
        con.commit()
    else:
        print "A table with the name {} already exists for path {}. You specified the override option to be {}. The database will be left alone . . . yay!".format(dbname, path, str(override))

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
            cur.executemany("INSERT INTO {} (IP, CC) VALUES(?, ?);".format(tablename), values_list)
            # Commit (i.e. save) changes
            con.commit()
        # Close connection
        con.close()           
    except:
        print 'Error while setting up the database. Quitting the script now . . . '
        
'''
FUNCTION 9 : Helper function to check whether an IP already exists in the database. Here, we are checking the specific IP
(which is basically a unique ID) against all IPs that already exist in the db.
    parameters : 
        url : string
            url of the specific report at reclaimnaija
        dbname : string
            name of the database
        dbtable : string
            table in which reclaimnaija results are stored
        path : string
            system path where the database is stored. Defaults to '~/desktop'
'''

def dbCheck(IP_add, dbname, dbtable, path = '~/desktop/'):
    pathsal = pathMaker(dbname, path)
    con = lite.connect(pathsal)
    # Cursor file
    with con:
        cur = con.cursor()
        cur.execute("SELECT IP FROM {} WHERE IP = ?".format(dbtable), (IP_add,))
        data=cur.fetchone()
        if data is None:
            return(None)
        else:
            print('Report for IP {} already in database . . . moving on'.format(IP_add))
            return(data[0])
    # Close db connection
    con.close()


# In[119]:

'''
+++ RUN +++
'''

# Details
dbname = "IP_clickstream_metals-001"
dbpath = "/users/jasper/documents/github.projects/C4I/projects/clickstream_data/data"
tablename_o = "IPadresses"
tablename_n = "IPandCC"

# Run
mainFunction(dbname, dbpath, tablename_o, tablename_n, override = "FALSE")

