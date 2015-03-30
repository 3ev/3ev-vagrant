#!/usr/bin/env bash

#
# Install latest Ruby via Rbenv
#
# This script should be run with 'privileged' set to false (i.e as the vagrant
# user).
#

# Ensure we can clone things from github.com without being asked for key confirmation

echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

# Install Rbenv

git clone git@github.com:sstephenson/rbenv.git $HOME/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Install ruby build and gem rehash plugins

git clone git@github.com:sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> $HOME/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

git clone git@github.com:sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash

# Install latest Ruby

rbenv install 2.2.1
rbenv global 2.2.1

# Install Bundler

echo "gem: --no-ri --no-rdoc" > $HOME/.gemrc
gem install bundler
