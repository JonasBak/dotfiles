alias c="cd ~/code"

alias copy="xsel -ib"

alias dotf="cd $DOTFILES"

if [ $commands[l] ]; then
  cd_l() {
    cd $@
    [[ "$(ls -1a | wc -l)" -le "28" ]] && l
  }
  alias cd="cd_l"
fi

if [[ -d $ZSH_PLUGINS/zsh-history-substring-search ]]; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

bindkey "^[[3~" delete-char
bindkey -M menuselect "^[[Z" reverse-menu-complete
