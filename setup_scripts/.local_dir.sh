if [[ -z $DOTFILES ]]; then
  echo "Dotfiles directory not set..."
  echo "Set with \"DOTFILES=... !!\""
  echo "Exiting..."
  exit 1
fi

if [[ ! -d $DOTFILES/local ]]; then
  mkdir $DOTFILES/local
  echo "export DOTFILES=$DOTFILES" > $DOTFILES/local/var
fi

