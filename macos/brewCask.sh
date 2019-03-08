# Brew Cask Packages
echo "Installing cask apps..."
CASKS=(
    alfred
    bartender
    dropbox
    firefox
    google-chrome
    gpgtools
    haskell-platform
    hazel
    hyper
    iterm2
    keyboard-maestro
    mattermost
    skype
    slack
    the-unarchiver
    tower
    transmit
    tunnelblick
    upwork
    visual-studio-code
    vlc
)
brew cask install ${CASKS[@]}

# Brew Cask Fonts Packages
echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-fira-code
    font-inconsolidata
    font-roboto
    font-clear-sans
)
brew cask install ${FONTS[@]}

echo "Cleaning up..."
brew cleanup