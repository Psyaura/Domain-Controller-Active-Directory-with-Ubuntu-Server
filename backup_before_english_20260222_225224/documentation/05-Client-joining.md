## 📄 05-Client-joining.md

### Main Sections:

1. **Objective**: Join Linux and Windows clients to lab03.local domain

2. **Ubuntu Desktop Client**:
   - Package installation: `realmd sssd sssd-tools samba-common krb5-user packagekit samba-common-bin adcli`
   - Configure `/etc/resolv.conf` → point to DC
   - Configure `/etc/hosts` → add DC
   - Configure `/etc/krb5.conf` → realm LAB03.LOCAL
   - Command: `realm discover lab03.local`
   - Command: `sudo realm join lab03.local -U Administrator --verbose`
   - Verification: `realm list`, `id bob@lab03.local`
   - PAM: `sudo pam-auth-update --enable mkhomedir`
   - GDM: Edit `/etc/pam.d/gdm-password` to create home directory

3. **Windows Client**:
   - DNS configuration → DC IP
   - Domain joining from Control Panel
   - RSAT installation for gpmc.msc

## 📸 Evidence

The following screenshots document this process:
```
📂 evidence/04-clients/
├── realm_discover.png                  - lab03.local domain discovery
├── realm_join.png                      - Ubuntu client joining the domain
├── realm_list.png                      - Verification of joined domain
├── id_comprobacion.png                 - id command verifying domain user
└── pam_sesion_grafica.png              - Graphical login with domain user
```

---

[⬅️ Previous: User Management](04-User-management.md) | [📚 Index](README.md) | [➡️ Next: GPOs](06-GPOs.md)
