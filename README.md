# Home server

My home server services setup.


## Services
| **Service** | **Description** |
|:-------:|:------------|
| [Traefik](https://traefik.io/traefik/) | Reverse proxy |
| [Pi-hole](https://pi-hole.net/) | DNS server |
| Local CA | Self-signed certificate for HTTPS on LAN |
| [Vaultwarden](https://github.com/dani-garcia/vaultwarden) | Password manager |
| [WireGuard](https://www.wireguard.com/) | VPN |
| [fail2ban](https://github.com/fail2ban/fail2ban) | Intrusion detection for SSH and Vaultwarden |
| [Who's there?](https://github.com/NotXia/fail2ban-whos-there) | fail2ban monitoring |


## Setup and installation

1. Rename `.env.example` to `.env`.
2. Fill the fields in `.env`.
3. Run:
    ```
    ./install.sh
    ```