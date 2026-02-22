## 📄 10-Automation.md

### Main Sections:

1. **Backup Script**:
```bash
   sudo nano /root/backup_samba.sh
```
   - Variables: DIR_DESTINO, LOG_FILE, DIAS_A_GUARDAR
   - tar command: `/bin/tar -czf $RUTA_COMPLETA /var/lib/samba /etc/samba`
   - Verification with `$?`
   - Cleanup with find and -mtime

2. **Make Executable**:
```bash
   sudo chmod +x /root/backup_samba.sh
```

3. **Schedule with Cron**:
```bash
   sudo crontab -e
   # Add:
   15 9 * * * /root/backup_samba.sh
```
   - Format: m h dom mon dow command

4. **Monitoring**:
```bash
   sudo apt install htop
   htop  # Filter with F4: "samba"
```

5. **Remote Process Management**:
```bash
   ssh bob@lab03.local@lc03.lab03.local
   ps -aux | grep bob
   kill -19 <PID>  # Pause
   kill -18 <PID>  # Resume
   kill -9 <PID>   # Terminate
```

## 📸 Evidence

The following screenshots document this process:
```
📂 evidencias/08-auditoria/
├── backup.png                          - Backup script executed and verified
├── htop.png                            - Samba process monitoring with htop
├── ssh_cliente_bob.png                 - Remote SSH connection to client as bob
├── top-bash.png                        - top command showing system processes
└── stop_sl.png                         - Process paused/resumed with kill
```

---

[⬅️ Previous: Auditing](09-Auditing.md) | [📚 Index](README.md)
