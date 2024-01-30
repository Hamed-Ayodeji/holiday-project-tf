#!/bin/bash

# update and upgrade the system

apt-get update -y && apt-get upgrade -y

# install ansible dependencies

apt-get install -y python3-pip python3-dev software-properties-common

# add ansible repository

apt-add-repository ppa:ansible/ansible

# install ansible

apt-get update -y && apt-get install -y ansible

# install git

apt-get install -y git

# clone the holiday project repository in a directory called ansible in the home directory

git clone https://github.com/Hamed-Ayodeji/holiday-project-tf.git /home/ubuntu/ansible

# install openssh-server

apt-get install -y openssh-server

# enable openssh-server

systemctl enable ssh

# navigated into the ansible directory

cd /home/ubuntu/ansible

# remove the modules and holiday directories

rm -rf modules holiday

# navigate into the ansible directory within the ansible directory

cd /home/ubuntu/ansible/ansible

# move all th contents of the ansible directory into the ansible directory within the home directory

mv /home/ubuntu/ansible/ansible/* /home/ubuntu/ansible

# navigate into the home directory and move the inventory.ini and holiday.pem files into the ansible directory

cd /home/ubuntu && mv inventory.ini holiday.pem /home/ubuntu/ansible

# remove the ansible directory within the ansible directory

cd /home/ubuntu/ansible && rm -rf /home/ubuntu/ansible/ansible

# change the permissions of the holiday.pem file

chmod 400 holiday.pem

# run the ansible playbook

ansible-playbook play.yml