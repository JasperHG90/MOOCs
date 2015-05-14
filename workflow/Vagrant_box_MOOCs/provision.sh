#!/usr/bin/env bash

### Provisioning the virtual machine

# Update
sudo apt-get update

# Install base packages
echo "Installing base packages..."
sudo apt-get install zlib1g-dev
sudo apt-get install git <<-EOF
yes
EOF
sudo apt-get install g++ <<-EOF
yes
EOF
sudo apt-get install default-jre <<-EOF
yes
EOF
sudo apt-get install zip
sudo apt-get install unzip
sudo apt-get install libxml2-dev <<-EOF
yes
EOF
sudo apt-get install libxslt1-dev <<-EOF
yes
EOF
echo 'Installing python and pip...'
sudo apt-get install python-dev <<-EOF
yes
EOF
sudo apt-get install python-pip <<-EOF
yes
EOF
echo "Installing htop..."
sudo apt-get install htop <<-EOF
yes
EOF
echo "Installing libjpeg-dev..."
sudo apt-get install libjpeg-dev <<-EOF
yes
EOF

echo "Configuring libjpeg..."
sudo ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/
sudo ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so.6 /usr/lib/
sudo ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib/

echo "Creating Folders..."
mkdir Documents
cd Documents && mkdir Python_Scripts && mkdir R_Scripts
cd -
mkdir Downloads
mkdir temp

#echo "Installing Python dependencies..."
#sudo pip install -r /vagrant/Python_requirements.txt

echo "Installing Anaconda..."
cd Downloads
sudo wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-x86_64.sh
sudo bash Anaconda-2.2.0-Linux-x86_64.sh <<-EOF
ENTER
EOF

# Update
sudo apt-get update <<-EOF
yes
EOF

echo "Installing R-base..."
# Add cran to list of sources (to get the last version of R)
sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
# Add public keys
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
# Update
sudo apt-get update <<-EOF
yes
EOF
# Upgrade
sudo apt-get upgrade <<-EOF
yes
EOF
# Install R-base
sudo apt-get install r-base <<-EOF
yes
EOF

echo "Installing R-studio server..."
sudo apt-get install libjpeg62 <<-EOF
yes
EOF
cd temp
sudo apt-get install gdebi-core <<-EOF
yes
EOF
sudo apt-get install libapparmor1 <<-EOF
yes
EOF
sudo wget download2.rstudio.org/rstudio-server-0.98.1103-amd64.deb
sudo gdebi rstudio-server-0.98.1103-amd64.deb <<-EOF
yes
EOF

echo "Installing R packages..."
sudo R CMD BATCH /vagrant/R_requirements.R

echo "Installing rJava..."
sudo apt-get install r-cran-rjava <<-EOF
yes
EOF

echo "Installing Ipython Notebook..."
sudo apt-get install ipython-notebook <<-EOF
yes
EOF

#Step 1:  Import the MongoDB public key 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

#Step 2: Generate a file with the MongoDB repository url
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

#Step 3: Refresh the local database with the packages
sudo apt-get update <<-EOF
yes
EOF

#Step 4: Install the last stable MongoDB version and all the necessary packages on our system
sudo apt-get install mongodb-org <<-EOF
yes
EOF

echo "Setting up crontab..."
sudo crontab /vagrant/crontab.txt

echo "Updating..."
sudo apt-get update <<-EOF
yes
EOF
