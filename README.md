# Dotfiles

Files and scripts for configuring a development and terminal enviromant on macOS and Linux. Which _should_ also work with [Codespaces](https://github.com/features/codespaces). Don't @ me.

---

All of these are set up for **my** computers. Install at your own risk.

## Install

Manually clone the repo:

```bash
git clone https://github.com/fourjuaneight/dotfiles.git
cd ~/dotfiles
```

## Bootstrapping

There is no single install script. Everyone system has it's quirks, so it's best to install things in batches. All bootstraping scripts are in the `bash lib` directory. Some subfolders are OS specific, others are software specific. Here's my recomemded install approach:

```sh
bash lib/git/ssh.sh
bash lib/git/gpg.sh
bash lib/git/config.sh
# macOS  #
bash lib/macos/brew.sh
bash lib/macos/mas.sh
# Ubuntu #
bash lib/macos/apt.sh
bash lib/macos/brew.sh
##########
bash lib/rust/config.sh
bash lib/rust/cargo.sh
bash lib/go.sh
bash lib/node.sh
bash lib/python.sh
bash lib/fonts.sh
bash lib/docker.sh
bash lib/wrap-up.sh
# macOS  #
bash lib/macos/duti/set.sh
bash lib/macos/defaults.sh
##########
```

### Installs

- [Homebrew](https://brew.sh) on macOS and [Linuxbrew](http://linuxbrew.sh/) on Linux.
- [nvm](https://github.com/creationix/nvm) for version management.
- [Rust](https://www.rust-lang.org).
- `apt-get`, `brew`, and `brew cask` dependencies, relevant to each OS.
- [sheldon](https://github.com/rossmacarthur/sheldon) for zsh and [plug](https://github.com/zplug/zplug) for vim plugin management.
- [rustup](https://github.com/rust-lang/rustup) nightly (with zsh completions) for tooling and version management.
- Global npm and pip packages. Some Rust binaries.

### Setup

- Symlinks via [Stow](https://www.gnu.org/software/stow/).
- Defaults handlers/programs for file extensions via [duti](http://duti.org).

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
