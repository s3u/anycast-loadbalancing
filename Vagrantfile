Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = "ubuntu/trusty64"

  # This is the router that the client nodes u1 and u2 use to reach servers s1 or s2.
  config.vm.define "cr1" do |config|
    config.vm.hostname = "cr1"
    config.vm.box = "cumulus-vx-2.5.3"

    config.vm.network "private_network", :ip => "10.20.1.11", :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.10.12.11", :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.10.13.11", :netmask => "255.255.255.0"
    config.vm.provision "bgp", type: "shell", path: "cr1.sh"
  end

  config.vm.define "r2" do |config|
    config.vm.hostname = "r2"
    config.vm.network "private_network", :ip => "10.20.2.12", :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.10.12.12", :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.30.1.2", :netmask => "255.255.255.0", :virtualbox__intnet => "r2"
    config.vm.provision "bgp", type: "shell", path: "r2.sh"
  end
  
  config.vm.define "r3" do |config|
    config.vm.hostname = "r3"
    config.vm.network "private_network", :ip => "10.20.3.13",   :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.10.13.13",   :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.30.1.2",   :netmask => "255.255.255.0", :virtualbox__intnet => "r3"
    config.vm.provision "bgp", type: "shell", path: "r3.sh"
  end

  # Server with anycast IP 10.30.1.3
  config.vm.define "s1" do |config|
    config.vm.hostname = "s1"
    config.vm.network "private_network", :ip => "10.20.2.100",   :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.30.1.3",   :netmask => "255.255.255.0", :virtualbox__intnet => "r2"
    config.vm.provision "bgp", type: "shell", path: "s1.sh"
  end

  # Another server with anycast IP 10.30.1.3
  config.vm.define "s2" do |config|
    config.vm.hostname = "s2"
    config.vm.network "private_network", :ip => "10.20.3.100",   :netmask => "255.255.255.0"
    config.vm.network "private_network", :ip => "10.30.1.3",   :netmask => "255.255.255.0", :virtualbox__intnet => "r3"
   config.vm.provision "bgp", type: "shell", path: "s2.sh"
  end

  # Client node using cr1 as the default gateway
  config.vm.define "u1" do |config|
    config.vm.hostname = "u1"
    config.vm.network "private_network", :ip => "10.20.1.100",  :netmask => "255.255.255.0"
    config.vm.provision "shell", inline: "apt-get update; apt-get -y install traceroute"
    config.vm.provision "bgp", type: "shell", path: "user.sh"
  end

  # Client node using cr1 as the default gateway
  config.vm.define "u2" do |config|
    config.vm.hostname = "u2"
    config.vm.network "private_network", :ip => "10.20.1.101",   :netmask => "255.255.255.0"
    config.vm.provision "shell", inline: "apt-get update; apt-get -y install traceroute"
    config.vm.provision "bgp", type: "shell", path: "user.sh"
  end
end
