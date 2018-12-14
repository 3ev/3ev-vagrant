Vagrant.configure("2") do |config|

  # Ubuntu 18.04

  config.vm.box = "ubuntu/bionic64"

  # Hostname

  config.vm.hostname = "tev-modern.dev"

  # Use default Vagrant SSH key and forward SSH details to VM

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Virtualbox config

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1536]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
  end

  # Provision

  config.vm.provision "shell", path: "./scripts/provision.sh"
  config.vm.provision "shell", path: "./scripts/ruby.sh", privileged: false

end
