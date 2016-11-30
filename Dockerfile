FROM ieee0824/dev-base:latest

RUN set -eu \
	&& apt-get -y update \
	&& apt-get -y upgrade 

RUN apt-get -y install openssh-server build-essential \
	git libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev liblua5.2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev lua5.2 ruby mercurial \
	lua5.2 \
	libluajit-5.1-2 libluajit-5.1-dev \
	curl 

RUN ldconfig
	
ADD vim /tmp/vim

RUN cd /tmp/vim \
	&& ./configure \
		--enable-multibyte \
		--with-features=huge \
		--enable-luainterp \
		--enable-perlinterp \
		--enable-pythoninterp \
		--with-python-config-dir=/usr/lib64/python2.6/config \
		--enable-rubyinterp \
		--with-ruby-command=/usr/bin/ruby \
	&& make -j$(($(nproc) + $(($(nproc) / 4)))) \
	&& ./src/vim --version \
	&& make install \
	&& rm -rf /tmp/vim
	

ADD root/.vimrc /tmp/.vimrc

RUN cat /tmp/.vimrc >> /root/.vimrc \
	&& curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 

RUN vim +PlugInstall16 +qall
WORKDIR /root
CMD ["bash"]
