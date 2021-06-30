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
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 1
    libvirt.memory = 1024
  end
  # server1.
  config.vm.define "server1" do |server1|
    server1.vm.box = "codeup/CentOS"
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
    server1.vm.provider :libvirt do |libvirt|
      libvirt.memory = 786
      libvirt.cpus = 1
      libvirt.video_vram = 12
    end
  end
  # Server2.
  config.vm.define "server2" do |server2|
    server2.vm.box = "codeup/CentOS"
    server2.vm.hostname = "server2.test"
    server2.vm.network :private_network, ip: "192.168.2.4"
    #server2.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
    #server2.vm.provision "shell",
    #  inline: "sudo yum update -y"
    server2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 1]
      v.customize ["modifyvm", :id, "--vram", 12]
      v.customize ["modifyvm", :id, "--accelerate3d", "off"]
      unless File.exist?(disk1)
        v.customize ['createhd', '--filename', disk1, '--variant', 'Fixed', '--size', 2 * 1024]
        v.customize ['createhd', '--filename', disk2, '--variant', 'Fixed', '--size', 5 * 1024]
        v.customize ['createhd', '--filename', disk3, '--variant', 'Fixed', '--size', 1 * 1024]
        v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', disk1]
        v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', disk2]
        v.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', disk3]
      end
    end
    server2.vm.provider :libvirt do |libvirt|
      libvirt.memory = 786
      libvirt.cpus = 1
      libvirt.video_vram = 12
      libvirt.storage :file, :size => '2G', :bus => 'sata', :device => 'sdb'
      libvirt.storage :file, :size => '4G', :bus => 'sata', :device => 'sdc'
      libvirt.storage :file, :size => '1G', :bus => 'sata', :device => 'sdd'
    end
  end

# Gnome box.
  # Workstation.
  config.vm.define "workstation" do |workstation|
    workstation.vm.hostname = "workstation.test"
    workstation.vm.network :private_network, ip: "192.168.2.5"
    config.vm.box = "codeup/CentOS"
    config.ssh.insert_key = false
    workstation.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [".git/", "disk-0-1.vdi", "disk-0-2.vdi", "disk-0-3.vdi"]
    workstation.vm.provision "shell",
      inline: "sudo cp /vagrant/ansible.cfg /etc/ansible/ansible.cfg"
    workstation.vm.provision "shell",
      inline: "sudo cp /vagrant/inventory /etc/ansible/inventory"
    workstation.vm.provision "shell",
      inline: "chmod +x /vagrant/provision.sh"
    workstation.vm.provision "shell",
      inline: "bash /vagrant/provision.sh"
    workstation.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 4096]
      v.customize ["modifyvm", :id, "--cpus", 2]
      v.customize ["modifyvm", :id, "--vram", 128]
      v.customize ["modifyvm", :id, "--accelerate3d", "on"]
    end
    workstation.vm.provider :libvirt do |libvirt|
      libvirt.memory = 4096
      libvirt.cpus = 2
      libvirt.video_vram = 128
    end
  end
end
