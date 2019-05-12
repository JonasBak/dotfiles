SETUP_SCRIPTS=$DOTFILES/setup_scripts

source $SETUP_SCRIPTS/utils.sh

if [[ -z $PATCHED_FONT ]]; then
  wget -O inconsolata.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/Regular/complete/Inconsolata%20LGC%20Nerd%20Font%20Complete%20Mono.ttf
  mkdir -p ~/.local/share/fonts/inconsolata
  mv inconsolata.ttf ~/.local/share/fonts/inconsolata
  fc-cache
  gsettings set org.gnome.desktop.interface monospace-font-name "InconsolataLGC Nerd Font Mono Medium 11"
  add_if_not_present "export PATCHED_FONT=true" $DOTFILES/local/var
fi
