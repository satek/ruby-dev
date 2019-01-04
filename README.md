## Setup

```docker volume create bundle-cache```

## Run with current folder mounted and used as app folder

```docker run -it -v `pwd`:/root/app -v bundle-cache:/usr/local/bundle satek/ruby-dev```
