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
    ln -s ../.env .env
    docker compose up -d
    cd ..
}

cat << EOF
Home server installation setup. 
The following operations will be done:
  - Creation of a local CA and signed certificate.
  - Initialization of Traefik.
  - Initialization of Pi-hole.
  - Initialization of fail2ban.
  - Initialization of Vaultwarden.
  - Initialization of WireGuard.
EOF


if ! prompt_y_n "Proceed? [y/N]" 1; then
    exit 0
fi

# Load .env
export $(cat .env | xargs)

echo "Creating local CA"
cd local-cert
./create-ca-cert.sh
./create-signed-cert.sh $LOCAL_DOMAIN
cd ..

echo ">>>>>>>>>> Starting Traefik <<<<<<<<<<"
cd traefik
ln_env_and_start_compose

echo ">>>>>>>>>> Starting Pi-hole <<<<<<<<<<"
cd pihole
ln_env_and_start_compose

echo ">>>>>>>>>> Starting fail2ban <<<<<<<<<<"
cd fail2ban
ln_env_and_start_compose

echo ">>>>>>>>>> Starting Vaultwarden <<<<<<<<<<"
cd vaultwarden
ln_env_and_start_compose

echo ">>>>>>>>>> Starting WireGuard <<<<<<<<<<"
cd wireguard
ln_env_and_start_compose

if prompt_y_n "Init my website (I mean, you probably don't want this but who am I to judge)? [y/N]" 1; then
    echo ">>>>>>>>>> Starting personal website <<<<<<<<<<"
    git submodule update website/notxia.github.io
    cd website
    ln_env_and_start_compose
fi

cat << EOF

!!!!! Remember to install the CA certificate (./local-cert/ca/local-ca.pem) on the local hosts. !!!!!

EOF