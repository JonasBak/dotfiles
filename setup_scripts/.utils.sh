install_if_needed() {
  type $1 >/dev/null 2>&1 || sudo dnf install -y $1
}

backup_config() {
  # TODO backup with date
  if [[ -f $1 ]] && [[ ! -f $1.old ]]; then
    cp $1 $1.old
  fi
}

link_file() {
  local_file=$(echo $1 | cut -d "/" -f1)
  echo "source $DOTFILES/local/$local_file" > $2
  if [[ ! -f "$DOTFILES/local/$local_file" ]]; then
    if [[ ! -z $3 ]]; then
      echo $3 > $DOTFILES/local/$local_file
    fi
    echo "source $DOTFILES/$1" >> $DOTFILES/local/$local_file
  fi
}

git_clone() {
  if [[ ! -d "$2" ]]; then
    git clone $1 $2
  fi
}

add_if_not_present() {
  grep -Fxq "$1" "$2" || echo "$1" >> "$2"
}
