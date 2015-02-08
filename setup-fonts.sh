#!/bin/bash

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "Ⓕ uck... $fmt\n" "$@"
}

get_font() {
  fancy_echo "Downloading $2"
  curl $1 -o $2
  case $yn in
    [Yy]* ) open $2 && read -p "Hit enter to continue" yn;;
  esac
  rm $2
}

run() {
  fancy_echo "I am NOT your type."

  get_font http://levien.com/type/myfonts/Inconsolata.otf Inconsolata.otf

  fancy_echo "Don't you take a hint? I could sure do sans-you right now."
}

read -p "May I interest you in a fonts? (y/n) " yn
case $yn in
  [Yy]* ) run;;
esac
