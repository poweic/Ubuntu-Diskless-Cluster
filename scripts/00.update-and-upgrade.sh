sed -i "s%http://us.archive.ubuntu.com/ubuntu/%http://ftp.nchc.org.tw/ubuntu/%g" /etc/apt/sources.list
apt-get update && apt-get upgrade -y && reboot
