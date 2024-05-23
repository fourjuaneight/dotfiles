#!/usr/bin/env python3

import argparse
import datetime
import os

# Parse command line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Rename files in directoy by created date.")
    parser.add_argument('baseName', type=str, help='Base name for every file')
    return parser.parse_args()

def main():
    # Parse command line arguments
    args = parse_args()
    baseName = args.baseName
    # Get the current directory
    dir = os.getcwd()

    try:
        # Read all files in the current directory
        files = os.listdir(dir)
    except OSError as e:
        print("Error reading files in the current directory:", e)
        return

    # Loop over each file
    for file in files:
        file_path = os.path.join(dir, file)
        
        # Check if the file is not a directory and has a .mp4 extension
        if os.path.isfile(file_path) and file.endswith(".mp4"):
            try:
                # Get the creation time of the file
                created_time = datetime.datetime.fromtimestamp(os.path.getmtime(file_path))

                # Generate the new name with the ISO format of the created time
                new_name = baseName + "-" + created_time.strftime("%Y-%m-%d") + ".mp4"
                new_file_path = os.path.join(dir, new_name)

                # Rename the file
                os.rename(file_path, new_file_path)
                print(f"Renamed {file} to {new_name}")
            except OSError as e:
                print(f"Error renaming file {file} to {new_name}: {e}")

if __name__ == "__main__":
    main()