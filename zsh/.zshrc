export DOTFILES=$(dirname $(dirname $(readlink -nf ~/.zshrc)))

[[ -f $DOTFILES/local/var ]] && source $DOTFILES/local/var

if command -v tmux>/dev/null; then
    [ -z $TMUX ] && exec tmux
  else
    echo "tmux not installed, run 'make tmux' in $DOTFILES to install"
fi

# Settings
HISTFILE=~/.zsh_history
SAVEHIST=5000
setopt inc_append_history # To save every command before it is executed
setopt hist_ignore_all_dups
setopt share_history
setopt inc_append_history
setopt histignorespace

export EDITOR=vim
export VISUAL=vim

KEYTIMEOUT=1

# Vi mode
bindkey -v

# Plugins
source_plugin() {
  [[ -d $DOTFILES/local/zsh_plugins/$1 ]] && source $DOTFILES/local/zsh_plugins/$1/${2:-$1.plugin.zsh}
}

source_plugin zsh-autosuggestions
source_plugin zsh-syntax-highlighting
source_plugin zsh-completions
source_plugin zsh-history-substring-search

export fpath=($DOTFILES/local/zsh_plugins/zsh-completions/src $DOTFILES/local/zsh_completions $fpath)

source ~/.config/zsh/bindings.sh
source ~/.config/zsh/completions.zsh
source ~/.config/zsh/prompt.zsh

[[ ! -f /usr/share/fzf/shell/key-bindings.zsh ]] || source /usr/share/fzf/shell/key-bindings.zsh
