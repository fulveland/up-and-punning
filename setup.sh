#!/bin/sh

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "\n\xF0\x9F\x90\x9D  $fmt\n" "$@"
}

run() {
  local bookmark=$(pwd)

  cd ${0%/*}

  fancy_echo "Let's get bizzy!"

  bash setup-brew.sh
  bash setup-ruby.sh
  bash setup-ssh.sh
  bash setup-dotfiles.sh

  fancy_echo "Honey, you're home!"

  cd $bookmark
}


read -p "ARE YOU READY‽‽‽ (y/n) " yn
case $yn in
  [Yy]* ) run;;
esac
