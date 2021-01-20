# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "generic/ubuntu1804"
  config.vm.hostname = "lucidum-deployment-seed-testing"
  config.vm.synced_folder "~/.aws", "/home/vagrant/.aws"
  config.vm.synced_folder ".", "/home/vagrant/seed"
  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = "1024"
  end
  config.vm.provision "shell", inline: <<-SCRIPT
    apt update
    apt install awscli -y
    wget -nv https://releases.hashicorp.com/terraform/0.14.4/terraform_0.14.4_linux_amd64.zip
    unzip -o terraform_0.14.4_linux_amd64.zip -d /usr/local/bin
    terraform --version
    aws --version
  SCRIPT
end

