alias c="cd ~/code"

alias copy="xsel -ib"

alias dotf="cd $DOTFILES"

alias vdiff="vim -d"

cd_ls() {
  cd $@ && [[ "$(ls -1a | wc -l)" -le "28" ]] && ls -a1F
}
alias cd="cd_ls"

v() {
  session="$DOTFILES/local/vim_sessions/${PWD//\//.}"
  if [[ -f $session ]]; then
    vim -S $session
  else
    vim
  fi
}

if [[ -d $ZSH_PLUGINS/zsh-history-substring-search ]]; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

bindkey "^[[3~" delete-char
bindkey "^?" backward-delete-char

zmodload zsh/complist # Needed for reverse-menu-complete binding
bindkey -M menuselect "^[[Z" reverse-menu-complete

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line
