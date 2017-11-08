#!/bin/bash
apt-get update
apt install -y ansible
apt install -y python
sudo chown -R ubuntu:ubuntu /usr/bin/python
if [ ! -f /etc/ansible/ansible.cfg ]; then
    echo "ansible config file not found in /etc/ansible/ansible.cfg!"    
else
    echo "modifying ansible config file..."
    sudo sed -i '/host_key_checking/s/^#//g'  /etc/ansible/ansible.cfg
fi
