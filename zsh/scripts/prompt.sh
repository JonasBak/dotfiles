autoload -U colors && colors

setopt PROMPT_SUBST

autoload -U add-zsh-hook

_prompt_left_pre=$(if [[ -z $PATCHED_FONT ]];
  then echo "["
  else echo " "; fi)
_prompt_left_separator=$(if [[ -z $PATCHED_FONT ]];
  then echo " "
  else echo " "; fi)
_prompt_left_post=$(if [[ -z $PATCHED_FONT ]];
  then echo "]:"
  else echo " "; fi)
_prompt_right_pre=$(if [[ -z $PATCHED_FONT ]];
  then echo "["
  else echo -e "%{$fg[blue]%}\ue725 "; fi)
_prompt_right_separator=$(if [[ -z $PATCHED_FONT ]];
  then echo "|"
  else echo " "; fi)
_prompt_right_post=$(if [[ -z $PATCHED_FONT ]];
  then echo "]"
  else echo " "; fi)
_prompt_env=$(if [[ -z $PATCHED_FONT ]];
  then echo "%{$fg[green]%}(env)%{$reset_color%}% "
  else echo -e "%{$fg[green]%}(env)%{$reset_color%}% "; fi)

set_prompt() {
  PS1="$_prompt_left_pre"
  PS1+="%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}"

  if [[ ! -z "${VIRTUAL_ENV}" ]]; then
    PS1+="$_prompt_left_separator$_prompt_env"
  fi

  PS1+="$_prompt_right_post"

  if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
    modified=$(git status -s | grep "^.\(M\|D\)" -c)
    added=$(git status -s | grep "^\(A\|M\|D\|R\|C\)" -c)
    untracked=$(git status -s | grep "^??" -c)

    RIGHT="$_prompt_right_pre"
    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    RIGHT+="%{$fg[blue]%}$branch%{$reset_color%}"

    diff=""
    if [ $added -ne "+0" ]; then
      diff+="%{$fg[green]%}+$added%{$reset_color%}"
    fi
    if [ $modified -ne "+0" ]; then 
      diff+="%{$fg[yellow]%}+$modified%{$reset_color%}"
    fi
    if [ $untracked -ne "+0" ]; then 
      diff+="%{$fg[red]%}+$untracked%{$reset_color%}"
    fi

    if [[ -n "$diff" ]]; then
      RIGHT+="$_prompt_right_separator$diff"
    fi

    RIGHT+="$_prompt_right_post"
    RPROMPT=$RIGHT
  else
    RPROMPT=""
  fi
}

add-zsh-hook precmd set_prompt
