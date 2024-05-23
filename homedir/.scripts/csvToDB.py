#!/usr/bin/env python3

import argparse
import csv
import sqlite3

# Parse command line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Convert CSV file to SQLite database.")
    parser.add_argument('dbFile', type=str, help='Database filename')
    parser.add_argument('csvFile', type=str, help='CSV filename')
    return parser.parse_args()

# Infer the SQLite type based on the Python type of the value
def infer_sqlite_type(value):
    try:
        int(value)
        return 'INTEGER'
    except ValueError:
        try:
            float(value)
            return 'REAL'
        except ValueError:
            return 'TEXT'

# Parse command line arguments
args = parse_args()
dbFile = args.dbFile
csvFile = args.csvFile

# Connect to SQLite database
conn = sqlite3.connect(dbFile)
cursor = conn.cursor()

# Read CSV file to get column names and types
with open(csvFile, newline='', encoding='utf-8') as csvfile:
    csv_reader = csv.reader(csvfile)
    headers = next(csv_reader)  # Get header row
    
    # Get first row of data to infer column types
    first_row = next(csv_reader)
    column_types = [infer_sqlite_type(value) for value in first_row]
    
    # Create table with the inferred schema
    columns = ', '.join(f"{header} {col_type}" for header, col_type in zip(headers, column_types))
    create_table_sql = f"CREATE TABLE IF NOT EXISTS files ({columns})"
    cursor.execute(create_table_sql)
    
    # Insert first row of data
    cursor.execute(f"INSERT INTO files ({', '.join(headers)}) VALUES ({', '.join(['?']*len(headers))})", first_row)

    # Insert remaining rows of data
    for row in csv_reader:
        cursor.execute(f"INSERT INTO files ({', '.join(headers)}) VALUES ({', '.join(['?']*len(headers))})", row)

# Commit changes and close the connection
conn.commit()
conn.close()

print("CSV data inserted into database: {}".format(dbFile))