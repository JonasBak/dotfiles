SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/.local_dir.sh
source $SETUP_SCRIPTS/.utils.sh

echo "Installing and setting up zsh"
install_if_needed zsh

echo "Backing up old zshrc and installing new"
backup_config ~/.zshrc
source_file zsh/zshrc ~/.zshrc

echo "Setting up local variables"
if [[ ! -f "$DOTFILES/local/zsh" ]]; then
  echo "source $DOTFILES/local/var" > $DOTFILES/local/zsh
fi

echo "Cloning and setting up dependencies"
ZSH_PLUGINS=$DOTFILES/local/zsh_plugins
add_if_not_present "export ZSH_PLUGINS=$ZSH_PLUGINS" $DOTFILES/local/var
git_clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGINS/zsh-autosuggestions
git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting
git_clone https://github.com/zsh-users/zsh-completions.git $ZSH_PLUGINS/zsh-completions
git_clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_PLUGINS/zsh-history-substring-search

if [[ ! -d $DOTFILES/local/zsh_completions ]]; then
  mkdir $DOTFILES/local/zsh_completions
fi

if [[ $commands[kubectl] && ! -f $DOTFILES/local/zsh_completions/_kubectl ]]; then
  kubectl completion zsh > $DOTFILES/local/zsh_completions/_kubectl
fi

if [[ $commands[docker] && ! -f $DOTFILES/local/zsh_completions/_docker ]]; then
  curl -fLo $DOTFILES/local/zsh_completions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
fi

echo "Setting default shell to zsh"
CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$CURRENT_SHELL" != "zsh" ]; then
  install_if_needed util-linux-user
  chsh -s $(grep /zsh$ /etc/shells | tail -1)
fi
