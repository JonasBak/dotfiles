# "inspired" by https://github.com/jackharrisonsherlock/common
autoload -U colors && colors
setopt prompt_subst

PROMPT_SYMBOL="❯"

PROMPT_COLORS_CURRENT_DIR=cyan
PROMPT_COLORS_RETURN_STATUS_TRUE=white
PROMPT_COLORS_RETURN_STATUS_FALSE=red
PROMPT_COLORS_GIT_STATUS_DEFAULT=blue
PROMPT_COLORS_GIT_STATUS_BOTH=magenta
PROMPT_COLORS_GIT_STATUS_STAGED=green
PROMPT_COLORS_GIT_STATUS_UNSTAGED=yellow
PROMPT_COLORS_BG_JOBS=yellow
PROMPT_COLORS_PYTHON_ENV=green

PROMPT='$(prompt_current_dir)$(prompt_bg_jobs)$(prompt_return_status)%{$reset_color%}'

RPROMPT='$(prompt_git_status)%{$reset_color%}'

prompt_current_dir() {
  echo -n "%{$fg_bold[$PROMPT_COLORS_CURRENT_DIR]%}%~ "
}

prompt_return_status() {
  echo -n "%(?.%{$fg_no_bold[$PROMPT_COLORS_RETURN_STATUS_TRUE]%}.%{$fg[$PROMPT_COLORS_RETURN_STATUS_FALSE]%})$PROMPT_SYMBOL%f "
}

prompt_git_status() {
    local message=""
    local message_color="%{$fg_no_bold[$PROMPT_COLORS_GIT_STATUS_DEFAULT]%}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} && -n ${unstaged} ]]; then
        message_color="%{$fg_no_bold[$PROMPT_COLORS_GIT_STATUS_BOTH]%}"
    elif [[ -n ${staged} ]]; then
        message_color="%{$fg_no_bold[$PROMPT_COLORS_GIT_STATUS_STAGED]%}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%{$fg_no_bold[$PROMPT_COLORS_GIT_STATUS_UNSTAGED]%}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}"
    fi

    echo -n "${message}"
}

prompt_bg_jobs() {
  bg_status="%{$fg_no_bold[$PROMPT_COLORS_BG_JOBS]%}%(1j.↓%j .)"
  echo -n $bg_status
}
