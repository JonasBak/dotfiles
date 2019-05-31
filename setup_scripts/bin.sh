SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.local_dir.sh
source $SETUP_SCRIPTS/.utils.sh

add_if_not_present "export PATH=\$DOTFILES/bin:\$PATH" $DOTFILES/local/var
