#!/usr/bin/env bash

#
# Install latest Ruby via Rbenv, and any desired gems.
#
# This script should be run with 'privileged' set to false (i.e as the vagrant
# user).
#



#
# Ensure we can clone things from github.com without being asked for key confirmation
#

echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config



#
# Install Rbenv
#

sudo apt-get update
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.5.1
rbenv global 2.5.1
ruby -v

#
# Install ruby build and gem rehash plugins
#

git clone git@github.com:sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> $HOME/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

git clone git@github.com:sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash




#
# Install Gems
#

echo "gem: --no-ri --no-rdoc" > $HOME/.gemrc
gem install bundler
gem install sass -v 3.3.4



#
# Install Mailcatcher (and configure for PHP)
#

gem install mailcatcher
echo "sendmail_path = /usr/bin/env $(which catchmail) -f mailcatcher@local.dev" | sudo tee /etc/php5/conf.d/z_mailcatcher.ini
sudo service apache2 restart

# Start Mailcatcher on boot

mlctchrupstart="description \"Mailcatcher\"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env /home/vagrant/.rbenv/shims/mailcatcher --foreground --http-ip=0.0.0.0
"
echo "$mlctchrupstart" | sudo tee /etc/init/mailcatcher.conf
