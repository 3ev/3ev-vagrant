#!/usr/bin/env bash



#
# Update package lists
#

apt-get update
apt-get upgrade -y



#
# Install some PPAs (for Node.js and Redis latest)
#

apt-get install -y python-software-properties software-properties-common

apt-add-repository ppa:chris-lea/node.js -y
apt-add-repository ppa:rwky/redis -y

apt-get update



#
# Install basic packages
#
# Some of these are require for Rbenv, some for PHP:
#
# - Ruby: https://github.com/sstephenson/ruby-build/wiki
# - PHP: re2c, libmcrypt4 libpcre3-dev
#

apt-get install -y build-essential make gcc git curl re2c vim zsh \
autoconf bison libssl-dev libyaml-dev libncurses5-dev libffi-dev libgdbm3 \
libgdbm-dev libmcrypt4 libpcre3-dev



#
# Install Apache
#

apt-get install -y apache

# Enable modules

a2enmod rewrite
a2enmod headers
a2enmod proxy

# Add vagrant user to www-data

usermod -a -G www-data vagrant
id vagrant
groups vagrant

service apache2 restart



#
# Install MySQL, set root password to 'root'
#

debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
apt-get install -y mysql-server-5.6



#
# Install and configure PHP
#

apt-get install -y php5 libapache2-mod-php5 php5-dev php5-cli php5-curl \
php5-gd php5-intl php5-mcrypt php5-memcached php5-apcu php5-sqlite php-pear \
php5-json php5-mysqlnd php5-gmp php5-imap php5-xdebug

# Make MCrypt Available

ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
sudo php5enmod mcrypt

# Configure some general settings

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
sed -i "s/log_errors = .*/log_errors = On/" /etc/php5/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php5/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/log_errors = .*/log_errors = On/" /etc/php5/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php5/apache2/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/apache2/php.ini

# Configure xdebug

echo "xdebug.remote_enable = 1" >> /etc/php5/apache2/conf.d/20-xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php5/apache2/conf.d/20-xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php5/apache2/conf.d/20-xdebug.ini
echo "xdebug.max_nesting_level = 250" >> /etc/php5/apache2/conf.d/20-xdebug.ini

service apache2 restart

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
printf "\nPATH=\"/home/vagrant/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile



#
# Install Memcache
#

apt-get install -y memcached



#
# Install Redis
#

apt-get install -y redis-server



#
# Install SQLite
#

apt-get install -y sqlite3 libsqlite3-dev



#
# Install Node.js
#

apt-get install -y nodejs



#
# Install latest Ruby via Rbenv
#

# Install Rbenv

git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
exec $SHELL

# Install Rbenv ruby build

git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/vagrant/.bashrc
exec $SHELL

git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/vagrant/.rbenv/plugins/rbenv-gem-rehash

# Install latest Ruby

rbenv install 2.2.1
rbenv global 2.2.1

# Install Bundler

echo "gem: --no-ri --no-rdoc" > /home/vagrant/.gemrc
gem install bundler
