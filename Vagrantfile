# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

required_plugins = ["vagrant-hosts", "vagrant-hostmanager"]
required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    # Attempt to install plugin. Bail out on failure to prevent an infinite loop.
    system("vagrant plugin install #{plugin}") || exit!

    # Relaunch Vagrant so the plugin is detected. Exit with the same status code.
    exit system('vagrant', *ARGV)
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |vbox, override|
    override.vm.box = "debian/jessie64"
    vbox.memory = 700
    vbox.cpus = 2

    # Enable multiple guest CPUs if available
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
  end

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
      sh /tmp/install_salt.sh -M -P git v2016.11.3
    SHELL
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
	sh /tmp/install_salt.sh -P git v2016.11.3
      SHELL
    end
  end

end
