#!/usr/bin/env bash

for file in $(fd -H -s '.DS_Store' /); do
  yes | rm "$file"
done
