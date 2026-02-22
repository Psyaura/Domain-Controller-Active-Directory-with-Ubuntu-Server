## 📄 03-Samba-AD-DC.md

# 03 - Samba AD DC Installation and Configuration

## Objective

Promote the Ubuntu server to Domain Controller using Samba AD.

## Package Installation

- apt install samba krb5-user winbind smbclient dnsutils
- Kerberos configuration during installation
- Explain each package

## DNS Preparation

- Stop systemd-resolved
- Configure resolv.conf

## Domain Provisioning

- samba-tool domain provision
- Parameters: Realm, Domain, Server Role, etc.

## Post-Provisioning Configuration

- Copy krb5.conf
- Configure interfaces in smb.conf
- Start samba-ad-dc

## Verification

- samba-tool domain level show
- host -t SRV _ldap._tcp.lab03.local
- kinit administrator
- klist

## 📸 Evidence

The following screenshots document this process:
```
📂 evidencias/02-configuracion/
├── SAMBA-AD running.png                - samba-ad-dc service active and running
├── dns_query.png                       - Successful DNS queries to domain
├── kinit.png                           - Kerberos ticket obtained with kinit
├── kerberos_tcp_lab03.png              - Kerberos SRV records in DNS
├── kerb_realm_cli.png                  - Kerberos realm configuration
├── krb.png                             - Configured /etc/krb5.conf file
├── krb_serv_cli.png                    - Kerberos server verification
└── smbclient_show_net_folders.png      - Shared resources netlogon and sysvol
```

[⬅️ Previous: Network Configuration](02-Network-configuration.md) | [📚 Index](README.md) | [➡️ Next: User Management](04-User-management.md)
