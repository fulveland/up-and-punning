#!/bin/sh

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "\n⨀⨀ $fmt\n" "$@"
}

run() {
  # local bookmark=$(pwd)

  fancy_echo "Is your name Dorthyfiles?"

  git clone https://github.com/ivanreese/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  source bootstrap.sh

  fancy_echo "Well, we're in Kansas now. Or maybe Arkansas."

  # cd $bookmark
}

read -p "May I interest you in some dotfiles? (y/n) " yn
case $yn in
  [Yy]* ) run;;
esac
