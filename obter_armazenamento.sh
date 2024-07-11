#!/bin/bash

# Arquivo com a lista de IPs
ARQUIVO_IP=$(cat ip_list.txt)

# Solicitar a senha do usuário fbro
echo "Digite a senha do usuário fbro: "
read -s FBRO_SENHA

# Função para pegar usuários e armazenamento
obter_usuarios_e_armazenamento() {
    sshpass -p "$FBRO_SENHA" ssh -o StrictHostKeyChecking=no -T fbro@"$1" "
        echo '$FBRO_SENHA' | sudo -S du -sh /home/* 2>/dev/null | awk '{print \$2\": \"\$1}'
    "
}

echo -e "\nOBTENDO USUÁRIOS E USO DE ARMAZENAMENTO DE TODAS AS MÁQUINAS\n"

# Loop através dos IPs
for ip in $ARQUIVO_IP
do
    # Remove espaços em branco à direita do endereço IP
    ip=$(echo "$ip" | sed -e 's/[[:space:]]*$//')

    # Pula linhas vazias
    if [[ -n "${ip}" ]]; then
        echo "Conectando a $ip..."
        if resultado=$(obter_usuarios_e_armazenamento "$ip")
        then
            echo -e "Dados de $ip:\n$resultado\n"
        else
            echo "Falha ao obter dados de $ip"
        fi
    fi

done