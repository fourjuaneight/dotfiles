#!/bin/bash

# This script generates SHA-256 checksums for all files in the current directory and its subdirectories.

# Function to generate checksums
generate_checksum() {
  local file="$1"
  local checksum_file="${file}.sha256"
  shasum -a 256 "$file" > "$checksum_file"
  echo "Checksum generated for $file: $checksum_file"
}

# Export the function to be available in subshells
export -f generate_checksum

# Find all files (excluding .sha256 files and the script itself) and compute checksums
find . -type f ! -name "*.sha256" -exec bash -c 'generate_checksum "{}"' \;
