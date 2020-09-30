INSTALL_COMMAND := sudo dnf install -y

local:
	if [[ ! -d ./local ]]; then mkdir ./local && touch ./local/var; fi

utils:
	if ! type stow > /dev/null 2>&1; then $(INSTALL_COMMAND) stow; fi

font: local
	wget -O inconsolata.ttf "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/Regular/complete/Inconsolata%20LGC%20Nerd%20Font%20Complete%20Mono.ttf"
	mkdir -p ~/.local/share/fonts/inconsolata
	mv inconsolata.ttf ~/.local/share/fonts/inconsolata
	fc-cache
	echo "export PATCHED_FONT=true" >> ./local/var

bin: local
	echo "export PATH=$(PWD)/bin:\$$PATH" >> ./local/var
	$(INSTALL_COMMAND) fzf ripgrep
	if [[ -z "$(DONT_INSTALL_PACKAGES)" && ! -d ./local/packages ]]; then \
		git clone --depth=1 ssh://git@gitea.lan.jbakken.com:222/jonasbak/packages.git ./local/packages && \
		echo "export PATH=$(PWD)/local/packages/bin:\$$PATH" >> ./local/var; fi

sway: utils
	$(INSTALL_COMMAND) sway swaylock wofi swayidle waybar mako grim wl-clipboard
	stow sway

tmux: utils
	$(INSTALL_COMMAND) tmux
	stow tmux

vim: utils
	$(INSTALL_COMMAND) vim
	if [[ ! -f ~/.vim/autoload/plug.vim ]]; then curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		 https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; fi
	stow vim
	DOTFILES=$(PWD) vim +PlugInstall +qall
	if [[ ! -d ./local/vim_undo ]]; then mkdir ./local/vim_undo; fi
	if [[ ! -d ./local/vim_sessions ]]; then mkdir ./local/vim_sessions; fi

zsh: utils local
	$(INSTALL_COMMAND) zsh
	stow zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ./local/zsh_plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./local/zsh_plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-completions.git ./local/zsh_plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-history-substring-search.git ./local/zsh_plugins/zsh-history-substring-search
	if [[ ! -d ./local/zsh_completions ]]; then mkdir ./local/zsh_completions; fi
	if type kubectl > /dev/null 2>&1 && [[ ! -f ./local/zsh_completions/_kubectl ]]; then \
		kubectl completion zsh > ./local/zsh_completions/_kubectl; fi
	if type docker > /dev/null 2>&1 && [[ ! -f ./local/zsh_completions/_docker ]]; then \
		curl -fLo ./local/zsh_completions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker; fi
	if [[ "$(expr "$(SHELL)" : '.*/\(.*\)')" != "zsh" ]]; then $(INSTALL_COMMAND) util-linux-user; \
		chsh -s /bin/zsh; fi

alacritty: utils
	sudo dnf copr enable pschyska/alacritty
	$(INSTALL_COMMAND) alacritty
	stow alacritty

.PHONY: local font utils bin sway tmux vim zsh alacritty
