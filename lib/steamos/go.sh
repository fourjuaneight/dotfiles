#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's GO."

action "installing Golang Language Server"
go install github.com/erning/gorun@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.42.1
go install github.com/cweill/gotests/gotests
go install github.com/fatih/gomodifytags
go install github.com/josharian/impl
go install github.com/haya14busa/goplay/cmd/goplay
go install github.com/go-delve/delve/cmd/dlv
go install honnef.co/go/tools/cmd/staticcheck
go install golang.org/x/tools/gopls
