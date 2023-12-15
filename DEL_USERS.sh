#!/bin/bash

IP_FILE=$(cat ip_list.txt)

USERNAME=$1

echo -e "\nDELETING USER\n\n"

echo "Enter fbro password: "
read -s FBRO_PASS

for ip in $IP_FILE
do
    # Trim trailing whitespace from the IP address
    ip=$(echo "$ip" | sed -e 's/[[:space:]]*$//')

    # Skip over empty lines
    if [[ -n "${ip}" ]]; then
        if sshpass -p "$FBRO_PASS" ssh -o StrictHostKeyChecking=no -T fbro@"$ip" "
            echo '$FBRO_PASS' | sudo -S userdel -r $USERNAME
        "
        then
            echo "User $USERNAME deleted on $ip"
        else
            echo "Failed to delete user $USERNAME on $ip"
        fi
    fi

done
