Vagrant.configure("2") do |config|

  # Ubuntu 14.04

  config.vm.box = "ubuntu/xenial64"

  # Hostname

  config.vm.hostname = "tev-u16.dev"

  # Use default Vagrant SSH key and forward SSH details to VM

  # This is to address https://bugs.launchpad.net/cloud-images/+bug/1569237
  # If "they" sort out the lack of the "vagrant" username in future, we should
  # revert this back as well as the use of the "vagrant" username in all
  # provisioning scripts
  #config.ssh.insert_key = false # problem
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
