#!/usr/bin/env python3
from plexapi.server import PlexServer
import os

plex = PlexServer('http://127.0.0.1:32400', os.getenv('PLEX_TOKEN'))
os.makedirs("exported_playlists", exist_ok=True)

for playlist in plex.playlists():
    if playlist.playlistType != 'audio' or playlist.smart:
        continue
    path = os.path.join("exported_playlists", f"{playlist.title}.m3u")
    with open(path, "w", encoding="utf-8") as f:
        f.write("#EXTM3U\n")
        for track in playlist.items():
            file_path = track.media[0].parts[0].file
            dur = int(track.duration / 1000) if track.duration else -1
            artist = track.grandparentTitle or "Unknown"
            f.write(f"#EXTINF:{dur},{artist} - {track.title}\n")
            f.write(f"{file_path}\n")
    print(f"Exported: {playlist.title} ({playlist.leafCount} tracks)")