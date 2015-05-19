# Leiden University repository of scripts for pre-processing Coursera MOOC data & helper functions

-----------

## Meta

- Written by: Jasper Ginn
- Email: j.h.ginn[at]cdh.leidenuniv.nl
- Institution: Online Learning Lab, Leiden Centre for Innovation, Leiden University
- Date: 23-04-2015

## Introduction

This repository contains semi-cleaned scripts and documentation which you can use to pre-process Coursera MOOC data dumps. It further contains several "helper functions" which could be useful for working with these data. Most of the scripts have been written in the [R statistical Language](http://www.r-project.org/). Some of them are written in [Python](https://www.python.org/). This repository of scripts will be updated sporadically to add new functions or update existing ones. Any errors found in these scripts are mine. 

Most of these guides have been written with UNIX users in mind. I don't use Windows, and those of you who do might need to puzzle a bit to get things working. However, I also provide a [Vagrant box](http://docs.vagrantup.com/v2/boxes.html) in the "/workflow" folder that you could use. When using the vagrant box, all of these guides should work seamlessly.

Most of these scripts will be frequently updated. It is entirely possible (and likely) that I change my workflow in the future, thus altering the setup of these scripts somewhat. However, it is my goal to keep these scripts highly interpretable & informative.

## Additional Information

I mostly work from within [vagrant virtual boxes](http://docs.vagrantup.com/v2/boxes.html). This is convenient for the following reasons:

1. Vagrant virtual boxes are quickly deployed. Additionally, they are quickly populated with software. If needed, they are quickly re-deployed
2. They allow for a reproducable approach. 
3. It's easy to install experimental software, and doing so will not affect your primary OS.
4. They allow for a trial-and-error approaches.

You can find more information on vagrant boxes in the [/vagrant_box_MOOCs](https://github.com/JasperHG90/MOOCs/tree/master/workflow/Vagrant_box_MOOCs) folder. 

## Using these scripts

The scripts in this repository are 'semi-cleaned'. i.e. I've written them primarily for my own convenience, but they should be adaptable to your own data. Any feedback is hugely appreciated. After all, sharing is caring :-).

It is entirely possible (and, well, likely) that my approaches are not the 'most effective'. I focus on getting the job done. These scripts are meant as a 'getting started'-guide for those who have not yet set up a data infrastructure to work with the MOOC data.

The scripts are organized along the lines of the data dumps provided by Coursera. That is to say that each folder corresponds to a specific dataset, and each script within those folders pertains especially to those data. "General" helper functions are provided in the 'general_and_workflow'-folder. For a more specific overview of the folders, please see the section 'Folder structure' below.

## Folder structure

- [/coursera_data_dumps](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps)
	- [/R_and_MySql](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps/R_and_MySQL)
	- [/clickstream_data](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps/clickstream_data)
	- [/forum_data](https://github.com/JasperHG90/MOOCs/tree/master/coursera_data_dumps/forum_data)
- [/workflow](https://github.com/JasperHG90/MOOCs/tree/master/workflow)
	- [/Vagrant_box_MOOCs](https://github.com/JasperHG90/MOOCs/tree/master/workflow/Vagrant_box_MOOCs)
	- [/generic_helper_functions](https://github.com/JasperHG90/MOOCs/tree/master/workflow/generic_helper_functions)
	- [/store_coursera_exports](https://github.com/JasperHG90/MOOCs/tree/master/workflow/store_coursera_exports)

## Contact & Feedback

If you have questions, comments, or other requests, please contact me at: j.h.ginn[at]cdh.leidenuniv.nl
