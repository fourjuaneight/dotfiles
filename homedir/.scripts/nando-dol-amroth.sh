#!/bin/sh

touch ~/nando-dol-amroth.log || exit

rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Audiobooks b2:helms-deep/Media/Audiobooks
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Books b2:helms-deep/Media/Books
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Comics b2:helms-deep/Media/Comics
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Manga b2:helms-deep/Media/Manga
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log /mnt/Music b2:helms-deep/Media/Music
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Documents b2:helms-deep/Media/Documents
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Pictures/Library b2:helms-deep/Media/Photos
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/Pictures/Wallpapers b2:helms-deep/Media/Documents/Wallpapers
rclone copy --log-level INFO --ignore-existing --log-file ~/nando-dol-amroth.log ~/ROMs b2:helms-deep/Media/ROMs
