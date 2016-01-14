Vagrant.configure("2") do |config|

  # Ubuntu 14.04

  config.vm.box = "ubuntu/trusty64"

  # Hostname

  config.vm.hostname = "tev-production.dev"

  # Use default Vagrant SSH key and forward SSH details to VM

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Override default SSH port

  config.vm.network "forwarded_port", guest: 22, host: 2223, id: "ssh"

  # Virtualbox config

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1536]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Provision

  config.vm.provision "shell", path: "./scripts/provision.sh"
  config.vm.provision "shell", path: "./scripts/ruby.sh", privileged: false

end
