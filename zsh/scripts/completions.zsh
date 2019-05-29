# Highlight selected in completion list
zstyle ':completion:*' menu select

if [[ $commands[kubectl] && ! -f $DOTFILES/local/zsh_completions/_kubectl ]]; then
  kubectl completion zsh > $DOTFILES/local/zsh_completions/_kubectl
fi

if [[ ! -f $DOTFILES/local/zsh_completions/_docker ]]; then
  curl -fLo $DOTFILES/local/zsh_completions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
fi
