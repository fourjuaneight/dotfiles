# Dotfiles

Files and scripts for configuring a development and terminal enviromant on macOS or Linux.

---

## Installation
You can manually clone the repo and invoke the `Makefile`
```bash
$ git clone https://github.com/fourjuaneight/dotfiles.git
$ cd dotfiles
$ make
```

## Makefile

### `make`
* Installs [Homebrew](https://brew.sh) on both systems as there is a [Linux](http://linuxbrew.sh/) now as well.
* Installs [rvm](https://rvm.io/), [nvm](https://github.com/creationix/nvm), and several gems and npm packages for my particular needs.
* Updates macOS and configures preferred system defaults defined in [`/macos/default.sh`](macos/default.sh)
* Configures [chunkwm](https://github.com/koekeishiya/chunkwm) and [skhd](https://github.com/koekeishiya/skhd) to run at system startup
* Creates necessary symlinks via [GNU Stow](https://www.gnu.org/software/stow/)
* Runs [`/macos/duti/set.sh`](macos/duti/set.sh), which sets defaults handlers/programs for file extensions via [duti](http://duti.org).

### `make link`
* Symlinks only Bash and Vim configuration files to the home directory using `ln` commands. Useful for temporarily configuring a shared computer. Nothing new is installed to the machine, but files *may* be overwritten since the Makefile recipe passes the `-f` flag for every `ln` command.
* Run `make unlink` to remove these symlinks.

## How it Works

### Symlinks

All necessary symlinks ( [`.bash_profile`](bash/.bash_profile), [`.vimrc`](vim/.vimrc), among others) are managed with GNU Stow (installed with Homebrew). Files you wish to be symlinked to the home directory need to be placed in a folder within `~/dotfiles`. Using the `stow` command from the `~/dotfiles` directory will symlink the contents of the folder you choose (`/bash`, `/vim`, etc) to the grandparent directory, which is wherever the `/dotfiles` folder is contained.

Assuming you clone the dotfiles repository in your home directory, executing the commands:

```bash
$ cd dotfiles
$ stow bash
```
will symlink the contents of [`/bash`](bash) to the home directory.

You can use the `stow` command anytime you add a new file to a folder you wish to symlink directly to the home directory. This can all be done without Stow using the `ln -s` command, but I find GNU Stow with folder management to be cleaner and easier to maintain.

### Zsh
`.zshrc` includes all configurations, fzf` functions and alias. [Antigen-hs](https://github.com/Tarrasch/antigen-hs) is used in place of MyAntige. [Pure](https://github.com/sindresorhus/pure) is install via `npm` and integrated with `antigen-hs`.

### Vim
My vim plugin manager of choice is [Plug](https://github.com/junegunn/vim-plug). The `plu.vim` file is autoloaded and invokes the plugins in the `/vim/bundle` folder via a single line in my `.vimrc`:

```
call plug#begin()
```

Vim plugins are currently contained as git submodules, to keep the remote repository slimmer. The extraneous `git submodule init` and `git submodule update` commands are handled by the `Makefile`.

### Window Management
chunkwm and skhd are configured via `.chunkwmrc` and `.skhdrc` respectively. Both are located in the `/macos` folder and symlinked to the home directory with `stow macos`.