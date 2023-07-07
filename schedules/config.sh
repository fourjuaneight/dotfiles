#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

action "setting up scheduled tasks"

chmod +x ~/.scripts/*.sh

mkdir ~/.logs;

if [[ "$OSTYPE" == "darwin"* ]]; then
  for file in ./schedules/launchd/*.plist; do
    cp $file ~/Library/LaunchAgents
  done

  for file in ./schedules/launchd/*.plist; do
    # remove .plist extension
    filename=$(basename "$file")
    filename="${filename%.*}"

    touch ~/.logs/$filename.log
    launchctl load ~/Library/LaunchAgents/$file
    launchctl start $filename
  done
else
  sudo cp ~/dotfiles/schedules/systemd/* /etc/systemd/user/

  action "enable services"
  for file in ./schedules/systemd/*.service; do
    systemctl --user start "${file}"
    systemctl --user enable "${file}"
  done

  action "enable timers"
  for file in ./schedules/systemd/*.timer; do
    systemctl --user start "${file}"
    systemctl --user enable "${file}"
  done

  action "reloading daemon"
  systemctl --user daemon-reload
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  action "adding systemctl util"
  git clone https://github.com/joehillen/sysz.git
  cd sysz
  sudo make install # /usr/local/bin/sysz
fi
