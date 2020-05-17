# kalidesktop-docker
Running kali linux from docker. Complete with (no)VNC gui and persistances.

WIP, clone/use at your own risk!

## Usage and features

I created this dockerfile and configuration because as far as I could find none existed yet that used the most recent kali docker image.
Furthermore, I wanted to automate the whole usage of docker to a single script that would start or rebuild a fresh install of kali with a single command.

This docker image was made to have the following features:
* KDE (plasma) desktop
	- Accessible with noVNC at localhost:6080 and VNC at localhost:5900
* Shared home folder (host folder becomes available in the docker image)
* Persistent folder for special programs (/opt will remain persistent for programs such as burpsuite that don't play well with repeated rebuilding)
* Startup script that can do post build actions such as installing additional programs and modifying settings.

