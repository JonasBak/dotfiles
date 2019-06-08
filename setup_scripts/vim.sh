SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.local_dir.sh
source $SETUP_SCRIPTS/.utils.sh

echo "Installing and setting up vim"
install_if_needed vim

echo "Linking config files"
backup_config ~/.vimrc
link_file vim/vimrc ~/.vimrc

echo "Installing plugins"
[[ ! -f ~/.vim/autoload/plug.vim ]] && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
install_if_needed the_silver_searcher
vim +PlugInstall +qall
ln -b $DOTFILES/vim/lib/coc-settings.json ~/.vim/coc-settings.json
ln -b $DOTFILES/vim/lib/package.json ~/.config/coc/extensions/package.json
vim +CocUpdateSync +qall

if [[ ! -d $DOTFILES/local/tags ]]; then
  mkdir $DOTFILES/local/tags
fi
