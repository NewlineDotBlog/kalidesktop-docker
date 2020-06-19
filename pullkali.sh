#!/bin/bash

# This script is meant for pulling the image from dockerhub. This is recommended to get started as fast as possible.

# Add any personal modifications here.
# After setting up the base image, this will be applied and committed to a new image
# This way, you can download the prebuilt image from dockerhub, yet apply any personal modifications to the image
# that will be stored in a new reusable image.
# Use '&&' or ';' for separate commands.
mods='export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install nmap'

echo 'Pulling the latest image from dockerhub, this might take a few minutes...'
sudo docker pull newlinedotblog/kalidesktop

echo 'Creating volume'
sudo docker volume create kalivol

echo 'Tagging the base image'
sudo docker image tag newlinedotblog/kalidesktop kalidesktop-base

echo 'Starting the base container...'
contname=`sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop-base`
sleep 3

echo 'Running personal modifications'
sudo docker exec -it $contname /bin/bash -c "$mods"

echo 'Committing changes'
sudo docker commit $contname kalidesktop

echo 'Stopping base container'
sudo docker stop $contname
sleep 5

unset mods
unset contname

echo 'Starting personalized container'
sudo docker run --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop
sleep 5

echo 'How do you want to connect?'
select CHOICE in vnc novnc ssh none ; do

  case $CHOICE in
    vnc)
        echo 'Opening your default vnc viewer...'
        xdg-open vnc://localhost:5900  || echo 'Opening vnc viewer failed. Please install a vnc viewer and connect to localhost:5900' & 
        ;;
    novnc)
        echo 'Opening your default browser...'
        xdg-open http://127.0.0.1:6080/vnc.html &
        ;;
    ssh)
        echo 'Open a root shell with the following command, password "toor"'
        echo 'ssh root@localhost -p 22000 -X'
        ;;
    none)
        ;;
    *)
  esac
  break
done
echo 'All done! Happy hacking!'

