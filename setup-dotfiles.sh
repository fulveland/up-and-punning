#!/bin/sh

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "⨀⨀ $fmt\n" "$@"
}


fancy_echo "Hold on, Toto!"

git clone https://github.com/ivanreese/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash bootstrap.sh

fancy_echo "Well, we're in Kansas now. Or maybe Arkansas."
