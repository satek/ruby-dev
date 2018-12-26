## Setup

```docker volume create plugged-cache```

```docker volume create bundle-cache```

## Run with current folder mounted and used as app folder

```docker run -it -v `pwd`:/root/app -v plugged-cache:/root/.vim/plugged -v bundle-cache:/usr/local/bundle ruby-dev```
