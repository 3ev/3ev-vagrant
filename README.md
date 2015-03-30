#Tev Production Vagrant Box

This Vagrant box mirrors the setup on the `tev-production` server, with a few
changes for development.

##Installing Vagrant and using this project

See [the wiki](https://github.com/3ev/3ev-vagrant/wiki/Installing-Vagrant) for
Vagrant installation instructions and [how to use this project](https://github.com/3ev/3ev-vagrant/wiki/Using-this-Project).

##What's included?

* Ubuntu 14.04
* Apache 2.4
* MySQL 5.6 (root user/password: `root/root`)
* PHP 5.5, and some useful extensions
* Composer
* Memcache
* Redis
* SQLite
* Node.js latest
* Ruby 2.2.1 (via Rbenv)

##Building the box

```sh
# Clone this repo to wherever you'd like. I keep all of my servers in one directory

$ git clone git@github.com:3ev/3ev-vagrant.git ~/Code/servers/tev-production

# Checkout the branch for this box

$ cd ~/Code/servers/tev-production
$ git checkout dev-tev-production

# Build

$ vagrant up
```

####Shared folder

The default shared folder for vhosts is `~/Sites/tev-production/`. If
you want yours to be different, [change the config in the Vagrantfile](https://github.com/3ev/3ev-vagrant/blob/dev-tev-production/Vagrantfile#L30).

####IP

This server runs on `192.168.56.101` by default. You can change this by
[editing the Vagrantfile](https://github.com/3ev/3ev-vagrant/blob/dev-tev-production/Vagrantfile#L13).

##Thanks, related projects and useful links

This box was build using ideas and similar config from a few different sources,
in particular:

* https://github.com/laravel/settler
* https://gorails.com/setup/ubuntu/14.04
