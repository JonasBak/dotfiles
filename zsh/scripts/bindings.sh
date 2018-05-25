dot(){
  if [[ "$1" = "edit" ]]; then
    vim $DOTFILES
  else
    cd $DOTFILES
  fi
}
alias dot="dot"

alias c="~/code"
