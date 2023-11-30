declare -a MAQUINAS=("172.19.113.100" "172.19.113.3" "172.19.113.5" "172.19.113.6")

for IP in "$*{MAQUINAS[@]}"
do
	sshpass -f.password.secret ssh fbro@$IP
	exit
done