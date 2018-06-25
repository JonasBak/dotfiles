dot(){
  if [[ "$1" = "edit" || "$1" = "e" ]]; then
    cd $DOTFILES
    vim .
  elif [[ "$1" = "install" || "$1" = "i" ]]; then
    cd $DOTFILES
    git pull
    . ./install
  elif [[ "$1" = "update" || "$1" = "u" ]]; then
    . $DOTFILES/update
  else
    cd $DOTFILES
  fi
}
alias dot="dot"

alias c="~/code"

alias copy="xsel -ib"
