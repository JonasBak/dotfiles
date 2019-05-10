#!/bin/bash
export DOTFILES=$PWD

for arg in "$@"
do
  source $DOTFILES/setup_scripts/$arg.sh
done

echo "Finished"
