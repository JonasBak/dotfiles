dot(){
  if [[ "$1" = "edit" ]]; then
    cd $DOTFILES
    vim .
  else
    cd $DOTFILES
  fi
}
alias dot="dot"

alias c="~/code"
