#!/bin/bash

IP_FILE=$(cat ip_list.txt)

USERNAME=$1

USER_PASS=$2 

echo -e "\nCREATING NEW USER\n\n"

echo "Enter fbro password: "
read -s FBRO_PASS

for ip in $IP_FILE
do
    # Trim trailing whitespace from the IP address
    ip=$(echo "$ip" | sed -e 's/[[:space:]]*$//')

    # Skip over empty lines
    if [[ -n "${ip}" ]]; then
        if sshpass -p "$FBRO_PASS" ssh -o StrictHostKeyChecking=no -T fbro@"$ip" "
            echo '$FBRO_PASS' | sudo -S useradd -m $USERNAME && echo '$USERNAME:$USER_PASS' | sudo chpasswd
        "
        then
            echo "User $USERNAME created on $ip with password '$USER_PASS'"
        else
            echo "Failed to create user $USERNAME on $ip"
        fi
    fi

done