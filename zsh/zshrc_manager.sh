# Run tmux if exists
if command -v tmux>/dev/null; then
    [ -z $TMUX ] && exec tmux
  else 
    echo "tmux not installed. Run ./deploy to configure dependencies"
fi
export OMZ=~/.oh-my-zsh
export ZAS=~/.zsh-autosuggestions
source $DOTFILES/zsh/.zshrc
