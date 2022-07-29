#!/bin/bash

#
# USAGE:
# cd /book title/
# bash ~/this_script_path.sh
# rm *.m4b (you need to manually remove the original in case something goes wrong)
#
#
# EXAMPLE:
#
#   $ ls
#   The Wheel of Time - Book 11 - Knife of Dreams, Part 1.m4b  The Wheel of Time - Book 11 - Knife of Dreams, Part 2.m4b
#   $ ~/convert_m4b.sh
#   .....
#
#   [OUTPUT]:
#
#   File: Knife of Dreams - Chapter 18 - News for the Dragon.mp3
#   Metadata: ID3v2.3
#   Title: Chapter 18 - News for the Dragon
#   Artist: Robert Jordan
#   Album: Knife of Dreams
#   Track: 23
#   Genre: Audiobooks

#initial track number
track=1

#assumes ( if there are multiple files Part 01/Part 02) that they are in alphabetical order
for i in *.m4b; do
  name=$(echo $i | cut -d'.' -f1)
  echo $name
  ffmpeg -i "$i" -acodec libmp3lame -ar 22050 -ab 64k "$name.mp3"
  full_file_path="$name.mp3"

  #split chapters
  title=$(pwd | sed 's,^\(.*/\)\?\([^/]*\),\2,' | cut -d , -f 1)

  ffmpeg -i "$full_file_path" 2>tmp.txt

  while read -r first _ _ start _ end; do
    if [[ "${first}" = "Chapter" ]]; then
      read # discard line with Metadata:
      read _ _ chapter
      chapter=$(sed -re ":r;s/\b[0-9]{1,$((1))}\b/0&/g;tr" <<<$chapter)
      chapter_file="${title} - ${chapter}.mp3"
      echo "processing $chapter"
      ffmpeg </dev/null -loglevel error -stats -i "${full_file_path}" -ss "${start%?}" -to "${end}" -codec:a copy -metadata track="${chapter}" "${chapter_file}"
      id3v2 --song "$chapter" "$chapter_file"
      id3v2 --album "$title" "$chapter_file"
      id3v2 --track "$track" "$chapter_file"
      echo "$title - $chapter"
      track=$((track + 1))
    fi
  done <tmp.txt

  rm tmp.txt
  rm "$full_file_path"

done
