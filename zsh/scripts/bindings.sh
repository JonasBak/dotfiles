dot(){
  if [[ "$1" = "edit" || "$1" = "e" ]]; then
    cd $DOTFILES
    vim .
  else
    cd $DOTFILES
  fi
}
alias dot="dot"

alias c="~/code"

alias copy="xsel -ib"
