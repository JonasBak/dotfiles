# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

autoload -U colors && colors

setopt PROMPT_SUBST

set_prompt() {

	PS1="%{$fg[white]%}[%{$reset_color%}"

	PS1+="%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}"

	if [[ -z "${VIRTUAL_ENV}" ]]; then
    PS1+=""
  else
    PS1+="%{$fg[green]%} (env)%{$reset_color%}% "
  fi

	PS1+="%{$fg[white]%}]: %{$reset_color%}% "

	if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
    modified=$(git status -s | grep "^.\(M\|D\)" -c)
    added=$(git status -s | grep "^\(A\|M\|D\|R\|C\)" -c)
    untracked=$(git status -s | grep "^??" -c)

    RIGHT="%{$fg[white]%}[%{$reset_color%}"
		#PS1+=', '
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

    if [ -n "$diff" ]; then
      RIGHT+="|$diff"
    fi

	  RIGHT+="%{$fg[white]%}]%{$reset_color%}%"
    RPROMPT=$RIGHT
  else
    RPROMPT=""
	fi

}

precmd_functions+=set_prompt
