export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install seclists burpsuite -y
apt-get dist-upgrade -y
sl /usr/share/seclists /usr/share/wordlists/seclists
sl /usr/share/wordlists /root/wordlists
unset DEBIAN_FRONTEND
