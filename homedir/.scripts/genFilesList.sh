#!/bin/bash

# Output CSV file
output_file="media_files.csv"

# Check if CSV file already exists
if [[ ! -f "$output_file" ]]; then
  # Print CSV header if the file does not exist
  echo "name,path,size" > "$output_file"
fi

# Function to list files and generate the CSV line per file
generate_csv_line() {
  local file="$1"
  local filename
  local full_path
  local file_size_mb
  
  # Get the filename
  filename=$(basename "$file")
  
  # Get the full path
  full_path=$(realpath "$file")
  
  # Get the file size
  file_size_mb=$(du -s -R -b "$file" | sed -n 's/.* \([0-9.]*[kKMGTP]B*\) .*/\1/p')
  
  # Append the line to CSV file
  echo "$filename,$full_path,$file_size_mb" >> "$output_file"
}

# Export the function to be available in subshells
export -f generate_csv_line

# Find all files and process each
find . -type f ! -name "*.sha256" -exec bash -c 'generate_csv_line "{}"' \;
