# dotfiles
>Current dotfiles, with configurations for `zsh`, `tmux`, `vim`, and a couple of scripts i use. Made to work plug-and-play on Fedora.

## Installation
Clone this repo where you'd like to install the dotfiles. Enter the directory and run `./install [options]`,
where `[options]` are one or more of the choices listed by running just `./install.sh`,
run with `all` to install everything.

Note: if installed on anything other than Fedora, you have to change package manager used in the `install_if_needed` function
in `setup_scripts/.utils.sh`. Some package names might have to be changed.


The following sections will explain what is installed gived the different options.

## local
When installed, the directory `local` will be created in the dotfiles folder, this folder is ignored by git and will hold
everything that is specific to the current computer.

If everything is installed, this directory will contain:
* `git/` - directory where git repos used for config are cloned to
* `tags/` - directory where ctags and cscope files are placed
* `var` - file that holds environment variables
* `zsh` - file that can be used to add custom bindings and configurations

## zsh
Configuration of ´zsh´ that uses `oh-my-zsh` and plugins to get completion, syntax highlighting and autosuggestions,
as well as some other features like a custom prompt.

Note: Due to the long load time of the `kubectl` completion script, this is lazy loaded after the first time a `kubectl` command is run.

## tmux
Terminal multiplexer, uses custom keybindings, and a custom status bar to display windows, current kubernetes context,
number of docker containers running, and information about cpu and memory usage.

## vim
`vim` config without too much plugins, uses ale for linting and fix on save, and nerdtree, fzf and tags (ctags and cscope)
for navigation. It includes a custom function for completion, and will automatically include tags generated with
the included functions (`:Tagme` in vim, or `watch_tags` from `bin/`, both give the same result).

## bin
TODO

## Everything else
TODO
