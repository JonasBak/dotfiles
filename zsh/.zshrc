# Vars
	HISTFILE=~/.zsh_history
	SAVEHIST=1000 
	setopt inc_append_history # To save every command before it is executed 
	setopt share_history # setopt inc_append_history

# Settings
	export VISUAL=vim

stty -ixon

source $OMZ/lib/history.zsh
source $OMZ/lib/key-bindings.zsh
source $OMZ/lib/completion.zsh
source $ZAS/zsh-autosuggestions.zsh

# Fix for arrow-key searching
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

source $DOTFILES/zsh/scripts/prompt.sh
source $DOTFILES/zsh/scripts/fixls.zsh
source $DOTFILES/zsh/scripts/bindings.sh

