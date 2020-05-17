#!/bin/bash

export DISPLAY=:1
Xvfb :1 -screen 0 1920x1080x16 &
chmod +x post.sh
./post.sh &>/dev/null &
sleep 5
plasmashell  &>/dev/null &
kwin --replace &>/dev/null & 
sleep 5
x11vnc -display :1 -nopw -listen localhost -xkb -forever & # -ncache 10 -ncache_cr can be added for performance. Might give issues with some vnc viewers
cd /root/noVNC && ln -s vnc_auto.html index.html && ./utils/launch.sh --vnc localhost:5900
