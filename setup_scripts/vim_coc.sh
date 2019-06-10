SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.local_dir.sh
source $SETUP_SCRIPTS/.utils.sh

if ! type vim > /dev/null 2>&1; then
  echo "vim needs to be installed before CoC"
  exit 1
fi

install_if_needed nodejs
if ! type yarn > /dev/null 2>&1; then
  sudo npm install -g yarn
fi

vim +PlugInstall +qall
vim +"CocInstall -sync coc-gocode coc-python coc-rls coc-tsserver rope" +qall
ln -b $DOTFILES/vim/lib/coc-settings.json ~/.vim/coc-settings.json
