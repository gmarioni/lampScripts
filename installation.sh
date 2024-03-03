#!/bin/bash

#context: this script is to deploy a LAMP stack on a ubuntu
#docker container. Those images have barebones ubuntu setup
#SO, even sudo has to be installed BUT before it can be,
#it has to be updated and upgraded
apt update
apt upgrade -yq
apt install sudo -y
apt install wget -y #gonna need this one later, so installing ahead of time
# apt install unzip -> ok SO looks like ubuntu container version has this baked in
#of all things they included this, either way, leaving it here in case it's needed
apt install nano #gonna need this one later too

########################################################################
#TODO add in an automation that will pull any other scripts into       #
#the current directory (which in container ubuntu is /installation/)   #
#ALSO find a way to automate creating that directory and downloading   #
#the installation script to it                                         #
########################################################################


#there's no sudo password right now nor is it really needed since it's
#w/in a docker container but i'm adding one anyway and it's done by
#calling a different script, first though, all the scripts in the
#directory need to be executable (worked when i tested it!) hence
#the following command
sudo chmod +x /installation/*.sh
#this next command calls the script that changes the pw to '1234'
#no need to specify where it is, this should all be in the same
#directory so can just run this command (/installation/ is the
#directory by the way)
sudo ./changepw.sh

#I like zsh. so i'm installing it
sudo apt install zsh -y
#for the apache install, systemctl needs to be installed, again
#bc this is all being run on a docker container
sudo apt install systemctl -y
#now systemctl is installed so we install apache
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2 

systemctl status apache2

systemctl is-enabled apache2

# installing mariadb
#HA jokes on you! need these services first (again bc this is living in a docker container)
sudo apt install network-manager
sudo apt install networkd-dispatcher -y
sudo apt install unattended-upgrades -y
sudo apt install gdm3 -y #heads up that one's gonna take a while
sudo apt install mariadb-server -y
sudo systemctl enable mariadb
sudo service mariadb start 
#ok so on this last line starting the mariadb beats the heck outta me but!
#for SOME reasn ubuntu w/in a docker container doesn't wanna use systemctl
#to start mariadb. I have to use a sysvinit command... here's what it should
#be in systemctl for deploying on regular ubuntu:
# sudo systemctl start mariadb 

####################################################################################
# TODO: create script of all the configs for the mariadb server and call that here #
# no time right now to figure it out and make the script############################
####################################################################################

wget https://wordpress.org/latest.zip #this gets wordpress!
unzip latest.zip #this unzips wordpress
rm latest.zip #deletes the zip file now that it's extracted
chown -R www-data:www-data wordpress #change ownership of the wordpress folder so now the www-data user owns it
mv wordpress /var/www/ #moves wordpress folder to the /var/www/ directory

#there's a whole config file you gotta write here, TODO: automate that later
sudo a2ensite wordpress.conf
sudo a2dissite 000-default.conf
sudo apt install libapache2-mod-php php-curl php-gd php-intl php-mbstring php-mysql php-soap php-xml php-xmlrpc php-zip -y
a2enmod rewrite #wordpress needs this module
sudo service apache2 restart
#again on this one i had to use sysvinit instead of systemctl, nevertheless here's the other command
#sudo systemctl restart apache2
#closing note: modify this script when deploying on a true ubuntu server

#OOOOKKKKK
#docker run -itd -p 20801:80 --rm --name tempBox temp2:temp2 bash
#that's the docker command that will run the premade container that has the wordpress site already working
#NOTICE on left the port is 20801 so the port on the host forwards traffic on that port to port 80 in the
#container. this way when i go to that IP on my lan i do <ip-address>:20801. so that way it works on trueNAS
#problem is going in and enabling apache and mariadb...maybe have that part of the docker-compose yaml file??
#it's another todo for another day
#once you run it you have to attach to it and run this:
#service apache2 start
#service mariadb start
#AGAIN systemctl ain't working in docker so i had to use sysvinit. oh well problem for another day even though
#systemctl works earlier in the install. whatever