gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
cat $DOTFILES/setup_scripts/.terminal-dump | dconf load /org/gnome/terminal/legacy/
