## 📄 08-trusts.md

### Secciones principales:

1. **Preparación Segundo DC**:
   - Hostname: ls03trust
   - Dominio: lab03trust.local
   - IP: 192.168.2.3
   - Configurar red, hosts, NTP

2. **Provisión**:
   ```bash
   sudo samba-tool domain provision --use-rfc2307 --interactive
   # Realm: lab03trust.local
   ```

3. **Configuración DNS** (Reenviadores Condicionales):
   ```bash
   # En ls03 (192.168.2.2):
   sudo samba-tool dns zonecreate 192.168.2.2 lab03trust.local
   sudo samba-tool dns add 192.168.2.2 lab03trust.local @ NS ls03trust.lab03trust.local
   sudo samba-tool dns add 192.168.2.2 lab03trust.local ls03trust A 192.168.2.3
   
   # En ls03trust (192.168.2.3):
   sudo samba-tool dns zonecreate 192.168.2.3 lab03.local
   sudo samba-tool dns add 192.168.2.3 lab03.local @ NS ls03.lab03.local
   sudo samba-tool dns add 192.168.2.3 lab03.local ls03 A 192.168.2.2
   ```

4. **Creación del Trust**:
   ```bash
   sudo samba-tool domain trust create lab03trust.local \
       -U Administrator@LAB03TRUST.LOCAL --type=forest
   ```

5. **Verificación**:
   ```bash
   sudo samba-tool domain trust list
   sudo samba-tool domain trust validate lab03.local
   smbclient //ls03trust.lab03trust.local/StudentDocs -U bob@lab03.local -W LAB03
   ```

**Evidencias:**
- `netplan_ls03trust.png`
- `etc_hosts_trust.png`
- `hosts_final.png`
- `krb_lab03trust.png`
- `serv_adm_kerb_lab03trust.png`
- `serv_kerb_lab03trust.png`
- `krb_serv2_cli.png`
- `forwarders_ls03.png`
- `output_interactive_trust.png`
- `verif_samba_ad_cd_trust.png`

---
[⬅️ Anterior: Recursos Compartidos](07-recursos-compartidos.md) | [📚 Índice](README.md) | [➡️ Siguiente: Auditoría](09-auditoria.md)
