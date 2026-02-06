## 📄 07-recursos-compartidos.md

### Secciones principales:

#### 0. **Añadir Disco Dedicado para Recursos Compartidos**

**En VirtualBox (VM apagada)**:
- Crear disco virtual: 15 GB, VDI, Dynamically allocated
- Nombre: `Linux Server AD_1.vdi`
- Añadir a Controller SATA

**En Ubuntu Server**:
```bash
# Identificar disco
lsblk  # Debe aparecer /dev/sdb

# Particionar
sudo fdisk /dev/sdb
# Comandos: n → p → 1 → [Enter] → +10G → w

# Formatear
sudo mkfs.ext4 /dev/sdb1

# Crear punto de montaje
sudo mkdir -p /srv/samba
sudo mount /dev/sdb1 /srv/samba

# Configurar montaje automático
sudo blkid /dev/sdb1  # Copiar UUID
sudo nano /etc/fstab
# Añadir: UUID=xxx  /srv/samba  ext4  defaults  0  2

# Verificar
sudo mount -a
df -h | grep samba
```

#### 1. **Preparación del Servidor**
```bash
# Crear estructura de directorios
sudo mkdir -p /srv/samba/{StudentDocs,ITDocs,HRDocs,Public}

# Instalar librerías winbind
sudo apt-get install libnss-winbind libpam-winbind
sudo ldconfig
```

Editar `/etc/samba/smb.conf` en `[global]`:
```ini
winbind use default domain = yes
template shell = /bin/bash
template homedir = /home/%U
```

Configurar permisos (3770):
```bash
sudo chown :Students /srv/samba/StudentDocs
sudo chmod 3770 /srv/samba/StudentDocs

sudo chown :IT_Admins /srv/samba/ITDocs
sudo chmod 3770 /srv/samba/ITDocs

sudo chown :HR /srv/samba/HRDocs
sudo chmod 3770 /srv/samba/HRDocs

sudo chown :"Domain Users" /srv/samba/Public
sudo chmod 3777 /srv/samba/Public
```

**Explicación permisos (3770)**: SetGID + Sticky Bit + rwxrwx---

#### 2. **Configuración smb.conf**

Añadir al final de `/etc/samba/smb.conf`:
```ini
[StudentDocs]
    path = /srv/samba/StudentDocs
    read only = no
    vfs objects = acl_xattr full_audit
    map acl inherit = yes
    valid users = @Students
    force group = Students
    create mask = 0660
    directory mask = 0770
    # Auditoría con full_audit

[ITDocs]
    path = /srv/samba/ITDocs
    read only = no
    vfs objects = acl_xattr
    valid users = @IT_Admins
    force group = IT_Admins

[HRDocs]
    path = /srv/samba/HRDocs
    valid users = @HR
    force group = HR

[Public]
    path = /srv/samba/Public
    valid users = @"Domain Users"
```

Reiniciar: `sudo smbcontrol all reload-config`

#### 3. **Gestión de ACLs desde Windows**

- Explorador → `\\lab03.local`
- Click derecho en carpeta → Propiedades → Seguridad
- Editar → Añadir grupos (Students, IT_Admins, etc.)
- Configurar permisos (Modificar, Lectura, Escritura)
- Denegar acceso a grupos específicos si es necesario

#### 4. **Montaje Automático en Cliente Linux**
```bash
sudo apt install libpam-mount cifs-utils
sudo nano /etc/security/pam_mount.conf.xml
```

Configurar volúmenes por grupo:
```xml
<volume user="*" sgrp="students@lab03.local" 
        fstype="cifs" 
        server="lab03.local" 
        path="StudentDocs" 
        mountpoint="~/StudentDocs" 
        options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID)" />
```

Verificación: `mount | grep cifs`

## 📸 Evidencias

Las siguientes capturas documentan este proceso:
```
📂 evidencias/06-recursos/
├── disk-creation-vbox.png              [NUEVO] - Creación disco en VirtualBox
├── disk-partition-fdisk.png            [NUEVO] - Particionado con fdisk
├── disk-format-mkfs.png                [NUEVO] - Formateo del disco
├── disk-mount-fstab.png                [NUEVO] - Configuración en fstab
├── directory-structure-data.png        [NUEVO] - Estructura en /srv/samba
├── directory-permissions.png           [NUEVO] - Permisos 3770 configurados
├── smb.conf.png                        - Configuración smb.conf
├── Network_folders_windows.png         - Carpetas vistas desde Windows
├── error_domain_users_group.png        - Solución error Domain Users
├── windows-acl-security.png            [RECOMENDADO] - Pestaña Seguridad
├── windows-acl-students.png            [RECOMENDADO] - Permisos Students
├── linux-pam-mount-config.png          [RECOMENDADO] - pam_mount.conf.xml
├── linux-auto-mount.png                [RECOMENDADO] - Carpetas montadas
└── linux-mounted-shares.png            [RECOMENDADO] - mount | grep cifs
```

---

[⬅️ Anterior: GPOs](06-gpos.md) | [📚 Índice](README.md) | [➡️ Siguiente: Trusts](08-trusts.md)
