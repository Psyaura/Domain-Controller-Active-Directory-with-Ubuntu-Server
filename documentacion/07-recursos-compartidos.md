 07 - Recursos Compartidos y Permisos con Disco Dedicado

## 📋 Índice
- [Objetivo](#objetivo)
- [Requisitos Previos](#requisitos-previos)
- [Añadir Disco Dedicado](#0-añadir-disco-dedicado-para-recursos-compartidos)
- [Preparación del Servidor](#1-preparación-del-servidor)
- [Configuración smb.conf](#2-configuración-smbconf)
- [Gestión de ACLs desde Windows](#3-gestión-de-acls-desde-windows)
- [Montaje Automático en Linux](#4-montaje-automático-en-cliente-linux)
- [Verificación del Disco](#5-verificación-del-disco-dedicado)
- [Solución de Problemas](#6-solución-de-problemas)
- [Evidencias](#evidencias)
- [Ventajas del Disco Dedicado](#ventajas-del-disco-dedicado)
- [Próximos Pasos](#próximos-pasos)

---

## 🎯 Objetivo

Implementar un **sistema de recursos compartidos** (file server) en el dominio Active Directory utilizando un **disco dedicado** para almacenamiento, configurar **permisos granulares** mediante ACLs de Windows, y habilitar el **montaje automático** en clientes Linux según la pertenencia a grupos.

Esta configuración profesional separa los datos del sistema operativo, mejora el rendimiento y facilita la gestión de backups.

---

## ✅ Requisitos Previos

Antes de comenzar:

- ✅ Dominio Active Directory funcionando (Fases 01-04 completadas)
- ✅ Usuarios y grupos creados (Students, IT_Admins, HR, Domain Users)
- ✅ Clientes Linux y Windows unidos al dominio
- ✅ Acceso de administrador al servidor (ls03)
- ✅ VirtualBox instalado para añadir el disco adicional

---

## 💾 0. Añadir Disco Dedicado para Recursos Compartidos

### En VirtualBox (con el servidor apagado):

#### 1. Crear el disco virtual:
```
VirtualBox → Seleccionar VM "ls03" → Settings → Storage
Controller: SATA
→ Click en el icono de disco con "+"
→ Create new disk
```

#### 2. Configuración del nuevo disco:
- **Tipo**: VDI (VirtualBox Disk Image)
- **Storage**: Dynamically allocated
- **Tamaño**: **15 GB** (para almacenamiento de datos)
- **Nombre**: `Linux Server AD_1.vdi`

#### 3. Verificar:
Debe aparecer un segundo disco en el controlador SATA.

---

### En Ubuntu Server (arrancar la VM):

#### 4. Identificar el nuevo disco:
```bash
lsblk
```

**Salida esperada:**
```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   20G  0 disk 
├─sda1   8:1    0    1M  0 part 
├─sda2   8:2    0    2G  0 part /boot
└─sda3   8:3    0   18G  0 part /
sdb      8:16   0   15G  0 disk     ← NUEVO DISCO
```

#### 5. Particionar el disco:
```bash
sudo fdisk /dev/sdb
```

**Comandos dentro de fdisk:**
```
n    (nueva partición)
p    (primaria)
1    (número de partición)
[Enter]    (primer sector - por defecto)
+10G       (tamaño de la partición: 10 GB)
w    (escribir y salir)
```

#### 6. Formatear la partición:
```bash
sudo mkfs.ext4 /dev/sdb1
```

**Salida esperada:**
```
Creating filesystem with 2621440 4k blocks and 655360 inodes
Filesystem UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
...
Writing superblocks and filesystem accounting information: done
```

#### 7. Crear punto de montaje:
```bash
sudo mkdir -p /srv/samba
```

#### 8. Montar el disco temporalmente:
```bash
sudo mount /dev/sdb1 /srv/samba
```

#### 9. Verificar montaje:
```bash
df -h | grep sdb1
```

**Salida esperada:**
```
/dev/sdb1        9.8G   24K   9.3G   1% /srv/samba
```

#### 10. Configurar montaje automático (fstab):

**Obtener UUID del disco:**
```bash
sudo blkid /dev/sdb1
```

**Salida:**
```
/dev/sdb1: UUID="a1b2c3d4-e5f6-7890-abcd-ef1234567890" TYPE="ext4"
```

**Editar fstab:**
```bash
sudo nano /etc/fstab
```

**Añadir al final:**
```
# Disco dedicado para recursos compartidos Samba
UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890  /srv/samba  ext4  defaults  0  2
```

> **⚠️ Importante**: Reemplaza el UUID con el que obtuviste de tu disco.

**Guardar y verificar:**
```bash
sudo umount /srv/samba
sudo mount -a
df -h | grep samba
```

Si aparece montado correctamente, el disco se montará automáticamente en cada reinicio.

---

## 📁 1. Preparación del Servidor

### Crear estructura de directorios EN EL DISCO DEDICADO:

```bash
# Crear carpetas compartidas en el disco nuevo
sudo mkdir -p /srv/samba/StudentDocs
sudo mkdir -p /srv/samba/ITDocs
sudo mkdir -p /srv/samba/HRDocs
sudo mkdir -p /srv/samba/Public
```

### Instalar librerías winbind:

```bash
sudo apt-get install libnss-winbind libpam-winbind
sudo ldconfig
```

### Editar configuración global de Samba:

```bash
sudo nano /etc/samba/smb.conf
```

**Añadir en la sección `[global]`:**
```ini
[global]
    # ... configuración existente ...
    
    # Configuración para Winbind
    winbind use default domain = yes
    template shell = /bin/bash
    template homedir = /home/%U
```

### Configurar permisos base:

```bash
# Permisos SGID + Sticky Bit (3770)
sudo chown :Students /srv/samba/StudentDocs
sudo chmod 3770 /srv/samba/StudentDocs

sudo chown :IT_Admins /srv/samba/ITDocs
sudo chmod 3770 /srv/samba/ITDocs

sudo chown :HR /srv/samba/HRDocs
sudo chmod 3770 /srv/samba/HRDocs

sudo chown :"Domain Users" /srv/samba/Public
sudo chmod 3777 /srv/samba/Public
```

**Explicación de permisos (3770)**:
- **3**: SetGID (2) + Sticky Bit (1) → Hereda grupo + Protege borrado
- **7**: Propietario (rwx) → Control total
- **7**: Grupo (rwx) → Lectura, escritura, ejecución
- **0**: Otros → Sin acceso

**Verificar permisos:**
```bash
ls -la /srv/samba/
```

**Salida esperada:**
```
drwxrws--T  2 root Students     4096 Jan 15 10:00 StudentDocs
drwxrws--T  2 root IT_Admins    4096 Jan 15 10:00 ITDocs
drwxrws--T  2 root HR           4096 Jan 15 10:00 HRDocs
drwxrwsrwt  2 root Domain Users 4096 Jan 15 10:00 Public
```

---

## 📝 2. Configuración smb.conf

### Editar el archivo de configuración:

```bash
sudo nano /etc/samba/smb.conf
```

### Añadir al final (RUTAS APUNTANDO AL DISCO DEDICADO):

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
    # Auditoría
    full_audit:prefix = %u|%I|%m|%S
    full_audit:success = mkdirat renameat unlinkat pwrite
    full_audit:failure = connect
    full_audit:facility = local7
    full_audit:priority = NOTICE

[ITDocs]
    path = /srv/samba/ITDocs
    read only = no
    vfs objects = acl_xattr
    map acl inherit = yes
    valid users = @IT_Admins
    force group = IT_Admins
    create mask = 0660
    directory mask = 0770

[HRDocs]
    path = /srv/samba/HRDocs
    read only = no
    vfs objects = acl_xattr
    map acl inherit = yes
    valid users = @HR
    force group = HR
    create mask = 0660
    directory mask = 0770

[Public]
    path = /srv/samba/Public
    read only = no
    valid users = @"Domain Users"
    guest ok = no
```

### Reiniciar Samba:

```bash
sudo smbcontrol all reload-config
# O reiniciar completamente:
sudo systemctl restart samba-ad-dc
```

### Verificar recursos compartidos:

```bash
smbclient -L localhost -U%
```

**Debe mostrar:**
```
Sharename       Type      Comment
---------       ----      -------
StudentDocs     Disk      
ITDocs          Disk      
HRDocs          Disk      
Public          Disk      
netlogon        Disk      
sysvol          Disk      
IPC$            IPC       IPC Service (Samba 4.x.x)
```

---

## 🪟 3. Gestión de ACLs desde Windows

Desde un **cliente Windows unido al dominio**:

### Paso 1: Conectar al servidor

1. Abrir **Explorador de archivos**
2. En la barra de dirección escribir: `\\lab03.local` o `\\172.30.20.32`
3. Presionar Enter
4. Verás las carpetas compartidas: **StudentDocs**, **ITDocs**, **HRDocs**, **Public**

### Paso 2: Configurar permisos para StudentDocs

1. Click derecho en `StudentDocs` → **Propiedades**
2. Pestaña **Seguridad**
3. Click en **Editar**
4. Click en **Agregar**
5. Escribir: `Students` → **Comprobar nombres** → **Aceptar**
6. Seleccionar grupo `Students`
7. Marcar permisos:
   - ✅ **Modificar**
   - ✅ **Lectura y ejecución**
   - ✅ **Lectura**
   - ✅ **Escritura**
8. **Aplicar** → **Aceptar**

### Paso 3: Denegar acceso a un grupo (ejemplo Finance)

1. En la misma ventana de **Seguridad**
2. **Agregar** → Escribir: `Finance` → **Comprobar nombres**
3. Marcar en la columna **Denegar**:
   - ✅ **Control total** (esto deniega todo)
4. **Aplicar** → **Aceptar**

> **💡 Tip**: Las ACLs de Windows se almacenan en atributos extendidos del filesystem Linux (gracias a `vfs objects = acl_xattr`).

### Paso 4: Probar acceso

1. Crear un archivo de prueba en `StudentDocs` desde Windows
2. Verificar que usuarios del grupo Students pueden acceder
3. Verificar que usuarios de Finance NO pueden acceder

---

## 🐧 4. Montaje Automático en Cliente Linux

### Instalar paquetes necesarios:

```bash
sudo apt install libpam-mount cifs-utils
```

### Configurar pam_mount:

```bash
sudo nano /etc/security/pam_mount.conf.xml
```

**Contenido completo:**

```xml



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

```

### Verificar montaje automático:

1. **Cerrar sesión** en el cliente Linux
2. **Iniciar sesión** como `bob@lab03.local`
3. Abrir terminal y verificar:

```bash
# Ver montajes activos
mount | grep cifs
```

**Debe mostrar algo como:**
```
//lab03.local/StudentDocs on /home/bob@lab03.local/StudentDocs type cifs (rw,relatime,...)
//lab03.local/Public on /home/bob@lab03.local/Public type cifs (rw,relatime,...)
```

```bash
# Listar archivos
ls -la ~/StudentDocs
ls -la ~/Public
```

---

## ✅ 5. Verificación del Disco Dedicado

### En el servidor (ls03):

```bash
# Ver uso del disco de datos
df -h /srv/samba
```

**Salida esperada:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1       9.8G   24M  9.3G   1% /srv/samba
```

```bash
# Ver estructura
tree -L 2 /srv/samba
```

**Debe mostrar:**
```
/srv/samba
├── StudentDocs
├── ITDocs
├── HRDocs
└── Public
```

```bash
# Ver permisos
ls -la /srv/samba/
```

**Debe mostrar los permisos 3770 y los grupos correctos.**

---

## 🔧 6. Solución de Problemas

### ❌ Error: "Permission denied" al crear archivos en recursos

**Causa**: Permisos incorrectos en el filesystem Linux.

**Solución**:
```bash
# Verificar propietario y grupo
ls -la /srv/samba/StudentDocs

# Si el grupo no es correcto, corregir:
sudo chown :Students /srv/samba/StudentDocs
sudo chmod 3770 /srv/samba/StudentDocs
```

---

### ❌ Error: El disco no se monta al reiniciar

**Causa**: Error en `/etc/fstab`.

**Solución**:
```bash
# Verificar fstab
cat /etc/fstab | grep samba

# Montar manualmente para probar
sudo mount -a

# Ver errores
sudo journalctl -xe
```

---

### ❌ Error: No se puede montar en cliente Linux

**Causa**: Grupo no coincide con el formato de SSSD.

**Diagnóstico**:
```bash
# En el cliente, verificar formato del grupo
id bob@lab03.local
```

**Debe mostrar grupos como:** `students@lab03.local` (minúsculas)

**Solución**:
```bash
# En pam_mount.conf.xml, usar EXACTAMENTE ese formato
sgrp="students@lab03.local"  # minúsculas, con @lab03.local
```

---

## 📸 Evidencias

Las siguientes capturas documentan este proceso:

```
📂 evidencias/06-recursos/
├── disk-creation-vbox.png              [NUEVO] - Creación disco en VirtualBox
├── disk-partition-fdisk.png            [NUEVO] - Particionado con fdisk
├── disk-format-mkfs.png                [NUEVO] - Formateo del disco con mkfs.ext4
├── disk-mount-fstab.png                [NUEVO] - Configuración en /etc/fstab
├── directory-structure-data.png        [NUEVO] - Estructura en /srv/samba
├── directory-permissions.png           [NUEVO] - Permisos 3770 configurados
├── smb.conf.png                        - Configuración smb.conf con rutas /srv/samba
├── Network_folders_windows.png         - Carpetas compartidas vistas desde Windows
├── error_domain_users_group.png        - Solución al error Domain Users
├── windows-acl-security.png            [RECOMENDADO] - Pestaña Seguridad en Windows
├── windows-acl-students.png            [RECOMENDADO] - Permisos configurados para Students
├── linux-pam-mount-config.png          [RECOMENDADO] - Archivo pam_mount.conf.xml
├── linux-auto-mount.png                [RECOMENDADO] - Carpetas montadas automáticamente
└── linux-mounted-shares.png            [RECOMENDADO] - Salida de mount | grep cifs
```

---

## 🎯 Ventajas del Disco Dedicado

| Ventaja | Descripción |
|---------|-------------|
| **Separación de datos** | El sistema (/) y los datos (/srv/samba) están en discos separados |
| **Escalabilidad** | Fácil aumentar tamaño del disco o añadir más discos |
| **Backup selectivo** | Puedes hacer backup solo del disco de datos sin incluir el sistema |
| **Rendimiento** | Reduce la carga de I/O en el disco del sistema operativo |
| **Realismo** | Así se configura en entornos de producción reales |

---

---

[⬅️ Anterior: GPOs](06-gpos.md) | [📚 Índice](README.md) | [➡️ Siguiente: Trusts](08-trusts.md)

---

<div align="center">
<sub>Documentación Técnica - Recursos Compartidos con Disco Dedicado | Proyecto AD Ubuntu Server | 2025</sub>
</div>
