# Highlight selected in completion list
zstyle ':completion:*' menu select

if [[ $commands[kubectl] && ! -f $DOTFILES/local/zsh_completions/_kubectl ]]; then
  kubectl completion zsh > $DOTFILES/local/zsh_completions/_kubectl
fi

if [[ ! -f $DOTFILES/local/zsh_completions/_docker ]]; then
  curl -fLo $DOTFILES/local/zsh_completions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
fi

if [[ -f $HOME/.zcompdump ]]; then
  last_comp_dump=$(date -r $HOME/.zcompdump +%s)
  current_time=$( date +%s )
  autoload -Uz compinit
  if (( last_comp_dump < (current_time-(60*60*24)) )); then
    autoload -Uz compdump
    compinit
    compdump
  else
    compinit -C
  fi
else
  autoload -Uz compinit
  compinit
fi
