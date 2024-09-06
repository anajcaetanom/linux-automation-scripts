#!/bin/bash

# Arquivo individual para cada máquina

IP_FILE=$(cat ip_list.txt)

echo -e "\nCRIANDO NOVO USUÁRIO E GERANDO RELATÓRIO\n\n"

echo "Digite a senha para o usuário fbro: "
read -s FBRO_PASS

for ip in $IP_FILE
do
    # Remover espaços em branco do final do endereço IP
    ip=$(echo "$ip" | sed -e 's/[[:space:]]*$//')

    # Pular linhas vazias
    if [[ -n "${ip}" ]]; then
        # Criar usuário remoto e gerar relatório
        if sshpass -p "$FBRO_PASS" ssh -o StrictHostKeyChecking=no -T fbro@"$ip" "
            echo 'Relatório de utilização - $(date)' > /tmp/relatorio_$ip.txt
            last >> /tmp/relatorio_$ip.txt
            echo 'Uso de CPU e Memória:' >> /tmp/relatorio_$ip.txt
            top -b -n 1 | head -15 >> /tmp/relatorio_$ip.txt
        "
        then
            # Baixar o relatório gerado
            sshpass -p "$FBRO_PASS" scp -o StrictHostKeyChecking=no fbro@"$ip":/tmp/relatorio_$ip.txt ./relatorio_$ip.txt
            echo "Relatório de $ip salvo como 'relatorio_$ip.txt'"
        else
            echo "Falha ao criar usuário ou gerar relatório na máquina $ip"
        fi
    fi
done
