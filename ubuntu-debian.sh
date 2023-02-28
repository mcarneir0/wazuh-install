#!/bin/bash
set -euo pipefail

export WAZUH_MANAGER=''
export WAZUH_PROTOCOL=''
export WAZUH_AGENT_GROUP=''

install_packages() {
  # Verifica se os pacotes curl e gpg já estão instalados
  if ! dpkg -s curl gpg >/dev/null 2>&1; then
    printf "\n=== Instalando pacotes curl e gpg ===\n\n"
    apt-get update
    apt-get install --assume-yes curl gpg
  fi
}

import_gpg_key() {
  printf "\n=== Importando chave GPG do Wazuh ===\n\n"
  curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | \
    gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && \
    chmod 644 /usr/share/keyrings/wazuh.gpg
}

add_wazuh_repo() {
  printf "\n=== Adicionando repositório do Wazuh ===\n\n"
  printf "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | \
    tee -a /etc/apt/sources.list.d/wazuh.list
  apt-get update
}

install_wazuh_agent() {
  printf "\n=== Instalando agente do Wazuh ===\n\n"
  apt-get install --assume-yes wazuh-agent
}

start_wazuh_agent_service() {
  printf "\n=== Iniciando serviço do Wazuh ===\n\n"
  systemctl daemon-reload
  systemctl enable wazuh-agent
  systemctl start wazuh-agent
  systemctl status wazuh-agent
}

install_packages
import_gpg_key
add_wazuh_repo
install_wazuh_agent
start_wazuh_agent_service
