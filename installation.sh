#!/bin/bash

#context: this script is to deploy a LAMP stack on a ubuntu
#docker container. Those images have barebones ubuntu setup
#SO, even sudo has to be installed BUt before it can be,
#it has to be updated and upgraded
apt update
apt upgrade -yq
apt install sudo

#TODO add in an automation that will pull any other scripts into 
#the current directory (which in container ubuntu is /installation/)
#ALSO find a way to automate creating that directory and downloading
#the installation script to it

#there's no sudo password right now nor is it really needed since it's
#w/in a docker container but i'm adding one anyway and it's done by
#calling a different script, first though, all the scripts in the
#directory need to be executable (worked when i tested it!)
sudo chmod +x /installation/*.sh
#this is the script that changes the pw to '1234'
#no need to specify where it is, this should all be in the same
#directory so can just run this command (/installation/ is the
#directory by the way)
sudo ./changepw.sh

#I like zsh. so i'm installing it
sudo apt install zsh -y
#for the apache install, systemctl needs to be installed, again
#bc it's being run on a docker container
sudo apt install systemctl -y
#now systemctl is installed so we install apache
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2 

systemctl status apache2

systemctl is-enabled apache2