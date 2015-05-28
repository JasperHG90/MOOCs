#!/usr/bin/env bash

### Provisioning the virtual machine

# Update
sudo apt-get update <<-EOF
yes
EOF

# Install basic requirements
echo "Installing basic requirements . . . "
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

## Set time

echo "Europe/Amsterdam" > /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

## Folder creation

echo "Creating Folders..."
mkdir Documents
mkdir Downloads
mkdir temp
# Own
sudo chown -R vagrant Documents
sudo chown -R vagrant Downloads
# Clone
cd Documents
git clone https://github.com/JasperHG90/MOOCs.git
cd -

## Programming

echo 'Installing python and pip...'
sudo apt-get install python-dev <<-EOF
yes
EOF
sudo apt-get install python-pip <<-EOF
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

# Update
sudo apt-get update <<-EOF
yes
EOF

echo "Installing Python dependencies..."
sudo pip install -r /vagrant/Python_requirements.txt

echo "Installing Ipython Notebook..."
sudo apt-get install ipython-notebook <<-EOF
yes
EOF

# R & R-studio

echo "Installing R-base..."
# Add cran to list of sources (to get the last version of R)
echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee --append /etc/apt/sources.list
# Add public keys
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
# Update
sudo apt-get update <<-EOF
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
sudo R CMD BATCH /vagrant/InstallRpackages.R

echo "Installing rJava..."
sudo apt-get install r-cran-rjava <<-EOF
yes
EOF

echo "Installing RMySQL . . ."
sudo apt-get install r-cran-rmysql <<-EOF
yes
EOF

# Extra

echo "Installing htop..."
sudo apt-get install htop <<-EOF
yes
EOF

# Installing MongoDB

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

# Installing MySQL
echo 'Installing MySQL . . . '
sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql mysql-server-5.5 mysql-client -q <<-EOF
yes
EOF

sudo apt-get install mysql-client

echo "Setting up crontab..."
sudo crontab /vagrant/crontab.txt

echo "Updating & Upgrading..."
sudo apt-get update <<-EOF
yes
EOF
sudo apt-get upgrade <<-EOF
yes
EOF


