FROM ruby:2.5.3

WORKDIR /root/app

RUN apt-get update
RUN apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev \
                       libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev \
                       libgdbm3 libgdbm-dev git-core curl lua5.1 liblua5.1-dev \
                       python-dev python3-dev python-pip python3-pip \
                       libperl-dev gdb tmux locales apt-utils

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

# Node
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN curl --silent --show-error --location https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_6.x/ stretch main" > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install -y nodejs
# Yarn
RUN curl --silent --show-error --location https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

RUN git clone --depth 1 https://github.com/vim/vim.git
RUN cd vim && ./configure --with-features=huge \
                          --enable-multibyte \
                          --enable-rubyinterp=yes \
                          --with-ruby-command=/usr/local/rbenv/shims/ruby \
                          --enable-pythoninterp=yes \
                          --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
                          --enable-python3interp=yes \
                          --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
                          --enable-perlinterp=yes \
                          --enable-luainterp=yes \
                          --enable-cscope \
                          --prefix=/usr/local && \
   make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install

RUN git clone --depth 1 https://github.com/satek/vim.git ~/.vim
RUN ln -s .vim/vimrc .vimrc

CMD ["/bin/bash", "-c", "tmux", "new", "-s", "dev"]
