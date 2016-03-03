# -*- mode: ruby -*-
# vi: set ft=ruby :

# Followed this pattern for loading vagrant configuration
# http://www.invokemedia.com/injecting-external-variables-into-a-vagrant-configuration-file/

require 'yaml'

vconfig = YAML::load_file("./vagrant_config.yaml")

#puts vconfig
#puts vconfig['shares']['software']
#puts vconfig['vm']['memory']

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Base box to use
  config.vm.box = vconfig['box']['name']
  
  config.vm.box_url = vconfig['box']['box_url']

  # Do not check for box updates
  config.vm.box_check_update = vconfig['box']['box_update']

  # config.vm.hostname = vconfig['vm']['hostname']

  # Ports Forwarded from Guest to Host - Mapping
  vconfig['port_mappings'].each do |key, value|
    config.vm.network "forwarded_port", guest: key, host: value, auto_correct: true
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: vconfig['vm']['ip_address']

  # Share
  vconfig['shares'].each do |key, value|
    config.vm.synced_folder value, "/" + key
  end
  
  # Virtual Box specific customizations
  config.vm.provider "virtualbox" do |vb|
     vb.gui = true
     vb.name = vconfig['vm']['name']
     vb.customize ["modifyvm", :id, "--memory", vconfig['vm']['memory']]
     vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  
  # Setting the hostname 
  # config.vm.provision :shell, :inline => "hostname " + vconfig['vm']['hostname']

  # Restart the network, this runs even during a normal, vagrant up/reload even without a provision
  # config.vm.provision :shell, :inline => "service network restart", run: "always"

  # Updating git configs
  # vconfig['gitconfig'].each do |key, value|
  #  config.vm.provision :shell, :inline => "su - vagrant -c 'git config --global --replace-all " + key + " \"" + value +"\"'"
  # end
  config.vm.provision :shell, :inline => "su - vagrant -c 'git config --global color.ui auto'"
  config.vm.provision :shell, :inline => "su - vagrant -c 'git config --global merge.tool meld'"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.

  config.vm.provision "puppet" do |puppet|
   # puppet.options = "--trace --debug --hiera_config=/vagrant/hiera_config.yaml"
   # Comment the line below and Uncomment the above to enable more detailed debugging/trace information 
    puppet.options = "--hiera_config=/vagrant/hiera_config.yaml"
    puppet.manifests_path  = "manifests"
    puppet.module_path  = ["modules/forge", "modules/custom"]
    puppet.manifest_file  = "site.pp"
    # puppet.hiera_config_path = "hiera_config.yaml"
    puppet.working_directory = "/vagrant"
    puppet.facter = {
      "environment" => "local", 
      "datadirprefix" => "/vagrant",
      "root_install_directory" => "/opt",
      "oracle_root_install_directory" => "/opt/oracle/product"
    }
  end
end
