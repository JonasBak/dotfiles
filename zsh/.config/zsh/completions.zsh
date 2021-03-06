# Highlight selected in completion list
zstyle ':completion:*' menu select

# Only redo completion cache once per day
autoload -Uz compinit
if [[ -f $HOME/.zcompdump ]]; then
  last_comp_dump=$(date -r $HOME/.zcompdump +%s)
  current_time=$( date +%s )
  if (( last_comp_dump < (current_time-(60*60*24)) )); then
    autoload -Uz compdump
    compinit
    compdump
  else
    compinit -C
  fi
else
  compinit
fi
