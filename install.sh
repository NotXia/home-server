#! /bin/bash

prompt_y_n () {
    read -p "$1 " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo
        return 0
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo
        return 1
    else
        return $2
    fi
}

ln_env_and_start_compose () {
    cd $1
    ln -s ../.env .env
    docker compose up -d
    cd ..
}

cat << EOF
Home server installation setup. 
The following operations will be done:
  - Creation of a local CA and signed certificate for the local domain.
  - Initialization of Traefik.
  - Initialization of Pi-hole.
  - Initialization of fail2ban.
  - Initialization of Vaultwarden.
  - Initialization of WireGuard.
  - Initialization of Who's there?.
EOF


if ! prompt_y_n "Proceed? [y/N]" 1; then
    exit 0
fi

# Load .env
export $(grep -v '^#' .env | xargs)


echo "Creating local CA"
cd local-cert
./create-ca-cert.sh
./create-signed-cert.sh $LOCAL_DOMAIN
cd ..


echo ">>>>>>>>>> Starting Traefik <<<<<<<<<<"
ln_env_and_start_compose traefik


echo ">>>>>>>>>> Starting Pi-hole <<<<<<<<<<"
# Add local domain and subdomains DNS record
mkdir -p pihole/etc.dnsmasq.d
echo "address=/$LOCAL_DOMAIN/$LOCAL_IP" >> pihole/etc-dnsmasq.d/local-domain.conf
ln_env_and_start_compose pihole


echo ">>>>>>>>>> Starting fail2ban <<<<<<<<<<"
ln_env_and_start_compose fail2ban


echo ">>>>>>>>>> Starting Vaultwarden <<<<<<<<<<"
ln_env_and_start_compose vaultwarden


echo ">>>>>>>>>> Starting WireGuard <<<<<<<<<<"
ln_env_and_start_compose wireguard


echo ">>>>>>>>>> Starting Who's there? <<<<<<<<<<"
cat > ./fail2ban/config/fail2ban/action.d/whos-there.local << EOF
[Definition]
actionban = curl -k -X POST <domain>/api/bans -H 'Content-Type: application/json' -d '{"ip": "<ip>", "jail_name": "%(name)s", "timestamp": <time>}'

[Init]
domain = https://localhost
EOF
cat > ./fail2ban/config/fail2ban/jail.local << EOF
[DEFAULT]

action = %(action_)s
         whos-there[domain="https://${WHOSTHERE_SUBDOMAIN}.${LOCAL_DOMAIN}"]
EOF
ln_env_and_start_compose whos-there
cd fail2ban
docker compose restart
cd ..


if prompt_y_n "Init my website (I mean, you probably don't want this but who am I to judge)? [y/N]" 1; then
    echo ">>>>>>>>>> Starting personal website <<<<<<<<<<"
    git submodule update website/notxia.github.io
    ln_env_and_start_compose website
fi

cat << EOF

!!!!! REMEMBER TO !!!!!
- Schedule backups (./backup.sh).
- Install the CA certificate (./local-cert/ca/local-ca.pem) on the local hosts.
!!!!!!!!!!!!!!!!!!!!!!!

EOF
