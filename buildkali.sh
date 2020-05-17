#!/bin/env bash

echo 'Creating volume...'
sudo docker volume create kalivol

USER=`whoami` # Cannot do this inline in a sudo command, will return root instead

echo 'Building image, this might take a while...'
sudo docker build \
	-t kalidesktop \ # --mount source=kalivol,target=/ \
	-v /home/$USER:/home/$USER \
	kali2custom/

unset $USER

echo 'Finished building! Running kali and waiting...'
sudo docker run -d --network host --privileged --mount source=kalivol,target=/ kalidesktop # | grep Progress &
sleep 30

echo 'How do you want to connect?'
select CHOICE in vpn novpn none ; do

  case $CHOICE in
    vpn)
        echo 'Ensuring xtigervnc is installed...'
	sudo apt-get update &>/dev/null && sudo apt-get install tigervnc-viewer --show-progress | grep Progress
	xtigervncviewer 127.0.0.1:5900 &>/dev/null &
        ;;
    novpn)
	echo 'Opening your default browser...'
	xdg-open http://127.0.0.1:6080/vnc.html &
        ;;
    none)
        ;;
    *)
  esac
  break # break avoids endless loop -- second line to be executed always
done
echo 'All done! Happy hacking!'

