SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.utils.sh

echo "Installing and setting up vim"
install_if_needed vim

echo "Backing up old vimrc and installing new"
backup_config ~/.vimrc
source_file vim/vimrc ~/.vimrc

echo "Installing plugins"
[[ ! -f ~/.vim/autoload/plug.vim ]] && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
install_if_needed the_silver_searcher
vim +PlugInstall +qall
