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

uploaded = skipped = unmatched = 0

for artist in sorted(artists, key=lambda a: a.title.lower()):
    if not artist.thumb:
        print(f"[no poster]  {artist.title}")
        skipped += 1
        continue

    jellyfin_id = jellyfin_artists.get(artist.title.lower())
    if not jellyfin_id:
        print(f"[no match]   {artist.title}")
        unmatched += 1
        continue

    img_resp = plex._session.get(plex.url(artist.thumb, includeToken=True))
    buf = BytesIO()
    Image.open(BytesIO(img_resp.content)).convert('RGB').save(buf, format='JPEG', quality=95)
    upload = requests.post(
        f'{JELLYFIN_URL}/Items/{jellyfin_id}/Images/Primary',
        data=base64.b64encode(buf.getvalue()),
        headers={'X-Emby-Token': JELLYFIN_TOKEN, 'Content-Type': 'image/jpeg'},
    )
    if upload.ok:
        print(f"[uploaded]   {artist.title}")
        uploaded += 1
    else:
        print(f"[failed {upload.status_code}]  {artist.title}: {upload.text}")
        skipped += 1

print(f"\nDone. uploaded={uploaded}  unmatched={unmatched}  skipped={skipped}")