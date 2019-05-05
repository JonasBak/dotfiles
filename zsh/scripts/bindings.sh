dot(){
  cd $DOTFILES
  if [[ "$1" = "edit" || "$1" = "e" ]]; then
    vim
  fi
}

alias c="~/code"

alias copy="xsel -ib"

boiler(){
  if [[ "$1" = "list" || "$1" = "ls" ]]; then
    ls $DOTFILES/boilerplate
  else
    cp -r $DOTFILES/boilerplate/$1 ./$2
    echo Started project $2 from template $1
    cd $2
    git init
  fi
}
