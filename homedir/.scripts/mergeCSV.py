#!/usr/bin/env python3

import argparse
import csv

# Parse command line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Merge two CSV files.")
    parser.add_argument('fileA', type=str, help='Path to the first input CSV file')
    parser.add_argument('fileB', type=str, help='Path to the output CSV file')
    return parser.parse_args()

# Parse command line arguments
args = parse_args()
fileA = args.fileA
fileB = args.fileB
output_file = 'mergedFiles.csv'

# Read File A into a dictionary
file_a_data = {}
with open(fileA, mode='r', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        key = (row['name'], row['path'], row['size'])
        file_a_data[key] = row  # Save the row as the value

# Read File B and update dictionary where the keys exist
with open(fileB, mode='r', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        key = (row['name'], row['path'], row['size'])
        if key in file_a_data:
            file_a_data[key]['disc'] = row['disc']  # Update disc value if key exists
        else:
            file_a_data[key] = row  # Include new rows

# Write the merged data to the output file
with open(output_file, mode='w', newline='') as csvfile:
    fieldnames = ['name', 'path', 'size', 'disc']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for row in file_a_data.values():
        writer.writerow(row)

print("Merge completed successfully.")