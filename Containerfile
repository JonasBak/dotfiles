FROM registry.fedoraproject.org/fedora-toolbox:44

RUN dnf install -y make

COPY . ./dotfiles

RUN cd dotfiles && make local utils bin tmux vim nvim zsh alacritty
