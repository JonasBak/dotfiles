# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

autoload -U colors && colors

setopt PROMPT_SUBST

set_prompt() {

	# [
	PS1="%{$fg[white]%}[%{$reset_color%}"

	# Path: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
	PS1+="%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}"

	# Status Code
	#PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

	PS1+="%{$fg[white]%}]: %{$reset_color%}% "
	# Git
	if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
    modified=$(git status -s | grep "^.\(M\|D\)" -c)
    added=$(git status -s | grep "^\(A\|M\|D\|R\|C\)" -c)
    untracked=$(git status -s | grep "^??" -c)

    RIGHT="%{$fg[white]%}[%{$reset_color%}"
		#PS1+=', '
    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
		RIGHT+="%{$fg[blue]%}$branch%{$reset_color%}"
    
    ahead=$(git rev-list --count origin/$branch...$branch)
    
    if [ $ahead -ne 0 ]; then
      RIGHT+="%{$fg[blue]%}+$ahead%{$reset_color%}"
    fi

    diff=""
		if [ $added -ne "+0" ]; then 
			 diff+="%{$fg[green]%}+$added%{$reset_color%}"
		fi
    if [ $modified -ne "+0" ]; then 
			 diff+="%{$fg[blue]%}+$modified%{$reset_color%}"
		fi
    if [ $untracked -ne "+0" ]; then 
			 diff+="%{$fg[yellow]%}+$untracked%{$reset_color%}"
		fi

    if [ -n "$diff" ]; then
      RIGHT+="|$diff"
    fi

	  RIGHT+="%{$fg[white]%}]%{$reset_color%}%"
    RPROMPT=$RIGHT
  else
    RPROMPT=""
	fi


	# Timer: http://stackoverflow.com/questions/2704635/is-there-a-way-to-find-the-running-time-of-the-last-executed-command-in-the-shel
	#if [[ $_elapsed[-1] -ne 0 ]]; then
	#	PS1+=', '
	#	PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
	#fi

	# PID
	#if [[ $! -ne 0 ]]; then
	#	PS1+=', '
	#	PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
	#fi

	# Sudo: https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
	#CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
	#if [ ${CAN_I_RUN_SUDO} -gt 0 ]
	#then
	#	PS1+=', '
	#	PS1+="%{$fg_bold[red]%}SUDO%{$reset_color%}"
	#fi

}

precmd_functions+=set_prompt

# preexec () {
#   (( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
#   _start=$SECONDS
#}

# precmd () {
#   (( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
#   _start=-1 
#}