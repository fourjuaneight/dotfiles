import argparse
import csv
from collections import defaultdict

# Function to parse command line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Find duplicates in CSV files.")
    parser.add_argument('inputFile', type=str, help='Path to input CSV file')
    return parser.parse_args()

# Parse command line arguments
args = parse_args()
inputFile = args.inputFile
# Output CSV file for duplicates
output_csv_file = "duplicates.csv"

# Dictionary to store file names and their corresponding records
file_dict = defaultdict(list)

# Read the CSV file and populate the dictionary
with open(inputFile, 'r', newline='') as csvfile:
    csv_reader = csv.DictReader(csvfile)
    for row in csv_reader:
        file_dict[row['name']].append(row)

# Find duplicate file names
duplicates = {k: v for k, v in file_dict.items() if len(v) > 1}

# CSV header (assuming the input CSV has the columns: name, path, size)
header = ['name', 'path', 'size', 'disc']

if duplicates:
    # Open CSV writer for outputting duplicates
    with open(output_csv_file, 'w', newline='') as csvfile:
        csv_writer = csv.DictWriter(csvfile, fieldnames=header)
        
        # Write the header
        csv_writer.writeheader()
        
        # Write the duplicates to CSV
        for records in duplicates.values():
            for record in records:
                csv_writer.writerow(record)
                
    print(f"Duplicate entries written to {output_csv_file}")
else:
    print("No duplicate entries found")