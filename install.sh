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


if prompt_y_n "Start Traefik? [Y/n]" 0; then
    cd traefik
    ln_env_and_start_compose
fi

if prompt_y_n "Start Pi-hole? [Y/n]" 0; then
    cd pihole
    ln_env_and_start_compose
fi

if prompt_y_n "Start fail2ban? [Y/n]" 0; then
    cd fail2ban
    ln_env_and_start_compose
fi

if prompt_y_n "Start Vaultwarden? [Y/n]" 0; then
    cd vaultwarden
    ln_env_and_start_compose
fi

if prompt_y_n "Start WireGuard? [Y/n]" 0; then
    cd wireguard
    ln_env_and_start_compose
fi

if prompt_y_n "Start website (I mean, you probably don't want this but who am I to judge)? [y/N]" 1; then
    cd website
    ln_env_and_start_compose
fi