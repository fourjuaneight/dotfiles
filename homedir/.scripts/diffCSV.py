import argparse
import csv

# Function to parse command line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Diff two CSV files.")
    parser.add_argument('fileA', type=str, help='Path to the first input CSV file')
    parser.add_argument('fileB', type=str, help='Path to the output CSV file')
    return parser.parse_args()

# Parse command line arguments
args = parse_args()
fileA = args.fileA
fileB = args.fileB

# Read 'name' column from File A
names_in_fileA = set()
with open(fileA, mode='r', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        names_in_fileA.add(row['name'])

# Read 'name' column from File B
names_in_fileB = set()
with open(fileB, mode='r', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        names_in_fileB.add(row['name'])

# Compute differences
names_in_A_not_in_B = names_in_fileA - names_in_fileB
names_in_B_not_in_A = names_in_fileB - names_in_fileA

# Print the results
print("Names in File A but not in File B:")
for name in names_in_A_not_in_B:
    print(name)

print("\nNames in File B but not in File A:")
for name in names_in_B_not_in_A:
    print(name)