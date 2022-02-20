# Tev Basic Vagrant Box

This basic Vagrant box mirrors the setup on a few different servers.

## What's included?

* Ubuntu 12.04
* Apache 2.2
* MySQL 5.5 (root user/password: `root/root`)
* PHP 5.3, and some useful extensions
* Composer
* Memcache
* SQLite
* Node.js latest with RequireJS and Bower
* Ruby 2.2.1 (via Rbenv) and Bundler
* SASS 3.3.4
* Sphinx search
* Mailcatcher (installed and running by default for PHP, at port 1080)

## Thanks, related projects and useful links

This box was built using ideas and similar config from a few different sources,
in particular:

* https://github.com/laravel/settler
* https://gorails.com/setup/ubuntu/14.04
