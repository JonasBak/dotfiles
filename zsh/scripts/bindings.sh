dot(){
  if [[ "$1" = "edit" || "$1" = "e" ]]; then
    cd $DOTFILES
    vim
  elif [[ "$1" = "add" ]] then
    echo export $2 >> $DOTFILES/local/var
    source $DOTFILES/local/var
    echo Added $2 to environment
  else
    cd $DOTFILES
  fi
}

alias c="~/code"

alias copy="xsel -ib"

boiler(){
  if [[ "$1" = "list" || "$1" = "ls" ]]; then
    ls $DOTFILES/boilerplate
  else
    cp -r $DOTFILES/boilerplate/$1 ./$2
    echo Started project $2 from template $1
    cd $2
    git init
  fi
}

unalias l
l(){
  (
  [ ! -z $@ ] && cd $@
	# ls -la | tail -n +4 | awk '
	ls -1ab | tail -n +3 | awk '
  BEGIN {
    if (system("[[ -d ./.git ]]") == 0) {isrepo=1};
    RED="\033[01;31m";
    GREEN="\033[01;32m";
    YELLOW="\033[01;33m";
    BLUE="\033[01;34m";
    NONE="\033[0m";
  };
  {
    file=$0;
    childrepo="";
    if(system("[[ -d \"./" $NF "/.git\" ]]") == 0)
      childrepo=BLUE" g "NONE;
    if (isrepo == 1) {
      status="";
      command="git status -s \""file"\"";
      if ((command |& getline line) > 0) {
        status = substr(line, 1, 2);
        status = gensub("\\?\\?", RED"??"NONE, "g", status);
				status = gensub("(.+)(M|D)", "\\1"YELLOW"\\2"NONE, "g", status);
        status = gensub("^(A|M|D|R|C)(.*)", GREEN"\\1"NONE"\\2", "g", status);
      };
      close(command);
    };
    if (system("[[ -d \"./" file "\" ]]") == 0)
      file=BLUE file NONE "/"
    else if (system("[[ -x \"./" file "\" ]]") == 0)
      file=GREEN file NONE
    printf " %3s %2s %-30s\n", childrepo, status, file;
  };'
)
}
