#/bin/sh
rm -rf ~/.config/nvim ~/.tmux.conf \
&& cp $(pwd)/fonts/* ~/.fonts/ \
&& curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
&& ln -s $(pwd)/init.vim ~/.config/nvim/init.vim \
&& ln -s $(pwd)/tmux.conf ~/.tmux.conf \
&& ln -s $(pwd)/colors/seattle.vim ~/.config/nvim/colors/seattle.vim \
&& nvim -c 'PlugInstall' -c 'qa!'
