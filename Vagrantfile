# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils'
require 'pathname'

#making sure the dependencies exist
unless Vagrant.has_plugin?("vagrant-hostmanager")
  system("vagrant plugin install vagrant-hostmanager")
  puts "Hostmanager dependencies installed!, try the command again now"
  exit
end

#creating keys allowing inter-cluster ssh
if ARGV[0] == "up"
    puts "Info: attempting to create ssh keys"
    system('./keys/create-keys.sh')
end

#Checking if a configuration file exists, if it does, then read its attribute values
#Otherwise use default values

pn = Pathname.new("./vg_config.rb")
CONFIG = File.expand_path(pn)
if File.exist?(CONFIG)
  require CONFIG
  puts "Info: vagrant_config file is found, and will be used" if ARGV[0] == "up"

  MASTER_VM_COUNT=1
  MASTER_VM_MEMORY=$master_vm_memory
  MASTER_VM_CPU=$master_vm_cpu

  WORKER_VM_COUNT=$worker_vm_count
  WORKER_VM_MEMORY=$worker_vm_memory
  WORKER_VM_CPU=$worker_vm_cpu


  THE_BOX=$thebox

else
  puts "Info: vagrant_config file is missing, vagrant will use default values" if ARGV[0] == "up"

  MASTER_VM_COUNT=1
  MASTER_VM_MEMORY=2048
  MASTER_VM_CPU=2

  WORKER_VM_COUNT=2
  WORKER_VM_MEMORY=1024
  WORKER_VM_CPU=1


  THE_BOX="ubuntu/xenial64"
end

Vagrant.configure("2") do |config|
  config.vm.box = THE_BOX
  config.vm.box_check_update = false
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  
  private_key_path = File.join(Dir.pwd, "/keys", "id_rsa")
  public_key_path = File.join(Dir.pwd, "/keys", "id_rsa.pub")
  #insecure_key_path = File.join(Dir.home, ".vagrant/", "insecure_private_key")
  
  private_key = IO.read(private_key_path)
  public_key = IO.read(public_key_path)

  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true



  config.vm.define "master-node" do |c|
      c.vm.hostname = "master-node"
      c.vm.network "private_network", ip: "192.168.10.2"
      c.vm.network "forwarded_port", guest: 9090, host: 9090
      c.vm.network "forwarded_port", guest: 9080, host: 9080
      config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"      
      c.vm.provision :shell, :path => "ansible-install.sh"
     
      config.vm.provision :shell, :inline => <<-SCRIPT
        set -e
    
        echo '#{private_key}' > /home/ubuntu/.ssh/id_rsa
        chmod 600 /home/ubuntu/.ssh/id_rsa
        chown ubuntu /home/ubuntu/.ssh/id_rsa
    
        echo '#{public_key}' >> /home/ubuntu/.ssh/authorized_keys
        chmod 600 /home/ubuntu/.ssh/authorized_keys

      SCRIPT

      config.vm.provider "virtualbox" do |vb|
        vb.cpus = MASTER_VM_CPU
        vb.memory = MASTER_VM_MEMORY
      end
    end


  (1..WORKER_VM_COUNT).each do |i|
    config.vm.define "worker-node#{i}" do |node|
        node.vm.hostname = "worker-node#{i}"
        node.vm.network "private_network", ip: "192.168.10.#{i+2}"
        node.vm.network "forwarded_port", guest: "9000", host: "900#{i}"
        config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
        node.vm.provision "shell", inline: "apt-get update"
        node.vm.provision "shell", inline: "apt install -y python"
        
      
        config.vm.provision :shell, :inline => <<-SCRIPT
          set -e
      
          echo '#{private_key}' > /home/ubuntu/.ssh/id_rsa
          chmod 600 /home/ubuntu/.ssh/id_rsa
          chown ubuntu /home/ubuntu/.ssh/id_rsa
      
          echo '#{public_key}' >> /home/ubuntu/.ssh/authorized_keys
          chmod 600 /home/ubuntu/.ssh/authorized_keys
        SCRIPT

        config.vm.provider "virtualbox" do |vb|
            vb.cpus = WORKER_VM_CPU
            vb.memory = WORKER_VM_MEMORY
        end
    end
  end
end
