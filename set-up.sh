#!/bin/bash
echo() {
    printf "\e[032m$1\e[0m\n"
}

if [[ -n "$XDG_CONFIG_HOME" ]]; then
    CONFIG_PATH="$XDG_CONFIG_HOME"
else
    CONFIG_PATH="$HOME/.config"
fi

echo "Creating symbolic links"
ln -s `pwd`/config $CONFIG_PATH
ln -s `pwd`/gitconfig $HOME/.gitconfig
for CONFIG in zsh/*; do
    ln -s `pwd`/$CONFIG $HOME/${CONFIG/zsh\//.}
done

echo "Installing ranger devicons"
cd /tmp
git clone https://github.com/alexanderjeurissen/ranger_devicons && cd ranger_devicons
make install

echo "Installing vim-plug"
curl -fLo $CONFIG_PATH/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
