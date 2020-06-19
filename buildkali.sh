#!/bin/bash

# This script is meant to automate building the Dockerfile present in the `kalidesktopdocker/` folder. Useful for testing purposes.
# If you simply want to get started quickly, consider looking at `pullkali.sh` instead.

echo 'Creating volume...'
sudo docker volume create kalivol

echo 'Building image, this might take a while...'
sudo docker build -t kalidesktop kalidesktopdocker/  # | grep -E 'Progress|Step' # Print out only progress information

echo 'Finished building! Running kali and waiting...'
sudo docker run -d --network host --privileged -v $HOME:/home/`whoami` --mount source=kalivol,target=/opt/vol/ kalidesktop # | grep Progress &
sleep 30

unset USER

echo 'How do you want to connect?'
select CHOICE in vnc novnc ssh none ; do

  case $CHOICE in
    vnc)
	echo 'Opening your default vnc viewer'
	xdg-open vnc://localhost:5900 & || echo 'Opening vnc viewer failed. Please install a vnc viewer and connect to localhost:5900'
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
  break # break avoids endless loop
done
echo 'All done! Happy hacking!'

