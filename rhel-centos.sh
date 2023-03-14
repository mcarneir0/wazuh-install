#!/bin/bash

set -euo pipefail

export WAZUH_MANAGER=''
export WAZUH_PROTOCOL=''
export WAZUH_AGENT_GROUP=''

import_gpg_key() {
  printf "\n=== Importando chave GPG do Wazuh ===\n\n"
  rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
  printf "Chave importada com sucesso!\n"
}

add_wazuh_repo() {
  printf "\n=== Adicionando repositório do Wazuh ===\n\n"
  cat > /etc/yum.repos.d/wazuh.repo << EOF
[wazuh]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=EL-\$releasever - Wazuh
baseurl=https://packages.wazuh.com/4.x/yum/
protect=1
EOF
  printf "Repositório adicionado com sucesso!\n"
}

install_wazuh_agent() {
  printf "\n=== Instalando agente do Wazuh ===\n\n"
  yum install -y wazuh-agent
}

start_wazuh_agent_service() {
  printf "\n=== Iniciando serviço do Wazuh ===\n\n"
  systemctl daemon-reload
  systemctl enable wazuh-agent
  systemctl start wazuh-agent
  systemctl status wazuh-agent
}

import_gpg_key
add_wazuh_repo
install_wazuh_agent
start_wazuh_agent_service
