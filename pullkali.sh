#!/bin/bash

mods='export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install nmap -y'

echo 'Stopping any still running kalidesktop containers'
for i in `sudo docker ps | grep 'kalidesktop' | cut -d ' ' -f1`; do sudo docker stop $i;done

echo 'Removing any kalidesktop containers'
for i in `sudo docker ps -a | grep 'kalidesktop' | cut -d ' ' -f1`; do sudo docker rm $i;done

echo 'Removing old kalidesktop image'
sudo docker rmi kalidesktop || echo 'None yet existed'

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
sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop
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

