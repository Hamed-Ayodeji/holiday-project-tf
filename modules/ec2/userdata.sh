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