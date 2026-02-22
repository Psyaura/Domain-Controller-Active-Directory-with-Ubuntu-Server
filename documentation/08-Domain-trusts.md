## 📄 08-Domain-trusts.md

### Main Sections:

1. **Second DC Preparation**:
   - Hostname: ls03trust
   - Domain: lab03trust.local
   - IP: 192.168.2.3
   - Configure network, hosts, NTP

2. **Provisioning**:
```bash
   sudo samba-tool domain provision --use-rfc2307 --interactive
   # Realm: lab03trust.local
```

3. **DNS Configuration** (Conditional Forwarders):
```bash
   # On ls03 (192.168.2.2):
   sudo samba-tool dns zonecreate 192.168.2.2 lab03trust.local
   sudo samba-tool dns add 192.168.2.2 lab03trust.local @ NS ls03trust.lab03trust.local
   sudo samba-tool dns add 192.168.2.2 lab03trust.local ls03trust A 192.168.2.3
   
   # On ls03trust (192.168.2.3):
   sudo samba-tool dns zonecreate 192.168.2.3 lab03.local
   sudo samba-tool dns add 192.168.2.3 lab03.local @ NS ls03.lab03.local
   sudo samba-tool dns add 192.168.2.3 lab03.local ls03 A 192.168.2.2
```

4. **Trust Creation**:
```bash
   sudo samba-tool domain trust create lab03trust.local \
       -U Administrator@LAB03TRUST.LOCAL --type=forest
```

5. **Verification**:
```bash
   sudo samba-tool domain trust list
   sudo samba-tool domain trust validate lab03.local
   smbclient //ls03trust.lab03trust.local/StudentDocs -U bob@lab03.local -W LAB03
```

## 📸 Evidence

The following screenshots document this process:
```
📂 evidence/07-trusts/
├── netplan_ls03trust.png               - Network configuration of second DC (ls03trust)
├── etc_hosts_trust.png                 - /etc/hosts file with both domains
├── hosts_final.png                     - Final hosts configuration on both servers
├── krb_lab03trust.png                  - Kerberos configuration for lab03trust.local domain
├── serv_adm_kerb_lab03trust.png        - Kerberos admin server for trust
├── serv_kerb_lab03trust.png            - Kerberos server for trust domain
├── krb_serv2_cli.png                   - Second Kerberos server CLI
├── forwarders_ls03.png                 - Configured DNS conditional forwarders
├── output_interactive_trust.png        - Output from domain trust create command
└── verif_samba_ad_cd_trust.png         - Trust verification with trust validate
```

---

[⬅️ Previous: Shared Resources](07-Shared-resources.md) | [📚 Index](README.md) | [➡️ Next: Auditing](09-Auditing.md)
