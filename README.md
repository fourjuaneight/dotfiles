# Dotfiles

Files and scripts for configuring a development and terminal enviromant on macOS or Linux.

---

## Installation

You can curl the install script and run `make`:

```bash
$ curl get.juanvillela.dev | sh
$ cd ~/dotfiles
$ make install
```

Or manually clone the repo:

```bash
$ git clone https://github.com/fourjuaneight/dotfiles.git
$ cd ~/dotfiles
$ make install
```

## Makefile

### `make install`

- Creates necessary symlinks via [Stow](https://www.gnu.org/software/stow/).
- Installs [Homebrew](https://brew.sh) on macOS and [Linuxbrew](http://linuxbrew.sh/) on Linux.
- Installs [rvm](https://rvm.io/) and [nvm](https://github.com/creationix/nvm).
- Installs `apt-get`, `brew`, and `brew cask` dependencies, relevant to each OS.
- Installs Mac App Store apps via [mas](https://github.com/mas-cli/mas).

> **Important:** After running `make install`, run `chsh -s $(which zsh)` to set zsh as the default
> shell. Then restart your terminal. The associated zshrc file will have all the
> necessary PATHs for the next step.

### `make setup`

- Installs npm, ruby, and pip packages.
- Installs [antigen-hs](https://github.com/Tarrasch/antigen-hs) for zsh package management.
- Installs [YCM](https://github.com/ycm-core/ycmd) for Vim code completion and snippets.
- Installs [Doom Emacs](https://github.com/hlissner/doom-emacs).
- Sets preferred system defaults defined in [`/macos/default.sh`](https://github.com/fourjuaneight/dotfiles/blob/master/macos/default.sh)
- Sets up [chunkwm](https://github.com/koekeishiya/chunkwm) and [skhd](https://github.com/koekeishiya/skhd) to run at system startup
- Runs `/macos/duti/set.sh`, which sets defaults handlers/programs for file extensions via [duti](http://duti.org).

## Customizing

Everything in here is setup to work for me. Which means you'd have to heavily
edit a lot of the files. I'd recommend making a fork of the repo and then
changing these things to your needs before installing.

Some config files you'd want to change:

- [Emacs](https://github.com/fourjuaneight/dotfiles/blob/master/emacs/.doom.d/config.el)
- [Git](https://github.com/fourjuaneight/dotfiles/blob/master/git/.gitconfig)
- [Backup Script](https://github.com/fourjuaneight/dotfiles/blob/master/scripts/backup.py)

## Thanks

This setup is possible thanks to some awesome developers that have
been doing this a lot longer (and better) than I have.

- [Darryl Abbate](https://github.com/rootbeersoup/dotfiles)'s dotfiles, which
  was the "inspiration" for most of this setup.
- [Lucas F. da
  Costa](https://lucasfcosta.com/2019/04/07/streams-introduction.html) for
  making love the terminal again.
- [Aaron Bieber](https://youtu.be/JWD1Fpdd4Pc) for turning onto Emacs and his
  great [dotfiles](https://github.com/aaronbieber/dotfiles).
- Henrik Lissner and his holy work on [Doom
  Emacs](https://github.com/hlissner/doom-emacs). This things allowed me to jump
  into Emacs within a day with little friction.
- Zaiste for his fantastic [Emacs DoomCasts](https://www.youtube.com/playlist?list=PLhXZp00uXBk4np17N39WvB80zgxlZfVwj).
- [Ryan Schmukler](https://github.com/rschmukler/doom.d)'s dotfiles, which led
  the way to my badass Doom Emacs setup.
- [Eric Wendelin](https://github.com/eriwen/dotfiles)'s macOS system setup
  script which makes life that much easier.
