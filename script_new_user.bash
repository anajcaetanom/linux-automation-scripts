#!/bin/bash

IP_FILE="ip_list.txt"

echo -e "\n\nCREATING NEW USER\n\n"

echo "Enter new username: "
read username
echo "Enter fbro password: "
read -s fbro_password

while IFS= read -r ip
do	

    # Trim trailing whitespace from the IP address
    ip=$(echo "$ip" | sed -e 's/[[:space:]]*$//')

    # Skip over empty lines
    if [[ -n "${ip}" ]]; then

        if sshpass -p "$fbro_password" ssh -o StrictHostKeyChecking=no -T fbro@"$ip" << EOF
            echo "Connected to $ip" 
            USERNAME=$username
            PASSWORD=1234
            useradd -m -s /bin/bash $USERNAME
            echo -e -n "${PASSWORD}\n${PASSWORD}" | passwd $USERNAME

EOF
        then
            echo "Disconnected from $ip"
        else
            echo "Failed to connect to $ip"
        fi 
    fi

done < "$IP_FILE"