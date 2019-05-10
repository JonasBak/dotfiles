if [[ -z $DOTFILES ]]; then
  echo "Dotfiles directory not set..."
  echo "Set with \"DOTFILES=... !!\""
  echo "Exiting..."
  exit 1
fi

SETUP_SCRIPTS=$DOTFILES/setup_scripts

echo "Installing all features"
echo "ZSH"
source $SETUP_SCRIPTS/zsh.sh
echo "TMUX"
source $SETUP_SCRIPTS/tmux.sh
echo "VIM"
source $SETUP_SCRIPTS/vim.sh
echo "FONT"
source $SETUP_SCRIPTS/font.sh
echo "COLORS"
source $SETUP_SCRIPTS/colors.sh
