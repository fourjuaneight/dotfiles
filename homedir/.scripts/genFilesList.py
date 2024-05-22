#!/usr/bin/env python3

import os
import sqlite3

# Database file
db_file = "files_list.db"

# Connect to SQLite database
conn = sqlite3.connect(db_file)
cursor = conn.cursor()

# Create table if not exists
cursor.execute("""
    CREATE TABLE IF NOT EXISTS files (
        name TEXT,
        path TEXT,
        size INTEGER
    )
""")

# Function to list files and insert or update in the database
def insert_or_update_file_info(file):
    file_name = os.path.basename(file)
    directory_path = os.path.dirname(os.path.realpath(file))
    file_size = os.path.getsize(file)

    # Check if the file already exists in the database
    cursor.execute("SELECT size FROM files WHERE path=? AND name=?", (directory_path, file_name))
    result = cursor.fetchone()
    
    if result:
        # If the file exists and its size has changed, update the existing entry
        if result[0] != file_size:
            cursor.execute("UPDATE files SET size=? WHERE path=? AND name=?", (file_size, directory_path, file_name))
            print(f"Updated {file_name} in database.")
    else:
        # If the file does not exist, insert a new entry
        cursor.execute("INSERT INTO files (name, path, size) VALUES (?, ?, ?)",
                       (file_name, directory_path, file_size))
        print(f"Inserted {file_name} into database.")

# Walk the directory and find files
for root, dirs, files in os.walk('.'):
    for file in files:
        if not file.endswith((".sha256", ".db")):
            file_path = os.path.join(root, file)
            insert_or_update_file_info(file_path)

# Commit changes and close the connection
conn.commit()
conn.close()

print("Database updated: {}".format(db_file))