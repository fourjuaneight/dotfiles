# Dotfiles

Files and scripts for configuring a development and terminal enviromant on macOS and Linux.

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
- Installs [rvm](https://rvm.io/) and [nvm](https://github.com/creationix/nvm) for version management.
- Installs [Rust](https://www.rust-lang.org) from source.
- Installs `apt-get`, `brew`, and `brew cask` dependencies, relevant to each OS.

> **Important:** After running `make install`, run `chsh -s $(which zsh)` to set zsh as the default shell. Then restart your terminal. The associated zshrc file will have all the necessary PATHs for the next step.

### `make setup`

- Installs [nnn](https://github.com/jarun/nnn) for Linux cli file management.
- Installs [zplug](https://github.com/zplug/zplug) for zsh and [plug](https://github.com/zplug/zplug) for vim plugin management.
- Installs global npm, ruby, and pip packages.
- Installs Installs [rustup](https://github.com/rust-lang/rustup) nightly (with zsh completions) for tooling and version management.
- Installs Mac App Store apps via [mas](https://github.com/mas-cli/mas).
- Installs [Doom Emacs](https://github.com/hlissner/doom-emacs).
- Sets preferred system defaults defined in [`/macos/default.sh`](https://github.com/fourjuaneight/dotfiles/blob/master/macos/default.sh)
- Runs `/macos/duti/set.sh`, which sets defaults handlers/programs for file extensions via [duti](http://duti.org).

## Customizing

Everything in here is setup to work for me. Which means you'd have to heavily edit a lot of the files. I'd recommend making a fork of the repo and then changing these things to your needs before installing.

Some config files you'd want to change:

- [Emacs](https://github.com/fourjuaneight/dotfiles/blob/master/emacs/.doom.d/config.el)
- [Git](https://github.com/fourjuaneight/dotfiles/blob/master/git/.gitconfig)

## Thanks

This setup is possible thanks to some awesome developers that have
been doing this a lot longer (and better) than I have.

- [Darryl Abbate](https://github.com/rootbeersoup/dotfiles)'s dotfiles, which was the "inspiration" for most of this setup.
- [Lucas F. daCosta](https://lucasfcosta.com/2019/04/07/streams-introduction.html) for making me love the terminal again.
- [Aaron Bieber](https://youtu.be/JWD1Fpdd4Pc) for turning onto Emacs and his great [dotfiles](https://github.com/aaronbieber/dotfiles).
- Henrik Lissner and his amazing work on [Doom Emacs](https://github.com/hlissner/doom-emacs). This things allowed me to jump into Emacs within a day with little friction.
- Zaiste for his fantastic [Emacs DoomCasts](https://www.youtube.com/playlist?list=PLhXZp00uXBk4np17N39WvB80zgxlZfVwj).
- [Ryan Schmukler](https://github.com/rschmukler/doom.d)'s dotfiles, which led the way to my badass Doom Emacs setup.
- [Eric Wendelin](https://github.com/eriwen/dotfiles)'s macOS system setup script which makes life that much easier.
- [YADR](https://github.com/skwp/dotfiles)'s Docker config for containerize testing of this setup.
- [Adam Eivy](https://github.com/atomantic/dotfiles)'s install setup, which I've shamelessly copied to replace my sorry attempt at using Make.
