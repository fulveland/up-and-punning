#!/bin/sh

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "\xF0\x9F\x8D\xBB  $fmt\n" "$@"
}

brew_install() {
  if ! brew_is_installed "$1"; then
    fancy_echo "Installing %s" "$1"
    brew install "$@"
  fi
}

brew_is_installed() {
  local name="$(brew_expand_alias "$1")"
  brew list -1 | grep -Fqx "$name"
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}


if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew"
  curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
fi


fancy_echo "Updating Homebrew"
brew update


brew_install 'git'
brew_install 'rbenv'
brew_install 'ruby-build'
brew_install 'heroku-toolbelt'
brew_install 'cloc'
brew_install 'hub'


fancy_echo 'Cheers!'
