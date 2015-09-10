# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

unless Vagrant.has_plugin?("vagrant-hostmanager")
  system("vagrant plugin install vagrant-hostmanager") || exit!
  exit system('vagrant', *ARGV)
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |vbox, override|
    override.vm.box = "ubuntu/trusty64"
    vbox.memory = 1024
    vbox.cpus = 2

    # Enable multiple guest CPUs if available
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  config.vm.define "master" do |master|
    master.vm.hostname = "salt-master.example.com"
    master.vm.network :private_network, ip: "192.168.101.100"
    master.hostmanager.aliases = ["salt"]
    master.vm.synced_folder "salt", "/srv/salt"
    master.vm.provision "hosts" do |hosts|
        hosts.add_host '192.168.101.100', ['salt-master.example.com','salt']
    end
    master.vm.provision "shell", inline: <<-SHELL
      sed -i '/127.0.1.1/d' /etc/hosts
      curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
      sh /tmp/install_salt.sh -M -P git develop
    SHELL
    #master.vm.provision "shell", inline: "yum install -y salt-master"
  end

  2.times do |n|
    node_index = n+1
    config.vm.define "minion#{node_index}" do |node|
      node.vm.hostname = "minion#{node_index}.example.com"
      node.vm.network :private_network, ip: "192.168.101.#{200 + n}"
      node.vm.provision "hosts" do |hosts|
          hosts.add_host "192.168.101.#{200 + n}", ["minion#{node_index}.example.com"]
          hosts.add_host '192.168.101.100', ['salt-master.example.com','salt']
      end
      node.vm.provision "shell", inline: <<-SHELL
        sed -i '/127.0.1.1/d' /etc/hosts
        curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
        sh /tmp/install_salt.sh -P git develop
      SHELL
    end
  end
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

end
