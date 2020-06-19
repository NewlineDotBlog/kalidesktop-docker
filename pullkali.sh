#!/bin/bash

# Add any personal modifications here.
# After setting up the base image, this will be applied and committed to a new image
# This way, you can download the prebuilt image from dockerhub, yet apply any personal modifications to the image
# that will be stored in a new reusable image.
# Use '&&' or ';' for separate commands.
mods='apt-get update && apt-get install nmap'

echo 'Pulling the latest image from dockerhub, this might take a few minutes...'
sudo docker pull newlinedotblog/kalidesktop

echo 'Creating volume'
sudo docker volume create kalivol

echo 'Tagging the base image'
sudo docker image tag newlinedotblog/kalidesktop kalidesktop-base

echo 'Starting the base container...'
contname=`sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop-base`
sleep 5

echo 'Running personal modifications'
sudo docker exec -it $contname /bin/bash -c "$mods"

echo 'Committing changes'
sudo docker commit $contname kalidesktop

echo 'Stopping base container'
sudo docker stop $contname

unset mods
unset contname

echo 'Starting personalized container'
sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ --name 'kalidesktop' kalidesktop

