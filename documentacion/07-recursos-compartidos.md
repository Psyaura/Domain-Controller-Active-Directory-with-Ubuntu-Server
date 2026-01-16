## 📄 07-recursos-compartidos.md

### Secciones principales:

1. **Preparación del Servidor**:
   ```bash
   sudo mkdir -p /srv/samba/{StudentDocs,ITDocs,HRDocs,Public}
   sudo apt-get install libnss-winbind libpam-winbind
   sudo chown :Students /srv/samba/StudentDocs
   sudo chmod 3770 /srv/samba/StudentDocs
   ```

2. **Configuración smb.conf**:
   ```ini
   [StudentDocs]
       path = /srv/samba/StudentDocs
       read only = no
       vfs objects = acl_xattr
       map acl inherit = yes
       valid users = @Students
       force group = Students
       create mask = 0660
       directory mask = 0770
   ```

3. **Gestión de ACLs desde Windows**:
   - Explorador → `\\lab03.local`
   - Click derecho → Propiedades → Seguridad
   - Editar permisos por grupo

4. **Montaje Automático en Linux**:
   ```bash
   sudo apt install libpam-mount cifs-utils
   sudo nano /etc/security/pam_mount.conf.xml
   ```
   - Configurar volúmenes por grupo (students@lab03.local, etc.)

**Evidencias:**
- `smb.conf.png`
- `Network_folders_windows.png`
- `error_domain_users_group.png`

---
[⬅️ Anterior: GPOs](06-gpos.md) | [📚 Índice](README.md) | [➡️ Siguiente: Trusts](08-trusts.md)
