#!/usr/bin/env python3
from plexapi.server import PlexServer
from PIL import Image
from io import BytesIO
import os
import requests


PLEX_URL = 'http://127.0.0.1:32400'
PLEX_TOKEN = os.getenv('PLEX_TOKEN')
JELLYFIN_URL = os.getenv("JELLYFIN_URL")
JELLYFIN_TOKEN = os.getenv("JELLYFIN_API_KEY")
JELLYFIN_USER_ID = os.getenv("JELLYFIN_USER_ID")

# Build Jellyfin artist lookup: {name_lower: item_id}
resp = requests.get(
    f'{JELLYFIN_URL}/Artists/AlbumArtists',
    params={'Limit': 10000, 'UserId': JELLYFIN_USER_ID},
    headers={'X-Emby-Token': JELLYFIN_TOKEN},
)
if not resp.ok:
    print(f"Status: {resp.status_code}")
    print(f"Body: {resp.text}")
    raise SystemExit(1)
jellyfin_artists = {item['Name'].lower(): item['Id'] for item in resp.json()['Items']}
print(f"Loaded {len(jellyfin_artists)} Jellyfin artists\n")

import base64

plex = PlexServer(PLEX_URL, PLEX_TOKEN)
music = plex.library.section('Music')
artists = music.all(libtype='artist')

# Find first matched artist with a thumb for diagnostics
for artist in sorted(artists, key=lambda a: a.title.lower()):
    if not artist.thumb:
        continue
    jellyfin_id = jellyfin_artists.get(artist.title.lower())
    if jellyfin_id:
        break

print(f"Testing with: {artist.title}  (Jellyfin ID: {jellyfin_id})")

# 1. Confirm the item exists
item = requests.get(
    f'{JELLYFIN_URL}/Items/{jellyfin_id}',
    params={'UserId': JELLYFIN_USER_ID},
    headers={'X-Emby-Token': JELLYFIN_TOKEN},
)
print(f"GET /Items/{jellyfin_id}: {item.status_code}")
if item.ok:
    data = item.json()
    print(f"  Type={data.get('Type')}  Name={data.get('Name')}")

# 2. Fetch and convert image
img_resp = plex._session.get(plex.url(artist.thumb, includeToken=True))
buf = BytesIO()
Image.open(BytesIO(img_resp.content)).convert('RGB').save(buf, format='JPEG', quality=95)
jpeg_bytes = buf.getvalue()
print(f"Image size: {len(jpeg_bytes)} bytes")

# 3a. Try raw bytes
upload = requests.post(
    f'{JELLYFIN_URL}/Items/{jellyfin_id}/Images/Primary',
    data=jpeg_bytes,
    headers={'X-Emby-Token': JELLYFIN_TOKEN, 'Content-Type': 'image/jpeg'},
)
print(f"POST raw:    {upload.status_code}  {upload.text[:200]}")

# 3b. Try base64-encoded body
upload_b64 = requests.post(
    f'{JELLYFIN_URL}/Items/{jellyfin_id}/Images/Primary',
    data=base64.b64encode(jpeg_bytes),
    headers={'X-Emby-Token': JELLYFIN_TOKEN, 'Content-Type': 'image/jpeg'},
)
print(f"POST base64: {upload_b64.status_code}  {upload_b64.text[:200]}")