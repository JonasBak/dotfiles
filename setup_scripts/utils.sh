install_if_needed() {
	type $1 >/dev/null 2>&1 || sudo dnf install $1
}

backup_config() {
  if [[ -f $1 ]] && [[ ! -f $1.old ]]; then
    cp $1 $1.old;
  fi
}

source_file() {
  echo "source $(DOTFILES)/$1" > $2
}

git_clone() {
  if [[ -d $2 ]]; then
    echo $1 already cloned;
  else
    git clone $1 $2;
  fi
}

