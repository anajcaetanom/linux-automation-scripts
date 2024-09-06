#!/bin/bash

IP_FILE=$(cat ip_list.txt)

echo -e "\nGERANDO RELATÓRIO REMOTO\n\n"

echo "Digite a senha para o usuário fbro: "
read -s FBRO_PASS

# Arquivo final que irá armazenar todos os relatórios
FINAL_REPORT="relatorio_final.txt"

# Limpar o conteúdo do arquivo final (se existir)
> "$FINAL_REPORT"

for ip in $IP_FILE
do
    # Remover espaços em branco do final do endereço IP
    ip=$(echo "$ip" | sed -e 's/[[:space:]]*$//')

    # Pular linhas vazias
    if [[ -n "${ip}" ]]; then
        # Gerar relatório remoto
        if sshpass -p "$FBRO_PASS" ssh -o StrictHostKeyChecking=no -T fbro@"$ip" "
            echo 'Relatório de utilização - $(date)' > /tmp/relatorio_$ip.txt
            last -10 >> /tmp/relatorio_$ip.txt
            echo 'Uso de CPU e Memória:' >> /tmp/relatorio_$ip.txt
            top -b -n 1 | head -15 >> /tmp/relatorio_$ip.txt
        "
        then
            echo -e "\n=== Relatório de $ip ===\n" >> "$FINAL_REPORT"
            
            # Transferir o conteúdo do relatório remoto diretamente para o arquivo final
            sshpass -p "$FBRO_PASS" ssh -o StrictHostKeyChecking=no fbro@"$ip" "cat /tmp/relatorio_$ip.txt" >> "$FINAL_REPORT"
            echo "Relatório de $ip adicionado ao arquivo final"
        else
            echo "Falha ao gerar relatório na máquina $ip"
        fi
    fi
done
