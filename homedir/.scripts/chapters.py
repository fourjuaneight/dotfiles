#!/usr/bin/env python3
"""
Audio Chapter Extractor

This script extracts chapters from audio files (mp3, m4b) and converts them
to individual MP3 files with proper metadata using ffmpeg and id3v2.

Usage: python chapters.py <audio_file>
"""

import os
import re
import subprocess
import json
import sys
import argparse
from pathlib import Path
from typing import List, Optional

# Class Definitions
class ChapterData:
    """Represents a single chapter with its metadata."""
    
    def __init__(self, id: int, time_base: str, start: int, start_time: str, 
                 end: int, end_time: str, title: str):
        self.id = id
        self.time_base = time_base
        self.start = start
        self.start_time = start_time
        self.end = end
        self.end_time = end_time
        self.title = title

    def __repr__(self) -> str:
        return f"ChapterData(id={self.id}, title='{self.title}', start={self.start}, end={self.end})"


class ChapterCollection:
    """Container for multiple chapters."""
    
    def __init__(self, chapters: List[ChapterData]):
        self.chapters = chapters
    
    def __len__(self) -> int:
        return len(self.chapters)
    
    def __iter__(self):
        return iter(self.chapters)

# Utility Functions
def validate_file_exists(file_path: str) -> bool:
    """Check if file exists and is readable."""
    path = Path(file_path)
    return path.exists() and path.is_file()


def ms_to_time_string(ms: int) -> str:
    """Convert milliseconds to formatted time string (HH:MM:SS.mmm)."""
    seconds = ms // 1000
    milliseconds = ms % 1000
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    remaining_seconds = seconds % 60

    return f"{hours:02d}:{minutes:02d}:{remaining_seconds:02d}.{milliseconds:03d}"


def remove_file_extension(filename: str) -> str:
    """Remove audio file extension (mp3 or m4b) from filename."""
    return re.sub(r"(.*)\.(mp3|m4b)$", r"\1", filename)


def sanitize_filename(filename: str) -> str:
    """Sanitize filename by removing/replacing problematic characters."""
    # Replace problematic characters with underscores
    sanitized = re.sub(r'[<>:"/\\|?*]', '_', filename)
    # Remove extra whitespace and leading/trailing dots
    sanitized = re.sub(r'\s+', ' ', sanitized).strip('. ')
    return sanitized

# Handle subprocess outputs
def run_command(cmd: List[str], operation: str) -> str:
    """Execute a command and handle its output properly."""
    try:
        result = subprocess.run(
            cmd, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True, 
            check=True
        )
        if result.stdout.strip():
            print(result.stdout.strip())
        return result.stdout
    except subprocess.CalledProcessError as e:
        error_msg = f"[{operation}]: Command failed: {' '.join(cmd)}"
        if e.stderr:
            error_msg += f"\nError: {e.stderr.strip()}"
        print(error_msg, file=sys.stderr)
        raise e
    except FileNotFoundError:
        error_msg = f"[{operation}]: Command not found: {cmd[0]}. Please ensure it's installed."
        print(error_msg, file=sys.stderr)
        raise


def extract_chapters(file_path: str) -> ChapterCollection:
    """Extract chapter information from audio file using ffprobe."""
    if not validate_file_exists(file_path):
        raise FileNotFoundError(f"Audio file not found: {file_path}")
    
    ffprobe_cmd = [
        "ffprobe", "-v", "quiet", "-print_format", "json", 
        "-show_format", "-show_chapters", file_path
    ]
    
    try:
        result = subprocess.run(
            ffprobe_cmd, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True, 
            check=True
        )
        
        chapter_data = json.loads(result.stdout)
        
        if 'chapters' not in chapter_data or not chapter_data['chapters']:
            raise ValueError("No chapters found in the audio file")
        
        chapters = []
        for ch in chapter_data['chapters']:
            # Handle missing title tag gracefully
            title = ch.get('tags', {}).get('title', f"Chapter {int(ch['id']) + 1}")
            
            chapters.append(ChapterData(
                id=int(ch['id']),
                time_base=ch['time_base'],
                start=int(ch['start']),
                start_time=ch['start_time'],
                end=int(ch['end']),
                end_time=ch['end_time'],
                title=title
            ))

        return ChapterCollection(chapters)
        
    except json.JSONDecodeError as e:
        raise ValueError(f"Failed to parse ffprobe output: {e}")
    except KeyError as e:
        raise ValueError(f"Unexpected ffprobe output format: missing {e}")
    except subprocess.CalledProcessError as e:
        error_msg = f"ffprobe failed: {e.stderr if e.stderr else 'Unknown error'}"
        raise RuntimeError(error_msg)

