XDG_CONFIG_HOME := $(HOME)/.config

.PHONY: install
install: ## Sets up symlink for user and root .vimrc for vim and neovim
	ln -snf "$(HOME)/.vim/vimrc" "$(HOME)/.vimrc"
	mkdir -p "$(XDG_CONFIG_HOME)"
	ln -snf "$(HOME)/.vim" "$(XDG_CONFIG_HOME)/nvim"
	ln -snf "$(HOME)/.vimrc" "$(XDG_CONFIG_HOME)/nvim/init.vim"
	sudo ln -snf "$(HOME)/.vim" /root/.vim
	sudo ln -snf "$(HOME)/.vimrc" /root/.vimrc
	sudo mkdir -p /root/.config
	sudo ln -snf "$(HOME)/.vim" /root/.config/nvim
	sudo ln -snf "$(HOME)/.vimrc" /root/.config/nvim/init.vim

.PHONY: update
update: ## Updates all plugins
	git submodule update --init --recursive
	git submodule foreach git pull --recurse-submodules origin master

.PHONY: update-pathogen
update-pathogen: ## Updates pathogen
	curl -LSso $(CURDIR)/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

.PHONY: README.md
README.md: ## Generates and updates plugin info in README.md
	@sed -i '/Dockerfile/q' $@
	@git  submodule --quiet foreach bash -c "echo -e \"* [\$$(git config --get remote.origin.url | sed 's#https://##' | sed 's#git://##' | sed 's/.git//')](\$$(git config --get remote.origin.url))\"" >> $@

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-.]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
