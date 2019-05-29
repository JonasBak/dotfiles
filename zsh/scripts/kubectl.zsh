if [[ $commands[kubectl] && ! -f $DOTFILES/local/zsh_completions/_kubectl ]]; then
  kubectl completion zsh > $DOTFILES/local/zsh_completions/_kubectl
fi
