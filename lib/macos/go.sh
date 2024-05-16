#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's GO."

action "installing Golang Language Server"
/opt/homebrew/bin/go install github.com/erning/gorun@latest
/opt/homebrew/bin/go install github.com/nametake/golangci-lint-langserver@latest
/opt/homebrew/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.42.1
/opt/homebrew/bin/go install github.com/cweill/gotests/gotests
/opt/homebrew/bin/go install github.com/fatih/gomodifytags
/opt/homebrew/bin/go install github.com/josharian/impl
/opt/homebrew/bin/go install github.com/haya14busa/goplay/cmd/goplay
/opt/homebrew/bin/go install github.com/go-delve/delve/cmd/dlv
/opt/homebrew/bin/go install honnef.co/go/tools/cmd/staticcheck
/opt/homebrew/bin/go install golang.org/x/tools/gopls
