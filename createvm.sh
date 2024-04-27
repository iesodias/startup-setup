#!/bin/bash

# Nome do grupo de recursos e da VM
resource_group="mdc-vm-rg"
vm_name="mdc-vm"

# Verificar se o grupo de recursos já existe
if ! az group show --name $resource_group &>/dev/null; then
  echo "O grupo de recursos $resource_group não existe. Criando..."
  az group create --name $resource_group --location eastus
else
  echo "O grupo de recursos $resource_group já existe."
fi

# Verificar se a VM já existe
if az vm show --resource-group $resource_group --name $vm_name &>/dev/null; then
  echo "A VM $vm_name já existe no grupo de recursos $resource_group."
  echo "Atualizando a VM com o script de inicialização baixado..."

  # Baixar o script de inicialização do link
  curl -sSL https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh -o startupscript.sh

  # Atualizar a VM com o script de inicialização baixado
  az vm extension set \
    --resource-group $resource_group \
    --vm-name $vm_name \
    --name customScript \
    --publisher Microsoft.Azure.Extensions \
    --settings "{\"fileUris\": [\"https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh\"], \"commandToExecute\": \"bash startupscript.sh\"}" \
    --no-wait

  echo "Atualização da VM com o script de inicialização concluída."
else
  echo "A VM $vm_name não existe no grupo de recursos $resource_group. Continuando com a criação..."

  # Baixar o script de inicialização do link
  curl -sSL https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh -o startupscript.sh

  # Verificar se o download foi bem-sucedido
  if [ $? -eq 0 ]; then
    echo "Download do script de inicialização concluído."
    
    # Criar a VM no Azure com o script de inicialização
    az vm create \
      --resource-group $resource_group \
      --name $vm_name \
      --image Ubuntu2204 \
      --admin-username iesodias \
      --admin-password "MinhaSenhaieso123!" \
      --size Standard_B1s \
      --custom-data startupscript.sh \
      --no-wait

    # Obter o endereço IP público da VM
    ip_address=$(az vm show \
      --resource-group $resource_group \
      --name $vm_name \
      --show-details \
      --query 'publicIps' \
      --output tsv)

    echo "Endereço IP da VM: $ip_address"
  else
    echo "Erro ao baixar o script de inicialização."
  fi
fi
