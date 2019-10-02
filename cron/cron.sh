#!/usr/bin/env bash

for file in ~/dotfiles/cron/*; do
  cp "$file" /etc/cron.d
done