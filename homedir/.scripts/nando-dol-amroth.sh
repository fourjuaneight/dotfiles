#!/bin/sh

touch ~/nando-dol-amroth.log || exit

rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Books s3:dol-amroth/Books
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Comics s3:dol-amroth/Comics
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Documents s3:dol-amroth/Documents
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Manga s3:dol-amroth/Manga
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Pictures/Wallpapers s3:dol-amroth/Documents/Wallpapers
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Pictures/Library s3:dol-amroth/Photos
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Audiobooks s3:dol-amroth/Audiobooks
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Music s3:dol-amroth/Music
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/ROMs s3:dol-amroth/ROMs
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Anime s3:dol-amroth/Anime
