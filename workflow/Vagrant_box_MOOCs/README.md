# Introduction

This [vagrantbox](http://docs.vagrantup.com/v2/boxes.html) sets up a [virtual environment](http://en.wikipedia.org/wiki/Virtual_environment_software) to work with [Coursera](https://www.coursera.org/) MOOC data. It installs all of the prerequisites to run the sample scripts provided by Leiden University on [Github](https://github.com/JasperHG90/MOOCs). Both [python](https://www.python.org/) and [Rstudio](http://www.rstudio.com/products/rstudio/) can be run from within a browser outside of the virtual environment. [MongoDB](https://www.mongodb.org/) and [MySQL](https://www.mysql.com/) may also be accessed from outside the virtual environment

## Documentation

For detailed installation instructions, see the [Vagrant documentation](http://docs.vagrantup.com/v2/installation/). 

More information:

 1. [Running vagrant on Linux (Ubuntu)](http://www.cyberciti.biz/cloud-computing/use-vagrant-to-create-small-virtual-lab-on-linux-osx/)
 2. [Running vagrant on Mac Yosemite](http://coolestguidesontheplanet.com/getting-started-vagrant-os-osx-10-9-mavericks/)
 3. [Running vagrant on Windows 7 & 8](http://www.seascapewebdesign.com/blog/part-1-getting-started-vagrant-windows-7-and-8)

## The Basics of Vagrant boxes

Vagrant boxes create and populate a virtual machine on your computer that is an exact clone of the person who made it. The vagrant configuration is stored in the 'Vagrantfile'. The 'shell.sh' script installs programs / packages etc. that are needed for analyses, such as R, R-studio & Python. The 'Python_requirements.txt' file contains a list of python packages to be installed. The 'R_requirements.txt' file contains a list of R packages to be installed. This file is loaded by the 'InstallRpackages.R' file to install the packages. The 'crontab.txt' file contains recursive commands that occur every 'x' seconds, minutes, hours or days.  

# Setting up the vagrantbox (on UNIX machines)

After installing vagrant & [virtualBox](https://www.virtualbox.org/), download or clone the [MOOC vagrant box](https://github.com/JasperHG90/MOOCs/tree/master/workflow/Vagrant_box_MOOCs). Via terminal, navigate to the folder where you downloaded the box and run 'vagrant up' to start up the machine. The vagrant box will now start to configure. 

### BASIC COMMANDS

- vagrant up 
	- Sets up the Virtual Machine (VM)

- vagrant ssh
	- Boots into the VM (need to vagrant up first)

- vagrant suspend
	- VM is temporarily suspended. Machine state is written to hard drive.

- vagrant halt
	- Shuts down VM.

- vagrant destroy
	- Destroys VM

## Starting and accessing Ipython Notebook & Rstudio server from outside the VM

The Vagrantfile forwards both port 8889 (Ipython notebook) and 8787 (Rstudio server). You can check whether they are running by running:
	- sudo netstat -lnptu | grep ':<PORT>', e.g. sudo netstat -lnptu | grep ':8888'

### Starting ipython

NOTE: Start ipython notebook using ip address '0.0.0.0', like so:
	- ipython notebook --ip='0.0.0.0'
	
In your browser, navigate to: http://127.0.0.1:8888

### Starting Rstudio

Rstudio server will start as a service. If you need to start it up manually, do 'sudo rstudio-server start' (or '... stop' to stop it / '... start' to start) while in the vagrant box. Then, navigate to: http://127.0.0.1:8787 in your browser. The username/password is your UNIX username/password (e.g. 'vagrant / vagrant')

### Working with Mongo





