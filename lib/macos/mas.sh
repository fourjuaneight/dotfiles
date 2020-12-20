#!/bin/sh

# macOS App Store Apps
echo "Sign into the Mac App Store"
read -s -p "Enter Password: " pswd
mas signin juan@villela.co "$pswd"

mas install 1107421413 # 1Blocker
mas install 1333542190 # 1Password
mas install 824171161 # Affinity Designer
mas install 411643860 # DaisyDisk
mas install 924726344 # Deliveries
mas install 1435957248 # Drafts
mas install 1493996622 # Front and Center
mas install 1081413713 # GIF Brewery
mas install 1474335294 # GoodLinks
mas install 1468691718 # Jayson
mas install 1457450145 # Octotree
mas install 403504866 # PCalc
mas install 1055273043 # PDF Expert
mas install 1503136033 # Service Station
mas install 1176895641 # Spark
mas install 425424353 # The Unarchiver
mas install 904280696 # Things
mas install 1289378661 # Twitterrific