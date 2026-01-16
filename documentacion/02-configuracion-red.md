## 📄 02-configuracion-red.md

### Secciones principales:

**Ya tienes este archivo completo como ejemplo**, pero aquí está el resumen:

1. **Objetivo**: Configurar IP estática en adaptador de red interna

2. **Identificar Interfaces de Red**:
   ```bash
   ip addr show
   # enp0s3: Adaptador 1 (Internet)
   # enp0s8: Adaptador 2 (Dominio)
   ```

3. **Configuración con Netplan**:
   - Backup: `sudo cp /etc/netplan/00-installer-config.yaml{,.backup}`
   - Editar: `sudo nano /etc/netplan/00-installer-config.yaml`
   - Configuración:
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
   - Validar: `sudo netplan --debug generate`
   - Aplicar: `sudo netplan apply`

4. **Deshabilitar IPv6**:
   ```bash
   sudo nano /etc/sysctl.conf
   # Añadir:
   net.ipv6.conf.all.disable_ipv6 = 1
   net.ipv6.conf.default.disable_ipv6 = 1
   net.ipv6.conf.lo.disable_ipv6 = 1
   
   sudo sysctl -p
   ```

5. **Configurar Hostname**:
   ```bash
   sudo hostnamectl set-hostname ls03
   hostnamectl
   ```

6. **Configurar /etc/hosts**:
   ```bash
   sudo nano /etc/hosts
   ```
   Contenido:
   ```
   127.0.0.1       localhost
   127.0.1.1       ls03
   172.30.20.32    ls03.lab03.local ls03
   ```

7. **Verificación Final**:
   ```bash
   ip addr show
   ip route show
   hostname --fqdn
   ping -c 4 172.30.20.32
   ping -c 4 8.8.8.8
   ```

**Evidencias:**
- `netplan_ls03trust.png` (o equivalente para ls03)
- `Cambiar-el-nombre-host.png`
- `hosts_cli.png`
- `red_interna_cli.png`
- `resolv_cli.png`
- `etc-resolv.png`
- `hosts_final.png`

---

[⬅️ Anterior: Instalación Base](01-instalacion-base.md) | [📚 Índice](README.md) | [➡️ Siguiente: Samba AD DC](03-samba-ad-dc.md)
