#!/bin/sh

rclone copy --log-level INFO --ignore-existing  ~/Documents s3:dol-amroth/Documents
rclone copy --log-level INFO --ignore-existing  ~/Picture/Wallpapers s3:dol-amroth/Documents/Wallpapers