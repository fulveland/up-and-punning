#!/bin/sh

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "\xF0\x9F\x90\x9D  $fmt\n" "$@"
}

would_you_kindly() {
  read -p "May I interest you in a $1? (y/n) " yn
  case $yn in
    [Yy]* ) bash setup-$1.sh;;
  esac
}

run() {
  cd ${0%/*}

  fancy_echo "Let's get bizzy!"

  would_you_kindly brew
  would_you_kindly ruby
  would_you_kindly ssh
  would_you_kindly dotfiles
  would_you_kindly fonts
  would_you_kindly hacker-defaults

  fancy_echo "Honey, you're home!"
}


read -p "ARE YOU READY‽‽‽ (y/n) " yn
case $yn in
  [Yy]* ) run;;
  * ) fancy_echo "FUUUUCK YOU";;
esac
