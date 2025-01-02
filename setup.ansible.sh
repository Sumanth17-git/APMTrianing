#!/bin/bash

# Update and install prerequisites
sudo apt update -y
sudo apt install -y git maven openjdk-17-jdk curl iputils-ping python3 python3-pip openssh-client software-properties-common

# Verify installations
mvn -version
java -version

# Add Ansible PPA and install Ansible
sudo add-apt-repository ppa:ansible/ansible --yes --update
sudo apt install -y ansible
sudo apt install -y ansible-core

# Verify Ansible installation
ansible --version

# Create Ansible user and configure permissions
sudo useradd -m -s /bin/bash ansible
sudo usermod -aG sudo ansible

# Add no-password sudo privileges for Ansible user
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Switch to Ansible user and generate SSH keys
su - ansible -c "ssh-keygen -t rsa -b 4096 -q -N ''"

# Configure Ansible settings
sudo bash -c 'cat << EOF > /etc/ansible/ansible.cfg
[defaults]
remote_user = ansible
become = True
become_method = sudo
EOF'

# Disable Ansible user password
echo "ansible:$(openssl rand -base64 32)" | sudo chpasswd -e

# Add local host to Ansible hosts
sudo bash -c 'cat << EOF > /etc/ansible/hosts
[mytargets]
localhost ansible_connection=local
EOF'

# Test Ansible setup
ansible -i /etc/ansible/hosts mytargets -m ping

# Create and run a sample playbook
sudo bash -c 'cat << EOF > /home/ansible/sample_playbook.yml
---
- name: Test Playbook
  hosts: mytargets
  tasks:
    - name: Ping localhost
      ping:
EOF'

ansible-playbook -i /etc/ansible/hosts /home/ansible/sample_playbook.yml

echo "Ansible setup completed successfully."
