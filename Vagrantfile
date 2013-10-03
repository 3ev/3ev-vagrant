Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :public_network, ip: ENV["VAGRANT_IP"]
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "3ev-dev"]
  end
  
  #config.vm.synced_folder "~/projects/", "/var/www/vhosts", id: "vagrant-root", nfs: true
  config.vm.synced_folder "~/projects/", "/var/www/vhosts", id: "vagrant-root",
      :owner => "vagrant",
      :group => "www-data",
      :mount_options => ["dmode=775","fmode=664"]

  config.vm.provision :shell, :inline =>
    "if [[ ! -f /apt-get-run ]]; then sudo apt-get update && sudo touch /apt-get-run; fi"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.options = ['--verbose']
  end
end
