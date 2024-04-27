#!/bin/bash

# Atualizar pacotes
sudo apt-get update

# Instalar Docker
sudo apt-get install -y docker.io

# Adicionar o usuário ao grupo Docker
sudo usermod -aG docker $USER

# Reiniciar o Docker
sudo systemctl restart docker

# Instalar Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Instalar AWS CLI
sudo apt-get install -y awscli

# Instalar Terraform
sudo apt-get install -y unzip
wget https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip
unzip terraform_1.1.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_1.1.0_linux_amd64.zip

# Instalar Ansible
sudo apt-get install -y ansible
