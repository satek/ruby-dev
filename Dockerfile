FROM ruby:2.6.0-stretch as ruby-vim

RUN apt-get update
RUN apt-get install -y libncurses5-dev python-dev \
                       python3-dev lua5.3 liblua5.3-dev libperl-dev git

RUN git clone --depth 1 https://github.com/vim/vim.git
RUN cd vim && ./configure --with-features=huge \
                          --enable-multibyte \
                          --enable-rubyinterp=yes \
                          --enable-pythoninterp=yes \
                          --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
                          --enable-python3interp=yes \
                          --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
                          --enable-perlinterp=yes \
                          --enable-luainterp=yes \
                          --enable-cscope \
                          --prefix=/usr/local && \
   make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install

RUN git clone --depth 1 https://github.com/satek/vim.git /root/.vim
COPY plug.vimrc /root/.vimrc
RUN vim +PlugInstall +qall
RUN rm /root/.vimrc
RUN ln -s /root/.vim/ruby.vimrc /root/.vimrc


FROM ruby:2.6.0-stretch

WORKDIR /root/app

RUN apt-get update
RUN apt-get install -y libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev \
                       git curl lua5.3 software-properties-common \
                       python-dev python3-dev python-pip python3-pip \
                       libperl-dev gdb tmux locales apt-utils silversearcher-ag \
                       chromium chromedriver

COPY --from=ruby-vim /usr/local/share/vim /usr/local/share/vim
COPY --from=ruby-vim /usr/local/bin/vim /usr/local/bin
COPY --from=ruby-vim /root/.vim /root/.vim
COPY --from=ruby-vim /root/.fzf /root/.fzf
COPY --from=ruby-vim /root/.fzf.bash /root
RUN ln -s /root/.vim/ruby.vimrc /root/.vimrc

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
RUN npm install yarn -g

ENV FZF_DEFAULT_COMMAND 'ag --nocolor --hidden -g ""'

CMD ["/bin/bash", "-c", "tmux", "new", "-s", "dev"]
