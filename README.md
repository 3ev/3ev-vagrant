#3ev Basic Vagrant Box

This basic Vagrant box mirrors the setup on a few different servers.

##Installing Vagrant and using this project

See [the wiki](https://github.com/3ev/3ev-vagrant/wiki/Installing-Vagrant) for
Vagrant installation instructions and [how to use this project](https://github.com/3ev/3ev-vagrant/wiki/Using-this-Project).

##What's included?

* Ubuntu 12.04
* Apache 2.2
* MySQL 5.5 (root user/password: `root/root`)
* PHP 5.3, and some useful extensions
* Composer
* Memcache
* SQLite
* Node.js latest
    * RequireJS
    * Bower
* Ruby (OS version)
* Sphinx search

##Building the box

```sh
# Clone this repo to wherever you'd like. I keep all of my servers in one directory

$ git clone git@github.com:3ev/3ev-vagrant.git ~/Code/servers/tev-basic

# Checkout the branch for this box

$ cd ~/Code/servers/tev-basic

# Build

$ vagrant up
```

####SSH port

You should SSH into this box using port `2222`.

####Shared folder

The default shared folder for vhosts is `~/projects/`. If
you want yours to be different, [change the config in the Vagrantfile](https://github.com/3ev/3ev-vagrant/blob/master/Vagrantfile#L27).

####IP

This server runs on `192.168.56.101` by default. You can change this by
[editing the Vagrantfile](https://github.com/3ev/3ev-vagrant/blob/master/Vagrantfile#L10).
