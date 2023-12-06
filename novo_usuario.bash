#!/bin/bash

# echo criando usuário $1 com senha ${1}123
USERNAME=$1
PASSWORD=$2
useradd -m -s /bin/bash $USERNAME
echo -e -n "${PASSWORD}\n${PASSWORD}" | passwd $USERNAME
