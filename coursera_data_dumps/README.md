## Introduction

This folder contains helper functions for each Coursera data dump. This README also provides some basic information on MySQL databases, such as how to load data from a MySQL database, and how to convert a MySQL database to a SQLite database. 

More Information:

 1. Coursera help pages: https://partner.coursera.help/hc/en-us/articles/203586039-Manual-Data-Exports
 2. Installing MySQL & MySQL workbench: https://dev.mysql.com/downloads/mysql/
 3. MySQL v. SQLite: https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems

### A note on my use of SQLite databases

I convert all of the Coursera MySQL dumps to SQLite databases. SQLite databases work in a similar way to MySQL databases. However, they are serverless and take a hit on security (among many other differences). So, why do it? 

 1. As mentioned previously, I work in a Vagrant virtual machine. This means that oftentimes, I need to re-populate my VM with data if something goes wrong. It's way simpler to copy SQLite files into the box as part of the standard VM population, since they are simply 'files' and can easily be copied.
 2. I find it infinitely simpler to connect to a SQLite database from within R/Python. 
 3. It is easy to switch between R and Python without having to use CSVs, TXTs etc. 

## Introduction

This document lists commands and tips to work with mySQL servers. We work with MySQL because Coursera gives us MySQL data dumps, which we have to recreate in MySQL. So, for the forum && clickstream data, it is essential we do this. 

I have installed MySQL in my own environment, where I can access these files. They are password protected. If you want to access the database, ask Jasper Ginn (j.h.ginn@cdh.leidenuniv.nl)

## Details

- default username is 'root'. This comes with a pre-determined pwd. Here's how to change it (see: http://stackoverflow.com/questions/10895163/how-to-find-out-the-mysql-root-password)

		* If server is running: stop it --> sudo /usr/local/mysql/support-files/mysql.server stop
		* Start in safe mode --> sudo mysqld_safe --skip-grant-tables 
		* Log in to root (from another terminal window): mysql -u root
		* Change pwd: mysql> UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';
		* Start server: sudo /usr/local/mysql/support-files/mysql.server start

## Basic commands

### Starting server 

- sudo /usr/local/mysql/support-files/mysql.server start

### Stopping server

- sudo /usr/local/mysql/support-files/mysql.server stop

### Restarting server

- sudo /usr/local/mysql/support-files/mysql.server restart

### Exporting path

- export PATH=$PATH:/usr/local/mysql/bin/

		* If problem exists that you have to export EVERY time you start a new terminal instance, see: http://hathaway.cc/post/69201163472/how-to-edit-your-path-environment-variables-on-mac

## Importing a db 

Coursera gives us data in the form of MySQL dumps. Once you obtain these, install MySQL (and workbench), and follow the steps above. To import a sql file:

		1. mysql -u <USERNAME> -p
		2. mysql> DROP DATABASE <dbname>;
		3. mysql> CREATE DATABASE <dbname>;
		4. mysql> EXIT;
		5. mysql -u <USERNAME> -p -D my_session < /path/to/FILENAME.sql

## Exporting a MySQL database to SQLite database

It is possible to convert MySQL databases to SQLite (see: https://gist.github.com/esperlu/943776)

I convert MySQL databases to SQLite because:

		1) I use R, and the necessary package to view MySQL tables currently do not work on my laptop
		2) I am more familiar with SQLite as of now
		3) It is lightweight and easy to query.

To convert, do:

		- sh mysql2sqlite.sh --no-data -u root -p<pwd> <mysqldb> | sqlite3 /path/to/folder/<dbname>.sqlite

However, for security concerns, we should move to quering MySQL directly out of R in the (near) future, as SQLite databases are NOT secure at all.



