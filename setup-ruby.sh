#!/bin/sh

set -e

fancy_echo() {
  local fmt="$1"; shift
  printf "\n\xE2\x99\xA6\xEF\xB8\x8F  $fmt\n" "$@"
}

gem_install() {
  if ! gem list "$1" --installed > /dev/null; then
    fancy_echo "Installing %s" "$1"
    gem install "$@"
  fi
}

run() {
  fancy_echo "Checking current Ruby version"
  ruby_version="$(curl -sSL http://ruby.thoughtbot.com/latest)"


  fancy_echo "Initializing rbenv"
  eval "$(rbenv init -)"


  if ! rbenv versions | grep -Fq "$ruby_version"; then
    fancy_echo "Installing Ruby. This might take a long-ass time."
    rbenv install -s "$ruby_version"

    fancy_echo "Setting up Ruby"
    rbenv global "$ruby_version"
    rbenv shell "$ruby_version"
  fi


  fancy_echo "Updating gem"
  gem update --system


  gem_install 'bundler'
  gem_install 'powder'
  gem_install 'tunnels'
  gem_install 'rspec'


  fancy_echo "Rehashing rbenv"
  rbenv rehash


  fancy_echo "Done already? Rubbish! Get back to work."
}

read -p "May I interest you in a ruby? (y/n) " yn
case $yn in
  [Yy]* ) run;;
esac
