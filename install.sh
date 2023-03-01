#!/bin/bash

if [ -x "$(command -v apt-get)" ]; then
  sudo apt-get -y update && sudo apt-get -y upgrade
  sudo apt -y install cron
elif [ -x "$(command -v dnf)" ]; then
  sudo dnf -y update
  sudo dnf -y install cronie

elif [ -x "$(command -v emaint)" ]; then
  echo "please install cron and set a cronjob"
  break
elif [ -x "$(command -v pacman)" ]; then
  if [ -x "$(command -v pamac)" ]; then
    pamac -Syu
  elif [ -x "$(command -v paru)" ]; then
    paru -Syu
  elif [ -x "$(command -v yay)" ]; then
    yay -Syu
  else
    sudo pacman -Syu --noconfirm
  fi
  sudo pacman -S cronie --noconfirm
elif [ -x "$(command -v yum)" ]; then
  sudo yum -y update
  sudo yum -y install cron
else
  echo 'This Distro is not supported!'
fi

wait

sudo systemctl enable cron &>/dev/null
sudo systemctl start cron &>/dev/null

mkdir ~/.auto_update &>/dev/null
curl -s -L https://raw.githubusercontent.com/floork/auto-update-linux/master/auto_update.sh >~/.auto_update/update.sh &>/dev/null
chmod +x ~/.auto_update/update.sh &>/dev/null

wait
crontab -l >mycron &>/dev/null
wait
echo "@reboot ~/.auto_update/update.sh" >>mycron
wait
crontab mycron
wait
rm mycron
