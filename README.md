# Quick warning

This was an experiment to see if kali could be run in a docker environment. It is likely unsafe and outdated and should not be used in production environments!

For a way better and more modern implementation of this idea please see [Exegol](https://github.com/ThePorgs/Exegol).

# kalidesktop-docker
Running kali linux from docker. Complete with (no)VNC gui and persistances.

Indepth blog about how this all functions on https://newline.blog/posts/kalidesktopdocker/ .

Clone/use at your own risk!

## Quick usage

The easiest way to get started is with the `pullkali.sh` script in the [repository](https://github.com/NewlineDotBlog/kalidesktop-docker). This scripts allows you to get started as fast as possible and will allow you to make additional personal changes to your image.

To use this without the build script or the git repository, build and run as follows:

```
docker volume create kalivol
docker pull newlinedotblog/kalidesktop:latest
docker run -d --network host --privileged -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ newlinedotblog/kalidesktop
```
Running the above will give you the base image with [`kali-tools-top10`](https://tools.kali.org/kali-metapackages) installed.

Alternatively, run with limited access to the host system. This is useful when you want the container to manage its own network interfaces (with IE its own VPN connection):

```
docker run -d -p 5900:5900 -p 6080:6080 -p 22000:22000 -v $HOME:/home/$USER --mount source=kalivol,target=/opt/vol/ --privileged newlinedotblog/kalidesktop
```

Be warned, running the last command will give the container full rights over your network devices and ports.

Then, you can connect to http://localhost:6080/vnc.html to connect to noVNC or connect to localhost:5900 with your vnc client. Alternatively, you can connect to ssh at port 22000 with user `root`, password `toor`.

## Features

I created this dockerfile and configuration because as far as I could find none existed yet that used the most recent kali docker image.
Furthermore, I wanted to automate the whole usage of docker to a single script that would start or rebuild a fresh install of kali with a single command.

This docker image was made to have the following features:
* KDE (plasma) desktop
	- Accessible with noVNC at localhost:6080 and VNC at localhost:5900
* Shared home folder (host folder becomes available in the docker image)
* Persistent folder for special programs (/opt will remain persistent for programs such as burpsuite that don't play well with repeated rebuilding)
* Startup script that can do post build actions such as installing additional programs and modifying settings.
* Full ports access for ease of use
* Full docker access for docker in docker support

Note the following design decisions when making changes or adding self made post scripts:

* `/root/` is non persistent custom files and folders. These are meant only for the kali machine such as symbolic links etc.
* `/home/$USER` is the persistent home folder of the host machine.
* `/opt/vol/` is a volume for persistent programs and files. Should be used for weird installations and configurations. Separate volumes can be attached in `/opt/` as well.

How to build:

1. Clone the repository
1. Run `chmod +x buildkali.sh`
1. Run the buildkali.sh script
1. Connect with your favourite VNC client to localhost:5900 or with your browser to http://localhost:6080/vnc.html

### WARNING

As can be read above, the machine has full access to your home folder by default. Furthermore, the container runs with a lot of privileges by default.
I am not responsible for any deleted home directories by a missed 'rm -rf /' in  an exploit you ran. Use with care.

## Known issues

* Burpsuite does not work over VNC

Known issue, currently no known fix available (to my knowledge). **Workaround:** use x11 over ssh to run burpsuite. `ssh root@localhost -p 22000 -X`, then run burpsuite.

## Notes for developers

* If you want to implement a different GUI instead of KDE-Plasma, you have to replace both the package `kali-desktop-kde` and `kde-plasma-desktop` with their counterparts for the GUI you're trying to implement. Furthermore, you'd also have to replace the `plasmashell` command in the startup script with your GUI's equivalent of the same command.
* Feel free to copy, reuse and modify any code you find here. A link back to me would be appreciated but is not required. 
