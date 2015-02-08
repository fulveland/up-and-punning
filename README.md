# Up and Punning

Here are a few scripts, notes, and other crap to help me get up and running on
a new machine faaaaast.

The main `setup.sh` script runs the other setup scripts. It should be safe, but
fuck, I don't know. Good luck?

### Yeah but what do I do to do the this?

Just run this line in yer term:

```bash
git clone git@github.com:ivanreese/up-and-punning.git && bash up-and-punning/setup.sh && rm -rf up-and-punning
```

Watch out for that `rm -rf` yo ;)

## So.. um.. come here often?

No. You only run this to do an initial setup. There's no point in running it more than once.

Just.. so you know.. here's what it does.

1. Homebrew
  * Install Homebrew, if necessary, then...
  * `brew update`
  * `brew install git`
  * `brew install rbenv`
  * `brew install ruby-build`
  * `brew install heroku-toolbelt`
2. Ruby
  * Install the latest version and setup rbenv, if necessary, then...
  * `gem update --system`
  * `gem install bundler`
  * `gem install powder`
  * `gem install tunnels`
  * `gem install rspec`
  * `rbenv rehash`
3. SSH
  * Prompts you for how many SSH keys you'd like to setup
  * Umm.. helps you set up the keys. Obvs.
4. Dotfiles
  * Automates the process of setting up [my dotfiles](https://github.com/ivanreese/dotfiles).
