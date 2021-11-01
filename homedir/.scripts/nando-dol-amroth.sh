#!/bin/sh

touch ~/nando-dol-amroth.log || exit

rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Books s3:dol-amroth/Books
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Comics s3:dol-amroth/Comics
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Documents s3:dol-amroth/Documents
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Manga s3:dol-amroth/Manga
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Picture/Wallpapers s3:dol-amroth/Documents/Wallpapers
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Plex/Audiobooks s3:dol-amroth/Audiobooks
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Plex/Music s3:dol-amroth/Music
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/ROMs s3:dol-amroth/ROMs