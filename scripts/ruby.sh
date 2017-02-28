#!/usr/bin/env bash

#
# Install latest Ruby via Rbenv, and any desired gems.
#
# This script should be run with 'privileged' set to false (i.e as the ubuntu
# user).
#



#
# Ensure we can clone things from github.com without being asked for key confirmation
#

echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config



#
# Install Rbenv
#

git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"



#
# Install ruby build and gem rehash plugins
#

git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> $HOME/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

git clone https://github.com/sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash



#
# Install latest Ruby
#

rbenv install 2.2.1
rbenv global 2.2.1



#
# Install Bundler
#

echo "gem: --no-ri --no-rdoc" > $HOME/.gemrc
gem install bundler



#
# Install Mailcatcher (and configure for PHP)
#

gem install mailcatcher
echo "sendmail_path = /usr/bin/env $(which catchmail) -f mailcatcher@local.dev" | sudo tee /etc/php5/mods-available/mailcatcher.ini
sudo php5enmod mailcatcher
sudo service apache2 restart

# Start Mailcatcher on boot

mlctchrupstart="description \"Mailcatcher\"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env /home/ubuntu/.rbenv/shims/mailcatcher --foreground --http-ip=0.0.0.0
"
echo "$mlctchrupstart" | sudo tee /etc/init/mailcatcher.conf
