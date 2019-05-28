#!/bin/bash
echo "$($DOTFILES/tmux/scripts/pass.sh)$($DOTFILES/tmux/scripts/kubernetes.sh)$($DOTFILES/tmux/scripts/docker.sh)$($DOTFILES/tmux/scripts/cpu.sh) | $($DOTFILES/tmux/scripts/mem.sh)"
