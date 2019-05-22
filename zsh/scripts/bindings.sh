unalias l

alias c="cd ~/code"

alias copy="xsel -ib"

alias dotf="cd $DOTFILES"

if [ $commands[l] ]; then
  cd_l() {
    cd $@
    [[ "$(ls -1a | wc -l)" -le "28" ]] && l
  }
  alias cd="cd_l"
fi
