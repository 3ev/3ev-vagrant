# vim: syntax=ruby

require 'yaml'

settings = YAML::load(File.read(File.dirname(__FILE__) + "/settings.yaml"))

Vagrant.configure("2") do |config|

  # Ubuntu 12.02

  config.vm.box = "ubuntu/bionic64"

  # Hostname

  config.vm.hostname = "tev-modern.dev"

  # Default private networking IP

  config.vm.network :private_network, ip: settings["ip"]

  # Synced folders

  config.vm.synced_folder settings["sites_path"], "/var/www/vhosts", id: "vagrant-root", nfs: true

  # Use default Vagrant SSH key and forward SSH details to VM

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Required because "they" won't change the login user. This might change in future.
  config.ssh.username = settings["username"]

  # Virtualbox config

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1536]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize [ 'modifyvm', :id, '--uartmode1', 'disconnected']
  end

  # Provision

  config.vm.provision "shell", path: "./scripts/provision.sh"
  config.vm.provision "shell", path: "./scripts/ruby.sh", privileged: false

end
