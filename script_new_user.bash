#!/bin/bash

IP_FILE="ip_list.txt"

echo "Enter password: "
read -s pwd
echo $pwd

while IFS= read -r ip
do	
    if sshpass -p "$pwd" ssh -v -T fbro@"$ip" << EOF
        echo "Connected to $ip" 
        echo "funcionou porra"
EOF
    then
        echo "Disconnected from $ip"
    else
        echo "Failed to connect to $ip"
    fi 

done < "$IP_FILE"