# Home server

My home server services setup.


## Services
| **Service** | **Description** |
|:-------:|:------------|
| Traefik | Reverse proxy |
| Pi-hole | DNS server |
| Local CA | Self-signed certificate for HTTPS on LAN |
| Vaultwarden | Password manager |
| WireGuard | VPN |
| fail2ban | Intrusion detection for SSH and Vaultwarden |


## Setup and installation

1. Rename `.env.example` to `.env`.
2. Fill the fields in `.env`.
3. Run:
    ```
    ./install.sh
    ```