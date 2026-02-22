## 📄 02-Network-configuration.md

### Main Sections:

**You already have this complete file as an example**, but here's the summary:

1. **Objective**: Configure static IP on internal network adapter

2. **Identify Network Interfaces**:
```bash
   ip addr show
   # enp0s3: Adapter 1 (Internet)
   # enp0s8: Adapter 2 (Domain)
```

3. **Configuration with Netplan**:
   - Backup: `sudo cp /etc/netplan/00-installer-config.yaml{,.backup}`
   - Edit: `sudo nano /etc/netplan/00-installer-config.yaml`
   - Configuration:
```yaml
   network:
     version: 2
     ethernets:
       enp0s3:
         dhcp4: yes
         dhcp6: no
       enp0s8:
         dhcp4: no
         dhcp6: no
         addresses:
           - 172.30.20.32/25
         routes:
           - to: default
             via: 172.30.20.1
         nameservers:
           addresses:
             - 127.0.0.1
             - 10.239.3.7
```
   - Validate: `sudo netplan --debug generate`
   - Apply: `sudo netplan apply`

4. **Disable IPv6**:
```bash
   sudo nano /etc/sysctl.conf
   # Add:
   net.ipv6.conf.all.disable_ipv6 = 1
   net.ipv6.conf.default.disable_ipv6 = 1
   net.ipv6.conf.lo.disable_ipv6 = 1
   
   sudo sysctl -p
```

5. **Configure Hostname**:
```bash
   sudo hostnamectl set-hostname ls03
   hostnamectl
```

6. **Configure /etc/hosts**:
```bash
   sudo nano /etc/hosts
```
   Content:
```
   127.0.0.1       localhost
   127.0.1.1       ls03
   172.30.20.32    ls03.lab03.local ls03
```

7. **Final Verification**:
```bash
   ip addr show
   ip route show
   hostname --fqdn
   ping -c 4 172.30.20.32
   ping -c 4 8.8.8.8
```

## 📸 Evidence

The following screenshots document this process:
```
📂 evidencias/02-configuracion/
├── netplan_ls03trust.png               - Netplan configuration (static IP)
├── Cambiar-el-nombre-host.png          - hostnamectl set-hostname command
├── hosts_cli.png                       - /etc/hosts file content
├── red_interna_cli.png                 - enp0s8 adapter configuration
├── resolv_cli.png                      - /etc/resolv.conf file
├── etc-resolv.png                      - System DNS configuration
└── hosts_final.png                     - Final configured /etc/hosts file
```

[⬅️ Previous: Base Installation](01-Installing.md) | [📚 Index](README.md) | [➡️ Next: Samba AD DC](03-samba-ad-dc.md)
