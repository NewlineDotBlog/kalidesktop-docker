#!/bin/env bash

echo 'Creating volume...'
sudo docker volume create kalivol

# Side not, we're using the "whoami" command instead of leveraging the $HOME variable to ensure
# we don't clash with any weird home directories in the kali machine
USER=`whoami` # Cannot do this inline in a sudo command, will return root instead

# --mount source=kalivol,target=/ \

echo 'Building image, this might take a while...'
sudo docker build -t kalidesktop kalidesktopdocker/

unset $USER # We no longer need the variable

echo 'Finished building! Running kali and waiting...'
sudo docker run -d --network host --privileged -v $HOME:/home/$USER kalidesktop # | grep Progress &
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
  break # break avoids endless loop
done
echo 'All done! Happy hacking!'

