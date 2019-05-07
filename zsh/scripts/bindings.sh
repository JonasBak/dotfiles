dot(){
  if [[ "$1" = "edit" || "$1" = "e" ]]; then
    cd $DOTFILES
    vim
  elif [[ "$1" = "add" ]] then
    echo export $2 >> $DOTFILES/local/var
    source $DOTFILES/local/var
    echo Added $2 to environment
  else
    cd $DOTFILES
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
