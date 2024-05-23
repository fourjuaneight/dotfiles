#!/bin/bash

# This script validates SHA-256 checksums for all files in the current directory and its subdirectories.

# Function to validate checksums
validate_checksums() {
  local file="$1"
  local checksum_file="${file}.sha256"
  local expected_checksum=$(cat "$checksum_file" | awk '{ print $1 }')
  local actual_checksum=$(shasum -a 256 "$file" | awk '{ print $1 }')

  if [ "$expected_checksum" != "$actual_checksum" ]; then
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Corrupted file: $file" >> ~/.corrupted-files.log
  fi
}

# Export the function to be available in subshells
export -f validate_checksums

# Find all sha256 files and validate checksums
find . -type f ! -name "*.sha256" ! -name "*.db" -exec bash -c 'validate_checksums "{}"' \;