'''
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
'''

# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

'''
This script takes all HTML files in a folder with peer reviewed assignments and stores them in a SQLite database with
two tables; 

  (1) Assignments (full text)
  (2) Reviews (scores)
  
Meta:
- Written by: Jasper Ginn
- Affiliation: Online learning lab, Leiden Centre for Innovation, Leiden University
- Date: 27-05-2015

'''

# <codecell>

'''
+++ LOAD MODULES +++
'''

# Create a unique ID for the assignment
import uuid
# OS for folder mapping
import os
# Parse HTML
from bs4 import BeautifulSoup
# Store data in sqlite
import sqlite3 as lite
# Make reque4sts
import urllib2
# Regex
import re
# PDF mining
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfpage import PDFPage
from cStringIO import StringIO

'''
Set encoding settings
'''

import sys    
sys.setdefaultencoding('utf8')

# <codecell>

'''
+++ MAIN FUNCTION +++
'''

def main(path, dbname, dbpath = '~/desktop', override = "TRUE"):
    # Sort the db
    dbSetup(dbname, dbpath, override = override)
    # Foldermapping on level 1
    dirs = os.walk(path)
    submDir = [x[1] for x in dirs][1]
    # Walk
    dirs = os.walk(path)
    # Get subdir
    subDir = [x[1] for x in dirs][0]
    # Make directories
    fDir = [ "{}{}/{}".format(path, subDir[0], nDir)
             for nDir in submDir ]
    # For each folder . . . 
    for folder in fDir:
        
        '''
        For each submission
        '''
        
        # Folder mapping on level 2. First, get the submission . . .
        dirs = os.walk(folder)
        # Get subdir
        subd = [x[0] for x in dirs]
        PR_sub = "{}/{}".format(subd[1], "fields.html")
        # Extract the information for each submitted PR assignment
        
        '''
        Read html and take out text
        '''
        
        f = urllib2.urlopen("file://{}".format(PR_sub))
        soupi = BeautifulSoup(f, "html.parser")
        # user session ID
        uniqID = getID(soupi)
        # Hash user ID & use as peer assignment ID
        PA_ID = hash(uniqID)
        # Check if PDF
        res = controlLink(soupi)
        if res == True:
            #txt = extractText(soupi)
            MAIN = soup.find("div", {'class':'field-value'})
            # Get link
            link = MAIN.find('a').get('href')
            # Grab text from PDF
            txt = convPDF(str(link))
        else:
            # Get text from html
            txt = extractText(soupi)
        # Create values to send to db
        vals = [ ( PA_ID,
                   uniqID,
                   txt.encode("utf-8") ) ]
        # Store in database
        dbInsert(vals, dbname, "PR_assignment", dbpath)
        
        '''
        For each submission, get the evaluations
        '''
        
        # Folder mapping on level 3
        evals = []
        for edi in subd:
            if "evaluator" in edi:
                fileR = os.listdir(edi)
                evals.append("{}/{}".format(edi, fileR[0]))
        
        # Get evaluations
        for evali in evals:
            f = urllib2.urlopen("file://{}".format(evali))
            soupi = BeautifulSoup(f, "html.parser")
            # Get user session id
            ID = getID(soupi)
            # Get scores
            Qvals = extractValues(soupi)
            # Store in db
            vals = [ ( PA_ID,
                       uniqID,
                       Qvals[0],
                       Qvals[1],
                       Qvals[2]) ]
            # Store in database
            dbInsert(vals, dbname, "PR_review", dbpath)

# <codecell>

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
FUNCTION 2 : create the SQLite database and commit headers
    Parameters :
        dbname    : string
            name of the database
        tablename : string
            name of the table in which to store results
        path  : string
            path to store database. Defaults to '/home/vagrant/Documents/'
'''

def dbSetup(dbname, path = '~/desktop', override = "TRUE"):
    # Want to replace the database?
    if override == 'TRUE':
        pathfile = pathMaker(dbname, path)
        con = lite.connect(pathfile)
        cur = con.cursor()
        # send headers and create table
        # Assignments
        cur.execute("DROP TABLE IF EXISTS PR_assignment;")
        cur.execute("CREATE TABLE PR_assignment(assignment_id INT, session_user_id TEXT, assignment TEXT);")
        # review
        cur.execute("DROP TABLE IF EXISTS PR_review;")
        cur.execute("CREATE TABLE PR_review(assignment_id INT, session_user_id TEXT, Q1 INT, Q2 INT, Q3 INT);")
        # Commit
        con.commit()
        # Destroy
        con.close()
    else:
        print "Database already exists for path {}. You specified the override option to be {}. The database will be left alone . . . yay!".format(dbname, path, str(override))

'''
FUNCTION 3 : Insert results form each page to the database
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

