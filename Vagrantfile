# -*- mode: ruby -*-
# vi: set ft=ruby :
disk1 = './disk-0-1.vdi'
disk2 = './disk-0-2.vdi'
disk3 = './disk-0-3.vdi'
Vagrant.configure("2") do |config|
  # Base VM OS configuration.
  config.ssh.insert_key = false
  config.vm.synced_folder '.', '/vagrant', disabled: true
  # General VirtualBox VM configuration.
  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.cpus = 1
    v.linked_clone = true
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  # server1.
  config.vm.define "server1" do |server1|
    server1.vm.box = "m1k3bu11/CentOS8.3-Workstation"
    server1.vm.hostname = "server1.test"
    server1.vm.network :private_network, ip: "192.168.2.3"
    #server1.vm.provision "shell",
    #  inline: "sudo yum update -y"
    server1.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 768]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--vram", 12]
      v.customize ["modifyvm", :id, "--accelerate3d", "off"]
    end
  end
  # Server2.
  config.vm.define "server2" do |server2|
    server2.vm.box = "m1k3bu11/CentOS8.3-Workstation"
    server2.vm.hostname = "server2.test"
    server2.vm.network :private_network, ip: "192.168.2.4"
    #server2.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
    #server2.vm.provision "shell",
    #  inline: "sudo yum update -y"
    server2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 768]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--vram", 12]
      v.customize ["modifyvm", :id, "--accelerate3d", "off"]
      unless File.exist?(disk1)
        v.customize ['createhd', '--filename', disk1, '--variant', 'Fixed', '--size', 2 * 1024]
        v.customize ['createhd', '--filename', disk2, '--variant', 'Fixed', '--size', 1 * 1024]
        v.customize ['createhd', '--filename', disk3, '--variant', 'Fixed', '--size', 1 * 1024]
        v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', disk1]
        v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', disk2]
        v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', disk3]
      end
    end
  end

# Gnome box.
  # Workstation.
  config.vm.define "workstation" do |workstation|
    workstation.vm.hostname = "workstation.test"
    workstation.vm.network :private_network, ip: "192.168.2.5"
    config.vm.box = "m1k3bu11/CentOS8.3-Workstation"
    config.ssh.insert_key = false
    workstation.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [".git/", "disk-0-1.vdi", "disk-0-2.vdi", "disk-0-3.vdi"]
    workstation.vm.provision "shell",
      inline: "sudo cp /vagrant/ansible.cfg /etc/ansible/ansible.cfg"
#    workstation.vm.provision "shell",
#      inline: "ansible all -i /vagrant/inventory -m ping"
    workstation.vm.provision "shell",
      inline: "ansible-playbook -i /vagrant/inventory /vagrant/playbooks/master.yml"
    workstation.vm.provision "shell",
      inline: "ansible-playbook -i /vagrant/inventory /vagrant/playbooks/master.yml"
    workstation.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 4096]
    end
  end
end
