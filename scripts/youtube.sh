#!/usr/bin/env bash

cd /mnt/d/YouTube && youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio:' --merge-output-format mp4 -o "$%(title)s.%(ext)s" $1