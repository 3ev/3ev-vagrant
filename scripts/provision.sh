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
# Install some PPAs (for Node.js and Redis latest)
#

apt-get install -y python-software-properties software-properties-common

# No longer required https://github.com/nodesource/distributions/issues/324
#apt-add-repository ppa:chris-lea/node.js -y
apt-add-repository ppa:rwky/redis -y

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

# Remove default site

a2dissite 000-default

# Add ubuntu user to www-data

usermod -a -G www-data ubuntu
id ubuntu
groups ubuntu

service apache2 restart



#
# Install MySQL, set root password to 'root'
#

debconf-set-selections <<< "mysql-server mysql-server/root_password password SMmier4mi43xyz"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password SMmier4mi43xyz"
apt-get install -y mysql-server-5.7 mysql-client-5.7 mysql-server-core-5.7



#
# Install MongoDB
#
# Not unless we're actually using it. Which we aren't.
# apt-get install -y mongodb
#
# Install and configure PHP
#

apt-get -y install php7.0 libapache2-mod-php7.0
apt-get install -y php libapache2-mod-php php7.0-mcrypt php7.0-mysql php-pear \
php7.0-gd php7.0-intl php-memcache php-apcu php7.0-sqlite3 php7.0-json \
php7.0-mysql php7.0-imap

# Make MCrypt Available

#ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
#php5enmod mcrypt

# Configure some general settings
# Removed - add in as required
#sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
#sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
#sed -i "s/log_errors = .*/log_errors = On/" /etc/php5/cli/php.ini
#sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php5/cli/php.ini
#sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/cli/php.ini
#
#sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
#sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
#sed -i "s/log_errors = .*/log_errors = On/" /etc/php5/cli/php.ini
#sed -i "s/memory_limit = .*/memory_limit = 128M/" /etc/php5/apache2/php.ini
#sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/apache2/php.ini

service apache2 restart

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
printf "\nPATH=\"/home/ubuntu/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/ubuntu/.profile

# Install PEAR packages

pear channel-discover pear.phing.info
pear install Services_Amazon_S3-alpha
pear upgrade pear/Archive_Tar
pear install phing/phing



#
# Install Memcache
#

apt-get install -y memcached

#
# Install nodejs and nodejs-legacy
#

apt-get install -y nodejs
apt-get install -y nodejs-legacy
apt-get install -y npm
npm -g update npm

#
# Install Redis
#

apt-get install -y redis-server



#
# Install SQLite
#

apt-get install -y sqlite3 libsqlite3-dev


#
# Install Java & Elasticsearch
#

wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
echo "deb http://packages.elasticsearch.org/elasticsearch/1.5/debian stable main" | tee -a /etc/apt/sources.list
apt-get update
apt-get install -y default-jre default-jdk elasticsearch
update-rc.d elasticsearch defaults 95 10



#
# Install wkhtmltopdf and xvfb
#

wget -q http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
apt-get -f -y install
rm wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
apt-get -y install xvfb
