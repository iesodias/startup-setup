#!/bin/bash

# Nome do grupo de recursos e da VM
resource_group="mdc-vm-rg"
vm_name="mdc-vm"
script_url="https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh"

# Verificar se o grupo de recursos já existe
if ! az group show --name $resource_group &>/dev/null; then
  echo "O grupo de recursos $resource_group não existe. Criando..."
  az group create --name $resource_group --location eastus

  # Adicionar um atraso de 10 segundos após a criação do grupo de recursos
  sleep 10
else
  echo "O grupo de recursos $resource_group já existe."
fi

# Verificar se a VM já existe
if az vm show --resource-group $resource_group --name $vm_name &>/dev/null; then
  echo "A VM $vm_name já existe no grupo de recursos $resource_group."
else
  echo "A VM $vm_name não existe no grupo de recursos $resource_group. Criando..."

  # Criar a VM no Azure sem execução do script de inicialização
  az vm create \
    --resource-group $resource_group \
    --name $vm_name \
    --image Ubuntu2204 \
    --admin-username iesodias \
    --admin-password "MinhaSenhaieso123!" \
    --size Standard_B1s \
    --no-wait

  # Adicionar um atraso de 60 segundos após a criação da VM
  sleep 60

  echo "Criação da VM concluída."
fi

# Adicionar a extensão customScript para executar o script de inicialização
az vm extension set \
  --resource-group $resource_group \
  --vm-name $vm_name \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings "{\"fileUris\": [\"$script_url\"], \"commandToExecute\": \"bash startupscript.sh\"}" \
  --no-wait

echo "Adicionada a extensão customScript para execução do script de inicialização após a criação da VM."

# Obter o endereço IP público da VM
ip_address=$(az vm show \
  --resource-group $resource_group \
  --name $vm_name \
  --show-details \
  --query 'publicIps' \
  --output tsv)

echo "Endereço IP da VM: $ip_address"
