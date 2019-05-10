wget -O inconsolata.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/Regular/complete/Inconsolata%20LGC%20Nerd%20Font%20Complete%20Mono.ttf
sudo mkdir /usr/share/fonts/inconsolata
sudo mv inconsolata.ttf /usr/share/fonts/inconsolata
fc-cache
gsettings set org.gnome.desktop.interface monospace-font-name "InconsolataLGC Nerd Font Mono Medium 11"
