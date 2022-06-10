#!/bin/sh

touch ~/videos.log || exit

cd ~/Pictures/Library

for file in ~/Pictures/Library/*.mov; do
  fname="${file%.*}";
  ffmpeg -i $file -c copy "$fname.mp4" &&
  rm $file;
done
