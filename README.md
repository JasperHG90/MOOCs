# Leiden University MOOC Scripts // open Repo

![LUMSoR](https://dl.dropboxusercontent.com/u/38011066/CFI/plots/Lucsor.png)

-----------

## Meta

- Written by: Jasper Ginn
- Email: j.h.ginn[at]cdh.leidenuniv.nl
- Institution: Online Learning Lab, Leiden Centre for Innovation, Leiden University
- Date: 23-04-2015

**This software is licensed under the General Public License v.3** 

## Contact, Feedback & Collaboration

If you have questions, comments, or if you would like to collaborate, please contact me at: j.h.ginn[at]cdh.leidenuniv.nl

## Introduction

This repository contains semi-cleaned scripts and documentation which you can use to pre-process Coursera MOOC data dumps. It further contains several "helper functions" for pre-processing MOOC data. Most of the scripts have been written in the [R statistical Language](http://www.r-project.org/). Some of them are written in [Python](https://www.python.org/). This repository of scripts will be updated regularly.

Most of these guides have been written with UNIX users in mind. I don't use Windows, and those of you who do might need to puzzle a bit to get things working. However, I also provide a [Vagrant box](http://docs.vagrantup.com/v2/boxes.html) in the ["/workflow"](https://github.com/JasperHG90/MOOCs/tree/master/workflow/Vagrant_box_MOOCs) folder which will install a clone of my working environment. When using the vagrant box, all of these guides should work seamlessly, and I encourage you to use it.

I am likely to change the current setup in future releases, thus altering the setup of these scripts somewhat. However, it is my goal to keep these scripts interpretable & informative.

## Using these scripts

The scripts in this repository are 'semi-cleaned'. i.e. I've written them primarily for my own convenience, but they should be adaptable to your own data. Any feedback is hugely appreciated. These scripts focus mainly on data pre-processing, quering and data infrastructure. They do not (yet) cover modeling.

It is entirely possible (and, well, likely) that my approaches are not the 'most effective'. I focus on getting the job done. These scripts are meant as a 'getting started'-guide for those who have not yet set up a data infrastructure to work with the MOOC data.

The scripts are organized along the lines of the data dumps provided by Coursera. That is to say that each folder corresponds to a specific dataset, and each script within those folders pertains especially to those data. "General" helper functions are provided in the 'general_and_workflow'-folder. For a more specific overview of the folders, please see the section 'Folder structure' below.

## A note on Vagrant virtual boxes

I mostly work from within [vagrant virtual boxes](http://docs.vagrantup.com/v2/boxes.html). This is convenient for the following reasons:

1. Vagrant virtual boxes are quickly deployed. Additionally, they are quickly populated with software. If needed, they are quickly re-deployed
2. They allow for a reproducable approach. 
3. It's easy to install experimental software, and doing so will not affect your primary OS.
4. They allow for a trial-and-error approaches.

You can find more information on vagrant boxes in the [/vagrant_box_MOOCs](https://github.com/JasperHG90/MOOCs/tree/master/workflow/Vagrant_box_MOOCs) folder. 

## Folder structure

The scripts in this repository are divided into two main folders:

	(1) "Coursera data dumps"
		* Contains scripts, helper functions & documentation for specific data dumps
	(2) "Workflow"
		* Contains scripts, helper functions & documentation to convert unwieldy data formats to more convenient ones. It further contains 'generic' helper functions that are used across scripts. This folder also contains the virtual machine. 

- [/coursera_data_dumps](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps)
	- [/R_and_MySql](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps/R_and_MySQL)
	- [/clickstream_data](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps/clickstream_data)
		- [/Helper_functions](https://github.com/LU-CFI/MOOCs/tree/master/coursera_data_dumps/clickstream_data/Helper_functions)
		- [/Rmongodb](https://github.com/LU-CFI/MOOCs/tree/master/coursera_data_dumps/clickstream_data/Rmongodb)
		- [/ip_locations](https://github.com/LU-CFI/MOOCs/tree/master/coursera_data_dumps/clickstream_data/ip_locations)
	- [/forum_data](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps/forum_data)
- [/workflow](https://github.com/JasperHG90/MOOCs/tree/master/workflow)
	- [/convert_peerreview](https://github.com/LU-CFI/MOOCs/tree/master/workflow/convert_peerreview)
	- [/Vagrant_box_MOOCs](https://github.com/JasperHG90/MOOCs/tree/master/workflow/Vagrant_box_MOOCs)
	- [/generic_helper_functions](https://github.com/JasperHG90/MOOCs/tree/master/workflow/generic_helper_functions)
