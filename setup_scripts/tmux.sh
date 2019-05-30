SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.local_dir.sh
source $SETUP_SCRIPTS/.utils.sh

echo "Installing and setting up tmux"
install_if_needed tmux
echo "Linking config files"
backup_config ~/.tmux.conf
link_file tmux/tmux.conf ~/.tmux.conf
