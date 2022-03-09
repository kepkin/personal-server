SERVER_ENDPOINT="<PUBLIC_IP>:51820"
SERVER_PUBLIC_KEY=$(cat /etc/wireguard/keys/publickey )

PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo ${PRIVATE_KEY} | wg pubkey)

BASE_IP=10.0.0.2
CLIENTS_NUM=$(ls -1 /etc/wireguard/clients/ | wc -l)
CLIENT_IP=$(python3 increment_ip.py $BASE_IP $CLIENTS_NUM)

cat << __EOF__  | cat >  /etc/wireguard/clients/$1.conf
[Interface]
PrivateKey = ${PRIVATE_KEY}
Address = ${CLIENT_IP}/24
DNS = 8.8.8.8

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = ${SERVER_ENDPOINT}
__EOF__

cat << __EOF__  | cat >>  /etc/wireguard/wg0.conf
# $1
[Peer]
PublicKey = ${PUBLIC_KEY}
AllowedIPs = ${CLIENT_IP}/24

__EOF__




qrencode -t ansiutf8 < /etc/wireguard/clients/$1.conf
