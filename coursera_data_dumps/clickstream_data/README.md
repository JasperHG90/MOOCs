# Working with the Coursera clickstream data

---------

## Introduction

For several reasons, it makes sense to store the clickstream data in a mongoDB instance. Advantages include:

1. Mongo is fast
2. The Coursera exports are essentially BSON exports from a MongoDB. Importing them is therefore pretty painless. 
3. Mongo can be queried from within R and Python.
4. A lot of the 'pre work' such as getting unique URLs, counts and other simple operations can be done from within mongo. As such, you avoid having to load the data in memory in its entirety or that you have to read the files line-by-line.
5. For those interested; mongo has a map/reduce function.

For general documentation on mongodb, see: http://docs.mongodb.org/manual/core/crud-introduction/

## Setting up mongodb

Installing mongo can be a bit tricky depending on your OS. I do this on my Linux Virtualbox, but a quick google for 'install mongodb [insert operating system here]' should give you adequate information. Here are the links to the official install how-to for each OS:

	- [For linux](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
	- [For Mac](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-os-x/)
	- [For Windows](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-windows/)

## Importing Coursera clickstream data (JSON format) in mongo

Using terminal:

	- mongoimport -d [name database] -c [name collection] --type json --file [/path/to/filename].[extension]

e.g.:

	- mongoimport -d moocs -c metals001 --type json --file /users/jasper/desktop/metalsclickstream.txt

## Basic mongodb commands

Using terminal:

	1. Enter mongo : mongo
	2. Show databases : show dbs
	3. Enter database : use [database name]
	4. Show number of items in a database collection : db.[collection name].count()
	5. Iteratively show results in a database collection : db.[collection name].find()
	6. Find a specific value in a collection : db.[collection name].find({ [item] : [value to look for]})

		* Example:

			- db.metals.find( {'key':'user.video.lecture.action'})

		* For multiple queries, put commas between the desired fields, like so:

			- db.[collection name].find({ [item1] : [value to look for] , [item2] : [value to look for] })

	7. Saving MongoDB queries into a file : mongo 127.0.0.1/[database name] --eval "var c = db.[collection name].[statement](); while(c.hasNext()) {printjson(c.next())}" >> [file name].[extension]

		* Example: (mind the single quotation marks as the statement is wrapped in doubles)

			- mongo 127.0.0.1/mydb --eval "var c = db.terror.find(); while(c.hasNext()) {printjson(c.next())}" >> temp.txt

			- mongo 127.0.0.1/mydb --eval "var c = db.terror.find({'key' : 'user.video.lecture.action', 'page_url' : 'https://class.coursera.org/terrorism-004/lecture/view?lecture_id=211'}); while(c.hasNext()) {printjson(c.next())}" >> test.txt

			- mongo 127.0.0.1/mydb --eval "printjson(db.terror.count())"

## Using rmongodb to query data in R

You can query mongodb results from within R using the rmongodb package. You can find a 'basic script' on how to query data in the '/clickstream_data/Rmongodb' folder. I've also added an R markdown file on more complicated procedures in the '/clickstream_data/helper_functions' folder

#### Useful resources for rmongodb

	1. http://cran.r-project.org/web/packages/rmongodb/vignettes/rmongodb_introduction.html
	2. https://rud.is/b/2012/10/22/get-an-r-data-frame-from-a-mongodb-query/
	3. http://www.joyofdata.de/blog/mongodb-state-of-the-r-rmongodb/
	4. http://cran.r-project.org/web/packages/rmongodb/vignettes/rmongodb_cheat_sheet.pdf

## Using Pymongo to query data in python

You can query mongodb results from within Python using the pymongo module. I've incorporated some basic commands in the 'iplookup' script in the '/clickstream_data/ip_locations' folder

#### Useful resources for pymongo

	1. https://api.mongodb.org/python/current/tutorial.html
	2. http://www.informit.com/articles/article.aspx?p=2246943
	3. http://altons.github.io/python/2013/01/21/gentle-introduction-to-mongodb-using-pymongo/


