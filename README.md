#Tev Production Vagrant Box

This Vagrant box mirrors the setup on the production server, with a few changes
for development.

##What's included?

* Ubuntu 14.04
* Apache 2.4
* MySQL 5.5 (root user/password: `root/root`)
* PHP 5.5, and some useful extensions
* Composer
* Memcache
* Redis
* SQLite
* Node.js latest
* Java & Elasticsearch 1.5
* Ruby 2.2.1 (via Rbenv) and Bundler
* Mailcatcher (installed and running by default for PHP, at port `1080`)
* Wkhtmltopdf 0.12.2.1

##Thanks, related projects and useful links

This box was built using ideas and similar config from a few different sources,
in particular:

* https://github.com/laravel/settler
* https://gorails.com/setup/ubuntu/14.04
