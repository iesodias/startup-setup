#!/bin/bash

# Nome do grupo de recursos e da VM
resource_group="mdc-vm-rg"
vm_name="mdc-vm"

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

  # Criar a VM no Azure
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

  # Baixar o script de inicialização do link
  curl -sSL https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh -o startupscript.sh

  # Exibir o conteúdo do script baixado (apenas para debug)
  cat startupscript.sh

  # Executar o script de inicialização baixado (apenas para debug)
  bash startupscript.sh

  # Exibir mensagem após a execução do script (apenas para debug)
  echo "Script startupscript.sh executado."

  # Atualizar a VM com o script de inicialização baixado
  az vm extension set \
    --resource-group $resource_group \
    --vm-name $vm_name \
    --name customScript \
    --publisher Microsoft.Azure.Extensions \
    --settings "{\"fileUris\": [\"https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh\"], \"commandToExecute\": \"bash startupscript.sh\"}" \
    --no-wait

  echo "Atualização da VM com o script de inicialização concluída."

  # Reiniciar a VM
  az vm restart --resource-group $resource_group --name $vm_name --no-wait

  echo "Reiniciando a VM..."
fi

# Obter o endereço IP público da VM
ip_address=$(az vm show \
  --resource-group $resource_group \
  --name $vm_name \
  --show-details \
  --query 'publicIps' \
  --output tsv)

echo "Endereço IP da VM: $ip_address"

