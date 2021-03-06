FROM kalilinux/kali-rolling
ENV DISPLAY :1

# These are the base files we need to function
# It is recommended you do not change these so you can reuse the docker cache

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    echo 'Installing desktop files, this may take a few minutes...' && \
    apt-get install -y \
	kali-defaults \
        desktop-base \
        kali-desktop-kde \
        kde-plasma-desktop \
        --show-progress


RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    echo 'Installing base files, this may take a few minutes...' && \
    apt-get install -y \
        curl \
	sudo \
	net-tools \
	apt-transport-https \
	gnupg \
        x11vnc \
	python-numpy \
	xvfb \
	novnc \
	dbus-x11 \
	python \
	x11-xkb-utils \
	git \
	menu \
	unzip \
	nano \
	ssh \
	--show-progress && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir ~/.vnc && \
    x11vnc -storepasswd admin ~/.vnc/passwd

# Cloning the noVNC and websockify git repositories. Required to run novnc.

RUN cd /root && git clone https://github.com/kanaka/noVNC.git && \
    cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify && \
    ln -s /root/noVNC/vnc_auto.html /root/noVNC/index.html

# Set up SSH

RUN echo "Port 22000\nPermitRootLogin yes" >> /etc/ssh/sshd_config && \
	echo "root:toor" | chpasswd && \
	service ssh restart

# Add any personal modifications to the docker here 

RUN echo 'Installing additional packages...' && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install \
	kali-tools-top10 \
	-y --show-progress && \
	mkdir /usr/share/wordlists && \
	ln -s /usr/share/wordlists /root/wordlists

# Add the startup script

RUN echo "#!/bin/bash \n\
[ -e /tmp/.X1-lock ] && rm -rf /tmp/.X1-lock \n\
export DISPLAY=:1 \n\
Xvfb :1 -screen 0 1920x1080x16 & \n\
sleep 5 \n\
plasmashell  &>/dev/null & \n\
kwin --replace &>/dev/null &  \n\
sleep 5 \n\
service ssh start \n\
chmod +x /root/post.sh \n\
/root/post.sh &>/dev/null & \n\
x11vnc -display :1 -nopw -listen localhost -xkb -forever & # -ncache 10 -ncache_cr can be added for performance. Might give issues with some vnc viewers \n\
cd /root/noVNC && ./utils/launch.sh --vnc localhost:5900 \n" >/root/startup.sh

# Add the post script, any commands added here will run every time the container launches. Useful to automatically run default tools.

RUN echo "#!/bin/bash \n\
\#java -jar \`which burpsuite\` & &>/root/log & \n" >/root/post.sh

RUN chmod 0755 /root/startup.sh

CMD /root/startup.sh

EXPOSE 5900/tcp 6080/tcp 22000/tcp
