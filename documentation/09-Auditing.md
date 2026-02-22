## 📄 09-Auditing.md

### Main Sections:

1. **Auditing Configuration**:
   - Edit smb.conf in [StudentDocs]:
```ini
   vfs objects = acl_xattr full_audit
   full_audit:prefix = %u|%I|%m|%S
   full_audit:success = mkdirat renameat unlinkat pwrite
   full_audit:failure = connect
   full_audit:facility = local7
   full_audit:priority = NOTICE
```

2. **rsyslog Configuration**:
```bash
   sudo nano /etc/rsyslog.d/samba-audit.conf
   # Content:
   local7.notice   /var/log/samba_audit.log
   & stop
```

3. **Prepare log file**:
```bash
   sudo touch /var/log/samba_audit.log
   sudo chown syslog:adm /var/log/samba_audit.log
   sudo chmod 640 /var/log/samba_audit.log
   sudo systemctl restart rsyslog
```

4. **Visualization**:
```bash
   sudo tail -f /var/log/samba_audit.log
   sudo grep "unlinkat" /var/log/samba_audit.log
```

5. **Security Policies**:
```bash
   samba-tool domain passwordsettings show
   sudo samba-tool domain passwordsettings set --complexity=on
   sudo samba-tool domain passwordsettings set --min-pwd-length=10
```

## 📸 Evidence

The following screenshots document this process:
```
📂 evidence/08-auditing/
├── prep_auditoria.png                  - Auditing system preparation
├── smb_conf_audit.png                  - full_audit configuration in smb.conf
└── smb_audit_log.png                   - Audit logs in /var/log/samba_audit.log
```

---

[⬅️ Previous: Domain Trusts](08-Domain-trusts.md) | [📚 Index](README.md) | [➡️ Next: Automation](10-Automation.md)
