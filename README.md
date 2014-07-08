# 3ev Vagrant

Vagrant setup for 3ev servers.

## Setting up your development environment

Get started by cloning this project on your Mac.

### Install Homebrew

Follow the installation instructions on [http://brew.sh/](http://brew.sh/).

To install Homebrew you will need to have the Mac OS X build tools. The easiest
way to acquire these is to install Xcode from the Mac App Store.

#### Cask

If you're feeling adventourous you can install VirtualBox and Vagrant using
[Cask](https://github.com/phinze/homebrew-cask), otherwise:

### Install VirtualBox

Download and install from
[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).

### Install Vagrant

Download and install the latest version (1.3.3 at time of writing) from
[http://downloads.vagrantup.com/](http://downloads.vagrantup.com/).

### Install Composer

Before you install Composer you will need to check your local PHP configuration.
If `/private/etc/php.ini` doesn't exist then make a copy of
`/private/etc/php.ini.default` called `php.ini` and then edit your `php.ini`
file to include the following:

```ini
detect_unicode = Off
date.timezone = Europe/London
```

Next, run the following commands:

```sh
$ curl -s http://getcomposer.org/installer | php
$ sudo mv composer.phar /usr/bin/composer
```

### SSH Keys

If you haven't already done so, you should add your key to Github. Follow these
instructions:
[https://help.github.com/articles/generating-ssh-keys](https://help.github.com/articles/generating-ssh-keys).

## Building your server

### Create your projects directory

Create a projects directory in your home directory i.e.`$ mkdir ~/projects/`

All of your projects should be in this directory. You can start cloning your
projects from Github in there now.

### Starting the server

Navigate to the `3ev-vagrant` directory and run `vagrant up`. This will take a
while as the Ubuntu image will download and the  packages will be installed
automatically on the virtual machine.

If you receive an error about the host network interface then try running
`vagrant up` again.

When the VM begins loading it will ask you to select a network interface. You
should use your main connection; unless you are plugged in via ethernet this
will be the Wi-Fi/Airport option.

Your vm should be running now. Your local projects folder has been mounted to
`/var/www/vhosts/`. You can do your project work by editing the local files in
the projects directory on your Mac.

You can access the VM by running vagrant ssh. The first time you start your vm
you will need to download the TYPO3 source code into `/share`. You can do this
by running:

```sh
$ cd /share && ./typo3.sh
```

You can now start building and working on your projects by following the
instructions in the `README` file of the project.

**Note: ** You will need to edit the host file on your Mac so you can see your
builds in a browser e.g.

```
192.168.56.101  singup.dev
```

## Extra bits and pieces

### Setting up Sequel Pro

Sequel Pro is a MySQL GUI for Mac. To set up a connection to your VM enter the
following details:

- Type: SSH
- MySQL Host: 127.0.0.1
- Username and Password: root
- SSH Host: 127.0.0.1
- SSH User: vagrant
- SSH Key: ~/.vagrant.d/insecure\_private\_key
- SSH Port: 2222

### Private repos & Composer

In older versions of Composer you may need to manually set your
[GitHub Personal Access Token](https://github.com/settings/applications) by
creating a `config.json` in `~/.composer.`, in order to be able to install from
private GitHub repositories. Add the following JSON config to that file:

```json
{
    "config": {
        "github-oauth": {
            "github.com": "9eefb8b9a41729668c844dfb53c98eaa17546eba"
        }
    }
}
```

