#!/bin/bash

echo 'Creating volume...'
sudo docker volume create kalivol

# Side not, we're using the "whoami" command instead of leveraging the $HOME variable to ensure
# we don't clash with any weird home directories in the kali machine
USER=`whoami` # Cannot do this inline in a sudo command, will return root instead

# --mount source=kalivol,target=/ \

echo 'Building image, this might take a while...'
sudo docker build -t kalidesktop kalidesktopdocker/  # | grep -E 'Progress|Step' # Print out only progress information

echo 'Finished building! Running kali and waiting...'
sudo docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ kalidesktop # | grep Progress &
sleep 30

unset USER

echo 'How do you want to connect?'
select CHOICE in vnc novnc none ; do

  case $CHOICE in
    vnc)
	(command -v xtigervncviewer &>/dev/null && xtigervncviewer 127.0.0.1:5900 -Fullscreen &>/dev/null & ) || (echo 'xtigervnc not found... Installing...'; sudo apt-get update &>/dev/null && sudo apt-get install tigervnc-viewer --show-progress | grep Progress && xtigervncviewer 127.0.0.1:5900 -Fullscreen &>/dev/null ) || echo 'Failed to install/run xtigervncviewer... Please point your favourite VNC viewer at localhost:5900' &
        ;;
    novnc)
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

