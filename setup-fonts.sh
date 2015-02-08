#!/bin/bash

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "Ⓕ uck... $fmt\n" "$@"
}

get_font() {
  fancy_echo "Downloading $2"
  curl $1 -o $2
  open $2
  read -p "Hit enter to continue"
  rm $2
}

fancy_echo "I am NOT your type."

get_font http://levien.com/type/myfonts/Inconsolata.otf Inconsolata.otf

fancy_echo "Don't you take a hint? I could sure do sans-you right now."
