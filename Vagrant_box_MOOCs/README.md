## README

This vagrantbox sets up a virtual environment containing python (+ many modules used for data science/natural language processing etc.) and Rstudio. Both python an Rstudio can be run from within a browser outside of the virtual environment.

## Setting up the vagrantbox

See https://docs.vagrantup.com/v2/ for documentation on vagrant.

The vagrant configuration is stored in the 'Vagrantfile'. The 'provision.sh' installs programs / packages etc. The 'Python_requirements.txt' file contains a list of python packages to be installed. The 'R_requirements.txt' file contains a list of R packages to be installed. This file is loaded by the 'InstallRpackages.R' file to install the packages.

Navigate to the folder where you downloaded the box via terminal and run 'vagrant up' to start up the machine.

### BASIC COMMANDS

vagrant up 
	- Sets up the Virtual Machine (VM)

vagrant ssh
	- Boots into the VM (need to vagrant up first)

vagrant suspend
	- VM is temporarily suspended. Machine state is written to hard drive.

vagrant halt
	- VM is shut down.

vagrant destroy
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