'''
def dbInsert(values_list, dbname, table, path = '~/desktop/'):
    # Path to db
    pathfile = pathMaker(dbname, path)
    # Try connecting and inserting
    try:
        con = lite.connect(pathfile) 
        with con:  
            # Cursor file
            cur = con.cursor()
            # choose table
            if table == "PR_assignment":
                # Write values to db
                cur.executemany("INSERT INTO PR_assignment (assignment_id, session_user_id, assignment) VALUES(?, ?, ?);", values_list)
                # Commit (i.e. save) changes
                con.commit()
            if table == "PR_review":
                # Write values to db
                cur.executemany("INSERT INTO PR_review (assignment_id, session_user_id, Q1, Q2, Q3) VALUES(?, ?, ?, ?, ?);", values_list)
                # Commit (i.e. save) changes
                con.commit()
        # Close connection
        con.close()           
    except:
        print 'Error while inserting values in the database. Quitting the script now . . . '
'''
def dbInsert(values_list, dbname, table, path = '~/desktop/'):
    # Path to db
    pathfile = pathMaker(dbname, path)
    # Try connecting and inserting

    con = lite.connect(pathfile) 
    con.text_factory = str
    with con:  
        # Cursor file
        cur = con.cursor()
        # choose table
        if table == "PR_assignment":
            # Write values to db
            cur.executemany("INSERT INTO PR_assignment (assignment_id, session_user_id, assignment) VALUES(?, ?, ?);", values_list)
            # Commit (i.e. save) changes
            con.commit()
        if table == "PR_review":
            # Write values to db
            cur.executemany("INSERT INTO PR_review (assignment_id, session_user_id, Q1, Q2, Q3) VALUES(?, ?, ?, ?, ?);", values_list)
            # Commit (i.e. save) changes
            con.commit()
    # Close connection
    con.close()           

        
'''
FUNCTION 4 : Convert PDF provided via URL to text
    parameters : 
        url : string
            url linking to pdf


Function is taken from : http://stackoverflow.com/questions/22800100/parsing-a-pdf-via-url-with-python-using-pdfminer
'''

def convPDF(url): # 
    # Settings
    rsrcmgr = PDFResourceManager()
    retstr = StringIO()
    # Unicode
    codec = 'utf-8'
    laparams = LAParams()
    device = TextConverter(rsrcmgr, retstr, codec=codec, laparams=laparams)
    # Open the url provided as an argument to the function and read the content
    f = urllib2.urlopen(urllib2.Request(url)).read()
    # Cast to StringIO object
    fp = StringIO(f)
    interpreter = PDFPageInterpreter(rsrcmgr, device)
    password = ""
    maxpages = 0
    caching = True
    pagenos = set()
    for page in PDFPage.get_pages(fp,
                                  pagenos,
                                  maxpages=maxpages,
                                  password=password,
                                  caching=caching,
                                  check_extractable=True):
        interpreter.process_page(page)
    fp.close()
    device.close()
    str = retstr.getvalue()
    retstr.close()
    return str

'''
FUNCTION 5 : Get session_user_id from a submitted assignment
    parameters :
        soup : soup object
'''

def getID(soup):
    # Get metadata
    title = soup.find("title").text
    # Get 
    SUI = re.findall('session_user_id: (.*[^,)])', string = title)[0]
    # Return
    return SUI

'''
FUNCTION 6 : Check whether a link is provided to a document. If so, then return TRUE.
    parameters :
        soup : soup object
'''

def controlLink(soup):
    MAIN = soup.find("div", {'class':'field-value'})
    # Get all 'a' tags
    MIAN = MAIN.findAll('a')
    # Get hyperlinks
    MIAN_list = [ t.get('href') 
                 for t in MIAN ]
    # Filter if no links present
    MIAN_list = [x for x in MIAN_list if x is not None]
    # Check if Amazonaws is in any of the links
    MIAN_lista = [ "amazonaws" in t
                  for t in MIAN_list]
    # Control
    res = True in MIAN_lista
    # If find 'a', it means a link to assignment is provided
    if res == False:
        return False
    else:
        return True
    
'''
FUNCTION 7 : Convert bunch of <p> tags to a document
    parameters : 
        soup : soup object
'''

def extractText(soup):
    # Main text
    MAIN = soup.find("div", {'class':'field-value'})
    # Find all text enclosed in <p> tags
    st = MAIN.findAll('p')
    # Extract text for each
    sd = [ pe.text 
          for pe in st ]
    # Cast into one string
    res = " ".join(sd).replace("\n", " ")
    # Return
    return res

'''
FUNCTION 8 : Extract peer review values
    parameters :
        soup : soup object
'''

def extractValues(soup):
    # For values in soup object
    field_values = [ int(f.text)
                for f in soup.findAll('div', {'class':'field-value'}) ]
    # Return
    return(field_values)

# <codecell>

path = "/home/vagrant/PR_ASSIGNMENT_001/"
dbname = "TEST"
dbpath = "/home/vagrant/"
override = "TRUE"

main(path = path, dbname = dbname, dbpath = dbpath, override = override)

