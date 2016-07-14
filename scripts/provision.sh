#!/usr/bin/env bash



#
# Update package lists
#

apt-get update
apt-get upgrade -y
apt-get autoremove -y



#
# Force locale, set timezone
#

echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8
ln -sf /usr/share/zoneinfo/UTC /etc/localtime



#
# Install some PPAs (for Node.js)
#

apt-get install -y python-software-properties software-properties-common

apt-add-repository ppa:chris-lea/node.js -y

apt-get update



#
# Install basic packages
#
# Some of these are required for Rbenv, some for PHP:
#
# - Ruby: https://github.com/sstephenson/ruby-build/wiki
# - PHP: re2c, libmcrypt4 libpcre3-dev
#

apt-get install -y build-essential make gcc git curl re2c vim zsh \
autoconf bison libssl-dev libyaml-dev libncurses5-dev libffi-dev libgdbm3 \
libgdbm-dev libmcrypt4 libpcre3-dev imagemagick libreadline6-dev zlib1g-dev



#
# Install Apache
#

apt-get install -y apache2

# Enable modules

a2enmod rewrite
a2enmod headers
a2enmod proxy
a2enmod expires
a2enmod ssl
a2enmod setenvif

# Remove default site

a2dissite 000-default

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
apt-get install -y mysql-server-5.5 mysql-client-5.5 mysql-server-core-5.5



#
# Install MongoDB
#

apt-get install -y mongodb



#
# Install and configure PHP
#

apt-get install -y php5 libapache2-mod-php5 php5-dev php5-cli php5-curl \
php5-gd php5-intl php5-mcrypt php5-memcache php5-memcached php-apc php5-sqlite \
php-pear php5-json php5-mysqlnd php5-gmp php5-imap php5-imagick php5-memcache \
php5-suhosin

# Configure some general settings

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
sed -i "s/log_errors = .*/log_errors = On/" /etc/php5/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php5/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC" /etc/php5/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/log_errors = .*/log_errors = On/" /etc/php5/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php5/apache2/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC" /etc/php5/apache2/php.ini

# Enable and configure some extensions

printf "\n" | pecl install mongo
echo "extension = mongo.so" | tee /etc/php5/conf.d/mongo.ini
echo "extension = mcrypt.so" | tee /etc/php5/conf.d/mcrypt.ini
echo "suhosin.executor.include.whitelist = phar" | tee /etc/php5/conf.d/suhosin_custom.ini

service apache2 restart

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
printf "\nPATH=\"/home/vagrant/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile

# Install PEAR packages

pear channel-discover pear.phing.info
pear install Services_Amazon_S3-alpha
pear upgrade pear/Archive_Tar
pear install phing/phing



#
# Install Memcached
#

apt-get install -y memcached



#
# Install SQLite
#

apt-get install -y sqlite3 libsqlite3-dev



#
# Install Node.js
#

apt-get install -y nodejs

# Update NPM to latest version

npm -g update npm

# Install some NPM packages

npm -g install bower
npm -g install requirejs



#
# Install Sphinx
#

apt-get install -y sphinxsearch



#
# Create the /share directories
#

mkdir /share && chmod 777 /share
mkdir /share/sphinx && chmod 777 /share/sphinx
