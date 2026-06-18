#!/usr/bin/env python3
"""Batch-convert MP3 ID3 tags to v2.3 for macOS Spotlight compatibility."""

import os
import sys
from mutagen.mp3 import MP3


def convert(folder):
    for root, _, files in os.walk(folder):
        for f in files:
            if f.lower().endswith(".mp3"):
                path = os.path.join(root, f)
                try:
                    audio = MP3(path)
                    if audio.tags:
                        audio.tags.save(path, v2_version=3)
                        print("Converted:", path)
                    else:
                        print("No tags:", path)
                except Exception as e:
                    print(f"Error ({path}): {e}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 convert_id3.py /path/to/folder")
        sys.exit(1)
    folder = sys.argv[1]
    if not os.path.isdir(folder):
        print(f"Not a directory: {folder}")
        sys.exit(1)
    convert(folder)