# Execute ffmpeg to convert chapters to individual mp3 files
def convert_chapter_to_mp3(file_path: str, output_name: str, chapter: ChapterData, 
                          overwrite: bool = False) -> bool:
    """Convert a single chapter to MP3 file using ffmpeg."""
    start = ms_to_time_string(chapter.start)
    end = ms_to_time_string(chapter.end)
    
    # Sanitize the chapter title for filename
    safe_title = sanitize_filename(chapter.title)
    output_file = f"{output_name}-{chapter.id + 1:02d}-{safe_title[:50]}.mp3"

    cmd = [
        "ffmpeg",
        "-i", file_path,
        "-ss", start,
        "-to", end,
        "-acodec", "libmp3lame",
        "-ar", "22050",
        "-ab", "64k",
        "-metadata", f'title={chapter.title}',
        "-metadata", f'track={chapter.id + 1}',
        "-max_muxing_queue_size", "9999",
    ]
    
    if not overwrite:
        cmd.append("-n")  # Don't overwrite existing files
    
    cmd.append(output_file)

    if not overwrite and validate_file_exists(output_file):
        print(f"[ffmpeg]: {output_file} already exists, skipping.")
        return False
    else:
        print(f"[ffmpeg]: Converting chapter {chapter.id + 1}: '{chapter.title}' "
              f"from {start} to {end}...")
        try:
            run_command(cmd, "ffmpeg")
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False


def tag_mp3_file(output_name: str, chapter: ChapterData) -> bool:
    """Tag MP3 file with chapter metadata using id3v2."""
    safe_title = sanitize_filename(chapter.title)
    file_path = f"{output_name}-{chapter.id + 1:02d}-{safe_title[:50]}.mp3"
    
    if not validate_file_exists(file_path):
        print(f"[id3v2]: File {file_path} not found, skipping tagging.")
        return False
    
    print(f"[id3v2]: Tagging {file_path}...")

    cmd = ["id3v2", "--song", chapter.title, "--track", str(chapter.id + 1), file_path]
    try:
        run_command(cmd, "id3v2")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print(f"[id3v2]: Warning - Failed to tag {file_path}. id3v2 may not be available.")
        return False

def parse_arguments() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="Extract chapters from audio files and convert to individual MP3s",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s audiobook.m4b
  %(prog)s --overwrite audiobook.mp3
  %(prog)s --no-tagging audiobook.m4b
        """
    )
    
    parser.add_argument(
        "file",
        help="Audio file to process (mp3, m4b, etc.)"
    )
    
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing output files"
    )
    
    parser.add_argument(
        "--no-tagging",
        action="store_true",
        help="Skip ID3 tagging (useful if id3v2 is not available)"
    )
    
    return parser.parse_args()


def main():
    """Main function to process audio file and extract chapters."""
    try:
        args = parse_arguments()
        
        # Validate input file
        if not validate_file_exists(args.file):
            print(f"Error: File '{args.file}' not found or not accessible.", file=sys.stderr)
            sys.exit(1)
        
        # Get base name for output files
        output_name = remove_file_extension(args.file)
        
        # Extract chapter information
        print(f"Extracting chapters from: {args.file}")
        try:
            chapter_collection = extract_chapters(args.file)
            print(f"Found {len(chapter_collection)} chapters")
        except (FileNotFoundError, ValueError, RuntimeError) as e:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)

        # Process each chapter
        success_count = 0
        for i, chapter in enumerate(chapter_collection, 1):
            print(f"\nProcessing chapter {i}/{len(chapter_collection)}: {chapter.title}")
            
            # Convert chapter to MP3
            if convert_chapter_to_mp3(args.file, output_name, chapter, args.overwrite):
                success_count += 1
                
                # Tag the file if requested and conversion was successful
                if not args.no_tagging:
                    tag_mp3_file(output_name, chapter)
            else:
                print(f"Warning: Failed to convert chapter {i}")
        
        # Summary
        print(f"\nCompleted: {success_count}/{len(chapter_collection)} chapters processed successfully")
        if success_count < len(chapter_collection):
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()