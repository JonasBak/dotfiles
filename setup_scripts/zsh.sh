SETUP_SCRIPTS=$DOTFILES/setup_scripts

source SETUP_SCRIPTS/local_dir.sh
source SETUP_SCRIPTS/utils.sh

echo "Installing and setting up zsh"
install_if_needed zsh

echo "Backing up old zshrc and installing new"
backup_config ~/.zshrc
source_file zsh/zshrc ~/.zshrc

echo "Setting up local variables"
sed -i '1isource $DOTFILES/local/zsh' ~/.zshrc

if [[ -f "$DOTFILES/local/zsh" ]]; then
  echo "source $DOTFILES/local/var" > $DOTFILES/local/zsh
fi

echo "Cloning and setting up dependencies"
ZSH=$DOTFILES/local/git/oh-my-zsh
ZAS=$ZSH/custom/plugins
ZAH=$ZSH/custom/plugins
echo "export ZSH=$ZSH" >> $DOTFILES/local/var
git_clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH
git_clone https://github.com/zsh-users/zsh-autosuggestions.git $ZAS
git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZAH

echo "Setting default shell to zsh"
CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$CURRENT_SHELL" != "zsh" ]; then
  if hash chsh >/dev/null 2>&1; then
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
  else
    printf "Couln't set zsh as default shell, evertyhing else is good"
    exit 1
  fi
fi

echo "Finished!"
