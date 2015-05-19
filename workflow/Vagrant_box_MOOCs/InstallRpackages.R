# Install R packages
rm(list=ls())

# Read table
reqs <- read.table("/vagrant/R_requirements.txt"), header=F, stringsAsFactors=F)[,1]

# Install packages
for(package in reqs) if(!require(package, character.only=TRUE)) install.packages(package, repos='http://cran.xl-mirror.nl/')
