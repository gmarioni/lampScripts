#!/bin/bash

sudo apt update
sudo apt upgrade -yq
sudo apt install unzip -yq

########################################################################
#TODO add in an automation that will pull any other scripts into       #
#the current directory (which in container ubuntu is /installation/)   #
#ALSO find a way to automate creating that directory and downloading   #
#the installation script to it                                         #
########################################################################

# all the scripts in the directory need to be executable 
sudo chmod +x /home/ubuntu/*.sh
# installing apache
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2 
# Install MySQL
sudo apt install mysql-server -yq
# need sql configure script that includes secure installation
# install PHP and php-fpm
sudo apt install php8.1 -yq
sudo apt install libapache2-mod-php php8.1-fpm -yq
# install php-mysql extension
sudo apt install php-mysql -yq
#after installation php needs these two commands to be run
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.1-fpm
sudo systemctl restart apache2
#next two commands start php8.1-fpm, it should already be on but
#just in case
sudo systemctl enable php8.1-fpm
sudo systemctl start php8.1-fpm
# Enable the PHP MySQLi extension and restart Apache2 for changes to take effect.
sudo phpenmod mysqli
sudo service apache2 restart
# Configure mqsql  by running the mysql_secure_installation script
sudo sed -i -e 's/\r$//' mysql_init.sh
sudo /home/ubuntu/mysql_init.sh
# dont know how UFW & Snort work but...theyre here!
# Install and configure UFW
sudo apt-get install ufw -yq
# Install Snort
sudo apt-get install snort -yq
#ok at this point this file: /etc/apache2/sites-available/000-default.conf 
#needs to be updated. Easiest way i know is to overwrite with a premade 
#file which is in this repo. then you need to restart apache
sudo mv /home/ubuntu/000-default.conf /etc/apache2/sites-available
sudo systemctl restart apache2
#at this point, we can add in all the
#php files we need for the site.
#the php files and sql qumyery should have already been downloaded
#moving the zip file w/php files to html folder
sudo chmod +x /home/ubuntu/*.php
sudo mv -f /home/ubuntu/*.php /var/www/html
# sudo unzip /var/www/html/phpFiles.zip -d /var/www/html/
#delete zip file
# sudo rm /var/www/html/phpFiles.zip
#remove index.html file
sudo rm -f /var/www/html/index.html
