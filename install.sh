#!/bin/bash
export DOTFILES=$PWD

if [[ -z $@ ]]; then
  echo "Run with one or more of the following arguments:"
  ls -1 $DOTFILES/setup_scripts | awk -F "." '{print $1}'
else
  for arg in "$@"
  do
    source $DOTFILES/setup_scripts/$arg.sh
  done
  echo "Finished"
fi
