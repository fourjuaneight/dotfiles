#!/usr/bin/env bash

code=("aaron-bond.better-comments"
      "BriteSnow.vscode-toggle-quotes"
      "budparr.language-hugo-vscode"
      "bungcip.better-toml"
      "christian-kohler.npm-intellisense"
      "dbaeumer.vscode-eslint"
      "donjayamanne.githistory"
      "dracula-theme.theme-dracula"
      "dunstontc.viml"
      "eamodio.gitlens"
      "esbenp.prettier-vscode"
      "jpoissonnier.vscode-styled-components"
      "leizongmin.node-module-intellisense"
      "malmaud.tmux"
      "mattn.Lisp"
      "mechatroner.rainbow-csv"
      "ms-azuretools.vscode-docker"
      "ms-python.python"
      "ms-vscode-remote.remote-wsl"
      "ms-vscode.Go"
      "ms-vsliveshare.vsliveshare"
      "PKief.material-icon-theme"
      "Shan.code-settings-sync"
      "skyran.js-jsx-snippets"
      "TaodongWu.ejs-snippets"
      "VisualStudioExptTeam.vscodeintellicode")

for ext in "${code[@]}"
do
   code --install-extension "$ext"
done