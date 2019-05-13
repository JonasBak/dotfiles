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
echo "BIN"
source $SETUP_SCRIPTS/bin.sh
echo "TMUX"
source $SETUP_SCRIPTS/tmux.sh
echo "VIM"
source $SETUP_SCRIPTS/vim.sh
echo "TOOLS"
source $SETUP_SCRIPTS/tools.sh
echo "FONT"
source $SETUP_SCRIPTS/font.sh
echo "PREFERENCES"
source $SETUP_SCRIPTS/preferences.sh
