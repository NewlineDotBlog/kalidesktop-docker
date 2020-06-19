#!/bin/bash

echo 'Pulling the latest image from dockerhub, this might take a few minutes...'
sudo docker pull newlinedotblog/kalidesktop

echo 'Creating volume'
sudo docker volume create kalivol

echo 'Tagging the base image'
sudo docker image tag newlinedotblog/kalidesktop kalidesktop-base

echo 'Starting the base container...'
sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop-base
sleep 5

echo 'Running personal modifications'
sudo docker exec -it kalidesktop-base /bin/bash -c 'apt-get update && apt-get install nmap'

echo 'Committing changes'
sudo docker commit kalidesktop-base kalidesktop

echo 'Stopping base container'
sudo docker stop kalidesktop-base

echo 'Starting personalized container'
sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop

