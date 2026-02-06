## 📄 09-auditoria.md

### Secciones principales:

1. **Configuración de Auditoría**:
   - Editar smb.conf en [StudentDocs]:
   ```ini
   vfs objects = acl_xattr full_audit
   full_audit:prefix = %u|%I|%m|%S
   full_audit:success = mkdirat renameat unlinkat pwrite
   full_audit:failure = connect
   full_audit:facility = local7
   full_audit:priority = NOTICE
   ```

2. **Configuración rsyslog**:
   ```bash
   sudo nano /etc/rsyslog.d/samba-audit.conf
   # Contenido:
   local7.notice   /var/log/samba_audit.log
   & stop
   ```

3. **Preparar archivo de log**:
   ```bash
   sudo touch /var/log/samba_audit.log
   sudo chown syslog:adm /var/log/samba_audit.log
   sudo chmod 640 /var/log/samba_audit.log
   sudo systemctl restart rsyslog
   ```

4. **Visualización**:
   ```bash
   sudo tail -f /var/log/samba_audit.log
   sudo grep "unlinkat" /var/log/samba_audit.log
   ```

5. **Políticas de Seguridad**:
   ```bash
   samba-tool domain passwordsettings show
   sudo samba-tool domain passwordsettings set --complexity=on
   sudo samba-tool domain passwordsettings set --min-pwd-length=10
   ```

## 📸 Evidencias

Las siguientes capturas documentan este proceso:
```
📂 evidencias/08-auditoria/
├── prep_auditoria.png                  - Preparación del sistema de auditoría
├── smb_conf_audit.png                  - Configuración de full_audit en smb.conf
└── smb_audit_log.png                   - Logs de auditoría en /var/log/samba_audit.log
```

---
[⬅️ Anterior: Trusts](08-trusts.md) | [📚 Índice](README.md) | [➡️ Siguiente: Automatización](10-automatizacion.md)
