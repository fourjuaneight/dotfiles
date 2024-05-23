#!/usr/bin/env python3

import sqlite3
import csv

# Database file
db_file = "files_list.db"
# Output CSV file
csv_file = "files_list.csv"

# Connect to the SQLite database
conn = sqlite3.connect(db_file)
cursor = conn.cursor()

# Execute a query to fetch all data from the 'files' table
cursor.execute("SELECT name, path, size, disc FROM files")
rows = cursor.fetchall()

# Define the header for the CSV file
header = ["name", "path", "size", "disc"]

# Write the data to a CSV file
with open(csv_file, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    
    # Write the header
    csvwriter.writerow(header)
    
    # Write the data
    for row in rows:
        csvwriter.writerow(row)

# Close the database connection
conn.close()

print(f"Data from 'files' table has been written to {csv_file}")
