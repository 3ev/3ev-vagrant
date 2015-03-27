Vagrant.configure("2") do |config|

  # Ubuntu 14.04

  config.vm.box = "ubuntu/trusty64"

  # Setup networking

  config.vm.network :private_network, ip: "192.168.56.102"

  # Use default Vagrant SSH key and forward SSH details to VM

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Virtualbox config

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "3ev-dev-tev-production"]
  end

  # Shared folders (vhosts)

  config.vm.synced_folder "~/Sites/tev-production/", "/var/www/vhosts", id: "vagrant-root", nfs: true

  # Provision

  config.vm.provision "shell" do |s|
    s.path = "./scripts/provision.sh"
  end

end
