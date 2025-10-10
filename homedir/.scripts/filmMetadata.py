"""
TIFF Metadata Editor for Film Photography

This script edits EXIF metadata in TIFF files, adding date, location, 
and film type information from a JSON metadata file.
"""

import glob
import json
import os
from datetime import datetime
from pathlib import Path
from typing import Optional, Tuple, Dict, List

import piexif
from PIL import Image


FILM_TYPES = {
    "Gold_200": "Kodak Gold 200",
    "Portra_400": "Kodak Portra 400",
    "Portra_800": "Kodak Portra 800",
    "CineStill_800": "CineStill Film 800",
    "Silbersalz35_200T": "Silbersalz35 200T",
    "Silbersalz35_50D": "HP5 Plus 400",
    "Ilford_400": "Ilford HP5 Plus 400",
}

PROCESSING_DATA = {
    "json_path": "~/Documents/Photo_Projects/Film/Kodak_Gold_200-2024-08-07.json",
    "input_dir": "~/Documents/Photo_Projects/Film/2024-08-07-Kodak_Gold_200",
    "output_dir": "~/Documents/Photo_Projects/Film/Lossless",
    "film_type": FILM_TYPES["Gold_200"],
}


def _convert_to_deg(value: float, loc: List[str]) -> Tuple[Tuple, str]:
    """
    Convert decimal degrees to degrees, minutes, seconds format for GPS.

    Args:
        value: Decimal degree value
        loc: List of two location references [negative, positive] e.g., ["S", "N"]

    Returns:
        Tuple of ((degrees, minutes, seconds), location_reference)
    """
    loc_value = loc[0] if value < 0 else loc[1]
    abs_value = abs(value)
    deg = int(abs_value)
    t1 = (abs_value - deg) * 60
    min_val = int(t1)
    sec = round((t1 - min_val) * 60 * 100)
    return ((deg, 1), (min_val, 1), (sec, 100)), loc_value


def edit_tiff_metadata(
    input_path: str,
    output_path: str,
    date_time: Optional[str] = None,
    latitude: Optional[float] = None,
    longitude: Optional[float] = None,
    film_type: Optional[str] = None
) -> None:
    """
    Edit date and GPS location metadata in TIFF images.

    Args:
        input_path: Path to input TIFF file
        output_path: Path to output TIFF file
        date_time: datetime object or string in format "2025:10:10 14:30:00"
        latitude: Latitude as float (e.g., 40.7128)
        longitude: Longitude as float (e.g., -74.0060)
    """
    # Open the image
    img = Image.open(input_path)

    # Load existing EXIF data or create new
    try:
        exif_dict = piexif.load(img.info.get("exif", b""))
    except:
        exif_dict = {"0th": {}, "Exif": {}, "GPS": {}, "1st": {}}

    # Set date/time
    if date_time:
        if isinstance(date_time, datetime):
            date_str = date_time.strftime("%Y:%m:%d %H:%M:%S")
        else:
            date_str = date_time

        # Update date
        exif_dict["Exif"][piexif.ExifIFD.DateTimeOriginal] = date_str
        exif_dict["Exif"][piexif.ExifIFD.DateTimeDigitized] = date_str
        exif_dict["0th"][piexif.ImageIFD.DateTime] = date_str

    if film_type:
        comment = f'Film: {film_type}'
        description = f'Shot on {film_type}'

        # Add lens information
        exif_dict['Exif'][piexif.ExifIFD.LensModel] = b'Pentax MX 35mm SMC M 50mm F1.4'
        exif_dict['Exif'][piexif.ExifIFD.LensMake] = b'Pentax'

        # Add film type using UserComment or ImageDescription
        exif_dict['Exif'][piexif.ExifIFD.UserComment] = comment.encode('utf-8')
        exif_dict['0th'][piexif.ImageIFD.ImageDescription] = description.encode('utf-8')

    # Set GPS location
    if latitude is not None and longitude is not None:
        lat, lat_ref = _convert_to_deg(latitude, ["S", "N"])
        lon, lon_ref = _convert_to_deg(longitude, ["W", "E"])
        
        exif_dict["GPS"][piexif.GPSIFD.GPSLatitude] = lat
        exif_dict["GPS"][piexif.GPSIFD.GPSLatitudeRef] = lat_ref
        exif_dict["GPS"][piexif.GPSIFD.GPSLongitude] = lon
        exif_dict["GPS"][piexif.GPSIFD.GPSLongitudeRef] = lon_ref

    # Convert to bytes
    exif_bytes = piexif.dump(exif_dict)

    # Save with new EXIF data
    img.save(output_path, exif=exif_bytes)
    print(f"✓ Updated: {os.path.basename(input_path)}")


def parse_iso_date(iso_date_str: str) -> Optional[str]:
    """
    Convert ISO 8601 date string to EXIF format.

    Args:
        iso_date_str: ISO 8601 formatted date (e.g., "2024-08-07T18:34:26-04:00")

    Returns:
        String in EXIF format "YYYY:MM:DD HH:MM:SS"
    """
    try:
        # Parse ISO format
        dt = datetime.fromisoformat(iso_date_str)
        # Convert to EXIF format
        return dt.strftime("%Y:%m:%d %H:%M:%S")
    except Exception as e:
        print(f"Warning: Could not parse date '{iso_date_str}': {e}")
        return None


