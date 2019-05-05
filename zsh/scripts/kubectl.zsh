# Lazy load completion
if [ $commands[kubectl] ]; then
  kubectl() {
    unfunction kubectl
    source <(kubectl completion zsh)
    $0 "$@"
  }
fi
