define install_if_needed
	@type $1 >/dev/null 2>&1 || sudo dnf install $1
endef

define backup_config
  @if [ -f $1 ] && [ ! -f $1.old ]; \
	then \
    cp $1 $1.old; \
  fi
endef

define source_file
  @echo "source $(PWD)/$1" > $2
endef

define git_clone
  @if [ -d $2 ]; \
  then \
    echo $1 already cloned; \
  else \
    git clone $1 $2; \
  fi
endef

setup_local:
	@if [ ! -d $(PWD)/local ]; \
	then \
	  mkdir $(PWD)/local; \
	  mkdir $(PWD)/local/git; \
		echo "export DOTFILES=$(PWD)" > $(PWD)/local/var; \
	fi

zsh: setup_local
	@echo "Installing and setting up zsh"
	@$(call install_if_needed,zsh)
	@echo "Setting default shell to zsh"
	@$(call install_if_needed,util-linux-user)
	@chsh -s $(shell which zsh)
	@echo "Backing up old zshrc and installing new"
	@$(call backup_config,~/.zshrc)
	@$(call source_file,zsh/zshrc,~/.zshrc)
	@echo "Setting up local variables"
	@sed -i '1isource $(PWD)/local/zsh' ~/.zshrc
	@echo "source $(PWD)/local/var" > $(PWD)/local/zsh
	@echo "Cloning and setting up dependencies"
	@$(eval OMZ := $(PWD)/local/git/oh-my-zsh)
	@$(eval ZAS := $(PWD)/local/git/zsh-autosuggestions)
	@$(eval ZAH := $(PWD)/local/git/zsh-syntax-highlighting)
	@echo "OMZ=$(OMZ)" >> $(PWD)/local/zsh
	@echo "ZAS=$(ZAS)" >> $(PWD)/local/zsh
	@echo "ZAH=$(ZAH)" >> $(PWD)/local/zsh
	@$(call git_clone, https://github.com/robbyrussell/oh-my-zsh.git, $(OMZ))
	@$(call git_clone, https://github.com/zsh-users/zsh-autosuggestions.git, $(ZAS))
	@$(call git_clone, https://github.com/zsh-users/zsh-syntax-highlighting.git, $(ZAH))
	@echo "Finished!"

vim: setup_local
	@echo "Installing and setting up vim"
	@$(call install_if_needed,vim)
	@echo "Backing up old vimrc and installing new"
	@$(call backup_config,~/.vimrc)
	@$(call source_file,vim/vimrc,~/.vimrc)
	@echo "Installing plugins"
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> $(PWD)/local/var
	@$(call install_if_needed,the_silver_searcher)
	@vim +PlugInstall +qall
	@echo "Finished!"

tmux: setup_local
	@echo "Installing and setting up tmux"
	@$(call install_if_needed,tmux)
	@echo "Backing up old tmux.conf and installing new"
	@$(call backup_config,~/.tmux.conf)
	@$(call source_file,tmux/tmux.conf,~/.tmux.conf)
	@echo "Finished!"

.PHONY: zsh, vim, tmux, setup_local
