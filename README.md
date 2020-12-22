# Dotfiles

Files and scripts for configuring a development and terminal enviromant on macOS and Linux.

---

## Installation

You can curl the install script and run `make`:

```bash
curl get.juanvillela.dev | sh
cd ~/dotfiles
./install.sh
```

Or manually clone the repo:

```bash
git clone https://github.com/fourjuaneight/dotfiles.git
cd ~/dotfiles
./install.sh
```

## Bootstrapping

### Installs

- [Homebrew](https://brew.sh) on macOS and [Linuxbrew](http://linuxbrew.sh/) on Linux.
- [nvm](https://github.com/creationix/nvm) for version management.
- [Rust](https://www.rust-lang.org).
- `apt-get`, `brew`, and `brew cask` dependencies, relevant to each OS.
- [nnn](https://github.com/jarun/nnn) for Linux cli file management.
- [zplug](https://github.com/zplug/zplug) for zsh and [plug](https://github.com/zplug/zplug) for vim plugin management.
- Global npm and pip packages.
- [rustup](https://github.com/rust-lang/rustup) nightly (with zsh completions) for tooling and version management.
- Mac App Store apps via [mas](https://github.com/mas-cli/mas).

### Setup

- Symlinks via [Stow](https://www.gnu.org/software/stow/).
- Defaults handlers/programs for file extensions via [duti](http://duti.org).

## Testing with Docker

We can use Docker to test some changes in a Linux Container.

Assuming your host system has Docker & Docker Compose properly installed, run:

```bash
docker-compose run dotfiles
```

This will build the container image if it never built it before (which may take a while -- future times will be faster) and then run a zsh session inside that container for you. There you can play around, test commands, aliases, etc.

Warning: this repo is primarily macOS oriented. So any support for Linux can only be done with the help of the community.

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
