FROM kalilinux/kali-rolling
ENV DISPLAY :1
ADD startup.sh /root/startup.sh
RUN chmod 0755 /root/startup.sh
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    echo 'Installing updates...' && \
    apt-get install -y \
        curl \
	sudo \
	openbox \
	net-tools \
	apt-transport-https \
	gnupg \
        x11vnc \
	python-numpy \
	xvfb \
	geany \
	novnc \
	dbus-x11 \
	python \
	x11-xkb-utils \
        kali-defaults \
	desktop-base \
	kali-desktop-kde \
	kde-plasma-desktop \
	git \
	menu \
	unzip \
	--show-progress && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir ~/.vnc && \
    x11vnc -storepasswd admin ~/.vnc/passwd
RUN apt-get dist-upgrade -y --show-progress

RUN cd /root && git clone https://github.com/kanaka/noVNC.git && \
    cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify && \
    cd /root

RUN echo

CMD /root/startup.sh

EXPOSE 5900/tcp 6080/tcp