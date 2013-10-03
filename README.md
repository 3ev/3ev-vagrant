#Setting up your development environment
Get started by cloning this project on your Mac!
You may want to add yourself to the Sudoers file so that you don't have enter your password when running commands as root. Run: 

	$ sudo nano /etc/sudoers

And enter the following:

	macusernamehere ALL=(ALL) NOPASSWD:ALL

## Install Homebrew

Follow the installation instructions on [http://brew.sh/](http://brew.sh/)

To install Homebrew you may need to install the Mac OS X Command Line Tools, these can be downloaded from here: [https://docs.google.com/a/3ev.com/file/d/0B1Bj8BKpxRQ7cVNRQjdxcHpJbTg/edit?usp=sharing](https://docs.google.com/a/3ev.com/file/d/0B1Bj8BKpxRQ7cVNRQjdxcHpJbTg/edit?usp=sharing)

## Install VirtualBox

Download and install from [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

## Install Vagrant

Download and install the latest version (1.3.3 at time of writing) from [http://downloads.vagrantup.com/](http://downloads.vagrantup.com/)

## Install Composer

Before you install Composer you will need to check your local PHP configuration. If `/private/etc/php.ini` doesn't exist then make a copy of `/private/etc/php.ini.default` called `php.ini` and then edit your `php.ini` file to include the following:

	detect_unicode = Off
	date.timezone = Europe/London

Next, run the following commands:

	curl -s http://getcomposer.org/installer | php
	sudo mv composer.phar /usr/bin/composer

## SSH Keys

If you haven't already done so, you should add your key to Github. Follow these instructions: [https://help.github.com/articles/generating-ssh-keys](https://help.github.com/articles/generating-ssh-keys)

## Personal Access Token

Whilst you're there you should also create a personal access token by going to [https://github.com/settings/applications](https://github.com/settings/applications). Copy your new token to the clipboard and create a file called `config.json` in `~/.composer/` on your Mac. Paste your token in to the file.

	{
	    "config": {
	        "github-oauth": {
	            "github.com": "9eefb8b9a41729668c844dfb53c98eaa17546eba"
	        }
	    }
	}

# Building your server

## Configure the guest's IP address

Open the `dnsmasq.conf` file from the `3ev-vagrant` directory in an editor. If you do not see your name listed here already add a line for yourself and then commit and push your change back to repo. The line in `dnsmasq.conf` defines your hostname.

If your hostname is defined as `address=/bobby/192.168.56.110` then you should use the `.bobby` TLD for all of your project work e.g. for the LASSCO project you would configure the project's vhost to use `lassco.bobby` and view the site at [http://lassco.bobby](http://lassco.bobby) in your browser.

Create a new environment variable in your `.bash_profile` on your Mac and set the IP address to the corresponding IP in `dnsmasq.conf` (`$ nano ~/.bash_profile`)

	export VAGRANT_IP=192.168.56.xxx

## Install Dnsmasq

To install Dnsmasq run:
	
	brew install dnsmasq

Symlink the `dnsmasq.conf` from the `3ev-vagrant` project:

	ln -s ~/3ev-vagrant/dnsmasq.conf /usr/local/etc/dnsmasq.conf

Set up Dnsmasq to run on startup:

	sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons

And to launch Dnsmasq:

	sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

To restart Dnsmasq unload it and then load it again. To unload:

	sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

Finally, add `127.0.0.1` to your DNS Servers on your Mac. Make sure it is the first entry. 

## Create your projects directory

Create a projects directory in your home directory i.e.`$ mkdir ~/projects/`

All of your projects should be in this directory. You can start cloning your projects from Github in there now.

## Starting the server

Navigate to the `3ev-vagrant` directory and run `vagrant up`. This will take a while as the Ubuntu image will download and the  packages will be installed automatically on the virtual machine. 

If you receive an error about the host network interface then try running `vagrant up` again.

When the VM begins loading it will ask you to select a network interface. You should use your main connection; unless you are plugged in via ethernet this will be the Wi-Fi/Airport option.

Your vm should be running now. Your local projects folder has been mounted to `/var/www/vhosts/`. You can do your project work by editing the local files in the projects directory on your Mac.

You can access the VM by running vagrant ssh. The first time you start your vm you will need to download the TYPO3 source code into `/share`. You can do this by running:

	cd /share && ./typo3.sh

You can now start building and working on your projects by following the instructions in the `README` file of the project.

# Extra bits and pieces

## Setting up Sequel Pro

Sequel Pro is a MySQL GUI for Mac. To set up a connection to your VM enter the following details:

- Type: SSH
- MySQL Host: 127.0.0.1
- Username and Password: root
- SSH Host: 127.0.0.1
- SSH User: vagrant
- SSH Key: ~/.composer.d/insecure\_private\_key
- SSH Port: 2222