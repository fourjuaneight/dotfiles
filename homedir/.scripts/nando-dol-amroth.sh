#!/bin/sh

rclone copy --log-level INFO --ignore-existing  ~/Books s3:dol-amroth/Books
rclone copy --log-level INFO --ignore-existing  ~/Comics s3:dol-amroth/Comics
rclone copy --log-level INFO --ignore-existing  ~/Documents s3:dol-amroth/Documents
rclone copy --log-level INFO --ignore-existing  ~/Manga s3:dol-amroth/Manga
rclone copy --log-level INFO --ignore-existing  ~/Picture/Wallpapers s3:dol-amroth/Documents/Wallpapers
rclone copy --log-level INFO --ignore-existing  ~/Plex/Audiobooks s3:dol-amroth/Audiobooks
rclone copy --log-level INFO --ignore-existing  ~/Plex/Music s3:dol-amroth/Music
rclone copy --log-level INFO --ignore-existing  ~/ROMs s3:dol-amroth/ROMs