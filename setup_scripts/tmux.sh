SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.local_dir.sh
source $SETUP_SCRIPTS/.utils.sh

echo "Installing and setting up tmux"
install_if_needed tmux
echo "Backing up old tmux.conf and installing new"
backup_config ~/.tmux.conf
source_file tmux/tmux.conf ~/.tmux.conf
