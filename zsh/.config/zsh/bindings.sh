alias c="cd ~/code"

alias copy="xsel -ib"

alias dotf="cd $DOTFILES"

alias vdiff="vim -d"

cd_ls() {
  cd $@ && [[ "$(ls -1a | wc -l)" -le "28" ]] && ls -a1F
}
alias cd="cd_ls"

v() {
  session="$DOTFILES/local/vim_sessions/${PWD//\//.}"
  if [[ -f $session ]]; then
    vim -S $session
  else
    vim
  fi
}

find-and-edit() {
  file=""
  rg --hidden --follow --glob '!.git' --files | fzf --reverse --height 40% --prompt "> vim " | while read item; do
    file=$item
    break
  done
  if [[ -z "$file" ]]; then
    exit 1
  fi
  vim $file </dev/tty
  zle reset-prompt
}
zle -N find-and-edit
bindkey "^V" find-and-edit

if [[ -d $DOTFILES/local/zsh_plugins/zsh-history-substring-search ]]; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

bindkey "^[[3~" delete-char
bindkey "^?" backward-delete-char

zmodload zsh/complist # Needed for reverse-menu-complete binding
bindkey -M menuselect "^[[Z" reverse-menu-complete

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line
