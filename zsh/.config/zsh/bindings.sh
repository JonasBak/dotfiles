alias dotf="cd $DOTFILES"

cd_ls() {
  cd $@ && [[ "$(ls -1a | wc -l)" -le "28" ]] && ls -a1F || true
}
alias cd="cd_ls"

find-and-edit() {
  file=""
  rg --hidden --follow --glob '!.git' --files | fzf --reverse --height 40% --prompt "> vim " | while read item; do
    file=$item
    break
  done
  if [[ -z "$file" ]]; then
    zle reset-prompt
    return 1
  fi
  LBUFFER="vim ${file}"
  zle reset-prompt
  return 0
}
zle -N find-and-edit
bindkey "^V" find-and-edit

if [[ -d $DOTFILES/local/zsh_plugins/zsh-history-substring-search ]]; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

zmodload zsh/complist # Needed for reverse-menu-complete binding
bindkey -M menuselect "^[[Z" reverse-menu-complete

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line