def parse_location_string(location_str: str) -> Tuple[Optional[float], Optional[float]]:
    """
    Parse location string into latitude and longitude.

    Args:
        location_str: String with comma-separated coordinates (e.g., "35.83099101594674,-78.56857014967036")

    Returns:
        Tuple of (latitude, longitude) as floats, or (None, None) if parsing fails
    """
    try:
        parts = location_str.split(',')
        if len(parts) == 2:
            latitude = float(parts[0].strip())
            longitude = float(parts[1].strip())
            return latitude, longitude
    except Exception as e:
        print(f"Warning: Could not parse location '{location_str}': {e}")

    return None, None


def load_metadata_from_json(json_path: str) -> List[Dict]:
    """
    Load metadata from JSON file.

    Args:
        json_path: Path to JSON file containing array of objects with 'location' and 'date'

    Returns:
        List of metadata dictionaries
    """
    json_path = os.path.expanduser(json_path)
    with open(json_path, 'r') as f:
        metadata = json.load(f)
    return metadata


def process_directory_with_json(
    json_path: str,
    input_dir: str,
    output_dir: Optional[str] = None,
    film_type: Optional[str] = None,
    sort_by: str = "name"
) -> None:
    """
    Process all TIFF files in a directory using metadata from JSON file.

    Args:
        input_dir: Directory containing TIFF files
        json_path: Path to JSON file with metadata array
        output_dir: Directory to save edited files (if None, creates 'edited' subdirectory)
        sort_by: How to sort files - "name" (alphabetical), "date" (modification time), or "size"
    """
    # Expand user paths
    input_dir = os.path.expanduser(input_dir)
    json_path = os.path.expanduser(json_path)
    
    # Create output directory if not specified
    if output_dir is None:
        output_dir = os.path.join(input_dir, "edited")
    else:
        output_dir = os.path.expanduser(output_dir)

    # Load metadata from JSON
    try:
        metadata_list = load_metadata_from_json(json_path)
        print(f"Loaded {len(metadata_list)} metadata entries from JSON")
    except Exception as e:
        print(f"Error loading JSON file: {e}")
        return

    # Find all TIFF files (case-insensitive)
    tiff_patterns = [
        os.path.join(input_dir, "*.tiff"),
        os.path.join(input_dir, "*.tif"),
        os.path.join(input_dir, "*.TIFF"),
        os.path.join(input_dir, "*.TIF")
    ]

    tiff_files = []
    for pattern in tiff_patterns:
        tiff_files.extend(glob.glob(pattern))

    if not tiff_files:
        print(f"No TIFF files found in {input_dir}")
        return

    # Sort files based on chosen method
    if sort_by == "name":
        tiff_files.sort()  # Alphabetical sorting
    elif sort_by == "date":
        tiff_files.sort(key=lambda x: os.path.getmtime(x))  # Sort by modification time
    elif sort_by == "size":
        tiff_files.sort(key=lambda x: os.path.getsize(x))  # Sort by file size

    print(f"Found {len(tiff_files)} TIFF file(s) (sorted by {sort_by})")
    print(f"Output directory: {output_dir}\n")

    # Check if counts match
    if len(tiff_files) != len(metadata_list):
        print(f"⚠ Warning: {len(tiff_files)} TIFF files but {len(metadata_list)} metadata entries")
        print(f"Will process minimum of both ({min(len(tiff_files), len(metadata_list))} files)\n")

    # Process each file with corresponding metadata
    success_count = 0
    for i, tiff_file in enumerate(tiff_files):
        if i >= len(metadata_list):
            print(f"⚠ No metadata for file {i+1}: {os.path.basename(tiff_file)} - skipping")
            continue

        try:
            # new name base on film_type + index
            new_filename = f"{film_type.replace(' ', '_')}-{i+1:03d}.tiff"
            filename = os.path.basename(tiff_file)
            output_path = os.path.join(output_dir, new_filename)

            # Get metadata for this index
            metadata = metadata_list[i]

            # Parse ISO date
            iso_date = metadata.get('date')
            date_time = parse_iso_date(iso_date) if iso_date else None

            # Parse location string
            location_str = metadata.get('location')
            latitude, longitude = parse_location_string(location_str) if location_str else (None, None)

            print(f"[{i+1}/{len(tiff_files)}] ", end="")
            edit_tiff_metadata(
                tiff_file,
                output_path,
                date_time=date_time,
                latitude=latitude,
                longitude=longitude,
                film_type=film_type
            )
            success_count += 1
        except Exception as e:
            print(f"✗ Error processing {filename}: {e}")

    print(f"\n{success_count}/{len(tiff_files)} files processed successfully")


if __name__ == "__main__":
    # Process with JSON metadata
    process_directory_with_json(
        json_path=PROCESSING_DATA["json_path"],
        input_dir=PROCESSING_DATA["input_dir"],
        output_dir=PROCESSING_DATA["output_dir"],
        film_type=PROCESSING_DATA["film_type"],
        sort_by="name",
    )