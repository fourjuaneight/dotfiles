#!/usr/bin/env bash

# DOCS: https://macos-defaults.com

# set computer name
sudo scutil --set HostName "SpaceMaria"

# FINDER #

# always show hidden
defaults write com.apple.finder AppleShowAllFiles TRUE

# show exntensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool TRUE

# show path bar
defaults write com.apple.finder ShowPathbar -bool TRUE

# show status bar
defaults write com.apple.finder ShowStatusBar -bool TRUE

# keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool TRUE

# remove the delay when hovering the toolbar title
defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"

# list view as default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`, `Nlsv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
find /usr/local -name '.DS_Store' -type f -print -delete;
find /opt/homebrew/lib -name '.DS_Store' -type f -print -delete;

# restart
killall Finder


# DOCK #

# auto-hide
defaults write com.apple.dock autohide -bool TRUE

# no delay on auto-hide
defaults write com.apple.dock autohide-delay -float 0

# only show active apps
defaults write com.apple.dock static-only -bool TRUE

# suck minimizing apps
defaults write com.apple.dock mineffect suck

# default items size
defaults write com.apple.dock tilesize -int 50

# item magnification size
defaults write com.apple.dock largesize -int 100

# make hidden apps transparent
defaults write com.apple.Dock showhidden -bool TRUE

# set position to the right
defaults write com.apple.dock orientation right

# restart
killall Dock


# DISK UTILITY #

# no warning on "unsecurely" removing media
defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd;
