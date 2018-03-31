#!/bin/bash
set -x
# CA CERT HACK from https://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url before doing curl
if [[ -a '/etc/ssl/certs/ca-certificates.crt' ]]; then 
  export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
else
    unameOut="$(uname -s)"
    case "${unameOut}" in
	Linux*)     
	    machine=Linux
	    echo "on ${machine}. installing CA certificates"
	    sudo-apt-get-install ca-certificates # FIXME: Assuming ubuntu for now
            export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
		;;
	Darwin*)    machine=Mac;;
	CYGWIN*)    machine=Cygwin;;
	MINGW*)     machine=MinGw;;
	*)          machine="UNKNOWN:${unameOut}";;
    esac
fi

rm -rf ~/.config/nvim ~/.tmux.conf \
&& curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
&& ln -s $(pwd)/init.vim ~/.config/nvim/init.vim \
&& ln -s $(pwd)/tmux.conf ~/.tmux.conf \
&& mkdir ~/.config/nvim/colors \
&& ln -s $(pwd)/colors/seattle.vim ~/.config/nvim/colors/seattle.vim \
&& ln -s $(pwd)/bash_profile_sid ~/.bash_profile_sid \
&& nvim -c 'PlugInstall' -c 'qa!'
