#!/bin/bash

# Baixar o script de inicialização do link
curl -sSL https://raw.githubusercontent.com/iesodias/startup-setup/main/config_file_startup/startupscript.sh -o startupscript.sh

# Verificar se o download foi bem-sucedido
if [ $? -eq 0 ]; then
  echo "Download do script de inicialização concluído."
  
  # Criar a VM no Azure com o script de inicialização
  az vm create \
    --resource-group MeuGrupoRecursos \
    --name MinhaVM \
    --image UbuntuLTS \
    --admin-username meuusuario \
    --admin-password "MinhaSenha123!" \
    --size Standard_B1s \
    --location eastus \
    --custom-data startupscript.sh
else
  echo "Erro ao baixar o script de inicialização."
fi

