# dotfiles
>Current dotfiles, with configurations for `zsh`, `tmux`, `vim`, and a couple of scripts i use. Made to work plug-and-play on Fedora.


## Installation
Clone this repo where you'd like to install the dotfiles. Enter the directory and run `./install [options]`, where `[options]` are one or more of the choices listed by running just `./install.sh`,
run with `all` to install everything.

Note: if installed on anything other than Fedora, you have to change package manager used in the `install_if_needed` function in `setup_scripts/.utils.sh`. Some package names might have to be changed.

The following sections will explain what is installed gived the different options.

## local
When installed, the directory `local` will be created in the dotfiles folder, this folder is ignored by git and will hold everything that is specific to the current computer.

If everything is installed, this directory will contain:
* `git/` - directory where git repos used for config are cloned to
* `tags/` - directory where ctags and cscope files are placed
* `var` - file that holds environment variables
* `zsh` - file that can be used to add custom bindings and configurations

## zsh
Configuration of `zsh` that uses `oh-my-zsh` and plugins to get completion, syntax highlighting and autosuggestions, as well as some other features like a custom prompt.

Configurations are located in `zsh/zshrc`, and stuff like scripts and aliases are located in `zsh/scripts/`.

Note: Due to the long load time of the `kubectl` completion script, this is lazy loaded after the first time a `kubectl` command is run.

## tmux
Terminal multiplexer, uses some custom keybindings, and a custom status bar to display windows, current kubernetes context, number of docker containers running, and information about cpu and memory usage.

Configurations are located in `tmux/tmux.conf`, and helper functions (for the status bar) are located in `tmux/scripts/`.

## vim
`vim` config without too much plugins, uses ale for linting and fix on save, and nerdtree, fzf and tags (ctags and cscope) for navigation. It uses standard vim completion and omnifunc when pressing tab. It will automatically include tags if generated with `:Tagme` in vim, or `watch_tags` from `bin/`.

Configurations are located in `vim/vimrc`, and functions (helper functions, completion, and tags) are located in `vim/scripts/`.

## bin
Add the `bin/` directory to path, most notably `generate_tags`, that generates tags for your files, and places them in `local/local/tags/`. The tags are generated with universal-ctags and cscope. The `dot` command has some functionality like `dot update` which pulls the last version of the repo, `dot e` which opens vim in the dotfiles directory.

## Everything else

TODO

![image](https://user-images.githubusercontent.com/16608915/58178996-90121e80-7ca7-11e9-920f-a16de4afbcbb.png)
