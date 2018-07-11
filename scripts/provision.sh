#!/usr/bin/env bash



#
# Update package lists
#
export DEBIAN_FRONTEND=noninteractive
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

sudo apt-add-repository ppa:ondrej/php

apt-get update
apt-get upgrade -y
apt-get autoremove -y

sudo apt-get install software-properties-common
sudo apt-get install wget

#
# Force locale, set timezone
#

echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

#
# Install basic packages
#
# Some of these are required for Rbenv, some for PHP:
#
# - Ruby: https://github.com/sstephenson/ruby-build/wiki
# - PHP: re2c, libmcrypt4 libpcre3-dev
#

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn


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

sudo ufw allow http
sudo ufw allow https

service apache2 restart



#
# Install MySQL, set root password to 'root'
#

export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

sudo apt-get install -y mysql-server-5.7
sudo apt-get install -y mysql-client-core-5.7   

mysql_secure_installation

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

mysql -u "root" -p"root" -Bse "GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'password';"

sudo service mysql restart

#
# Install and configure PHP
#

sudo apt-get install php7.2

sudo apt-get install -y php7.2-mysql php7.2-curl php7.2-zip php7.2-json php7.2-cgi php7.2-xsl php7.2-cli php7.2-dev php7.2-bcmath php7.2-dba php7.2-dev php7.2-common  

sudo apt-get install -y php7.2-mbstring

sudo apt-get install -y libapache2-mod-php7.2

sudo apt-get install -y php-pear

sudo service apache2 restart

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
printf "\nPATH=\"/home/vagrant/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile

#WP CLI

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Install PEAR packages

sudo pear channel-discover pear.phing.info
sudo pear install Services_Amazon_S3-alpha
sudo pear upgrade pear/Archive_Tar
sudo pear install phing/phing



#
# Install Memcached
#

sudo apt-get install -y memcached



#
# Install Node.js
#

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo apt-get install -y aptitude
sudo aptitude install -y npm

# Install some NPM packages

npm -g install requirejs

rm -rf /var/www/html/
