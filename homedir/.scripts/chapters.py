#!/usr/bin/env python3

import os
import re
import subprocess
import json
import sys
from collections import namedtuple

# Class Definitions
class ChapterData:
    def __init__(self, id, time_base, start, start_time, end, end_time, title):
        self.id = id
        self.time_base = time_base
        self.start = start
        self.start_time = start_time
        self.end = end
        self.end_time = end_time
        self.title = title

class Chapter:
    def __init__(self, chapters):
        self.chapters = chapters

# Check if file exists
def exists_sync(path):
    return os.path.exists(path)

# Convert milliseconds to formatted time string
def sec_to_time(ms):
    seconds = ms // 1000
    milliseconds = ms % 1000
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    remaining_seconds = seconds % 60

    return f"{hours:02d}:{minutes:02d}:{remaining_seconds:02d}.{milliseconds:03d}"

# Remove file extension (mp3 or m4b)
def remove_file_extension(filename):
    return re.sub(r"(.*)\.(mp3|m4b)$", r"\1", filename)

# Handle subprocess outputs
def handle_output(proc, method):
    try:
        result = subprocess.run(proc, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"[{method}]: {e.stderr}", file=sys.stderr)
        raise e

# Get chapter information using ffprobe
def chapters(file):
    ffprobe_cmd = ["ffprobe", "-v", "quiet", "-print_format", "json", "-show_format", "-show_chapters", file]
    result = subprocess.run(ffprobe_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
    
    chapter_data = json.loads(result.stdout)
    chapters = []
    for ch in chapter_data['chapters']:
        chapters.append(ChapterData(
            id=int(ch['id']),
            time_base=ch['time_base'],
            start=int(ch['start']),
            start_time=ch['start_time'],
            end=int(ch['end']),
            end_time=ch['end_time'],
            title=ch['tags']['title']
        ))

    return Chapter(chapters)

# Execute ffmpeg to convert chapters to individual mp3 files
def ffmpeg(file, name, metadata):
    start = sec_to_time(metadata.start)
    end = sec_to_time(metadata.end)
    output = f"{name}-{metadata.id + 1}.mp3"

    cmd = [
        "ffmpeg",
        "-i", file,
        "-ss", start,
        "-to", end,
        "-acodec", "libmp3lame",
        "-ar", "22050",
        "-ab", "64k",
        "-metadata", f'track="{metadata.title}"',
        "-max_muxing_queue_size", "9999",
        output
    ]

    if exists_sync(output):
        print(f"[ffmpeg]: {output} already exists.")
    else:
        print(f"[ffmpeg]: Converting {output} from {start} to {end}...")
        handle_output(cmd, "ffmpeg")

# Use id3v2 to tag mp3 files with chapter titles
def id3v2(name, metadata):
    file = f"{name}-{metadata.id + 1}.mp3"
    print(f"[id3v2]: Renaming {file}...")

    cmd = ["id3v2", "--song", f"\"{metadata.title}\"", file]
    handle_output(cmd, "id3v2")

def main():
    if len(sys.argv) < 2:
        print("Please provide a file name as an argument.")
        sys.exit(1)

    file = sys.argv[1]
    name = remove_file_extension(file)
    try:
        chapters_obj = chapters(file)
    except Exception as e:
        print(e)
        sys.exit(1)

    for chapter in chapters_obj.chapters:
        ffmpeg(file, name, chapter)
        id3v2(name, chapter)

if __name__ == "__main__":
    main()