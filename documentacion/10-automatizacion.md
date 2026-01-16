## 📄 10-automatizacion.md

### Secciones principales:

1. **Script de Backup**:
   ```bash
   sudo nano /root/backup_samba.sh
   ```
   - Variables: DIR_DESTINO, LOG_FILE, DIAS_A_GUARDAR
   - Comando tar: `/bin/tar -czf $RUTA_COMPLETA /var/lib/samba /etc/samba`
   - Verificación con `$?`
   - Limpieza con find y -mtime

2. **Hacer Ejecutable**:
   ```bash
   sudo chmod +x /root/backup_samba.sh
   ```

3. **Programar con Cron**:
   ```bash
   sudo crontab -e
   # Añadir:
   15 9 * * * /root/backup_samba.sh
   ```
   - Formato: m h dom mon dow command

4. **Monitorización**:
   ```bash
   sudo apt install htop
   htop  # Filtrar con F4: "samba"
   ```

5. **Gestión Remota de Procesos**:
   ```bash
   ssh bob@lab03.local@lc03.lab03.local
   ps -aux | grep bob
   kill -19 <PID>  # Pausar
   kill -18 <PID>  # Reanudar
   kill -9 <PID>   # Terminar
   ```

**Evidencias:**
- `backup.png`
- `htop.png`
- `ssh_cliente_bob.png`
- `top-bash.png`
- `stop_sl.png`

---
[⬅️ Anterior: Auditoría](09-auditoria.md) | [📚 Índice](README.md)
