# 🖥️ Domain Controller Active Directory con Ubuntu Server + Samba4

[![Ubuntu Server](https://img.shields.io/badge/Ubuntu%20Server-24.04%20LTS-E95420?logo=ubuntu)](https://ubuntu.com/)
[![Samba](https://img.shields.io/badge/Samba-4.x-A80030?logo=samba)](https://www.samba.org/)
[![Active Directory](https://img.shields.io/badge/Active%20Directory-Compatible-0078D4?logo=microsoft)](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/)
[![License](https://img.shields.io/badge/License-Educational-green)](LICENSE)

## 📌 Descripción del Proyecto

Este proyecto documenta la implementación completa de un **Controlador de Dominio (Domain Controller)** basado en **Ubuntu Server** utilizando **Samba Active Directory**. El objetivo es crear un entorno de autenticación centralizada completamente funcional que permita gestionar usuarios, grupos, políticas (GPOs), recursos compartidos y confianzas de dominio dentro de una red empresarial simulada.

Este repositorio incluye documentación técnica detallada, configuraciones paso a paso, scripts de automatización y evidencias visuales del proceso completo de implementación.

> [!NOTE]
> Este contenido está dedicado al ámbito educativo y de formación en administración de sistemas.

## 🎯 Objetivos del Proyecto

- ✅ **Instalación y configuración** de Ubuntu Server como Domain Controller
- ✅ **Implementación de Samba AD DC** con DNS integrado
- ✅ **Creación y gestión** de usuarios, grupos y Unidades Organizativas (OUs)
- ✅ **Configuración de políticas de grupo** (GPOs) en entorno híbrido Linux/Windows
- ✅ **Unión de clientes** Linux y Windows al dominio
- ✅ **Implementación de recursos compartidos** con ACLs y permisos avanzados
- ✅ **Configuración de confianzas de dominio** (Domain/Forest Trusts)
- ✅ **Auditoría y seguridad** con registro de eventos
- ✅ **Automatización de tareas** con Cron y scripts de backup
- ✅ **Gestión de procesos y monitorización** del sistema

## 🛠️ Tecnologías Utilizadas

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Ubuntu Server | 24.04 LTS | Sistema operativo base |
| Samba | 4.x | Active Directory Domain Services |
| Kerberos | 5 | Sistema de autenticación |
| Winbind | Latest | Integración de usuarios/grupos AD |
| SSSD | Latest | System Security Services Daemon |
| CIFS/SMB | 3.x | Protocolo de compartición de archivos |
| DNS (Samba Internal) | - | Resolución de nombres del dominio |
| VirtualBox | 7.x | Plataforma de virtualización |

## 📂 Estructura del Repositorio

```
Domain-Controller-Active-Directory-with-Ubuntu-Server/
├── README.md                          # Este archivo
├── documentacion/                     # Documentación técnica detallada
│   ├── 01-instalacion-base.md        # Instalación de Ubuntu Server
│   ├── 02-configuracion-red.md       # Configuración de red estática
│   ├── 03-samba-ad-dc.md             # Promoción a DC
│   ├── 04-gestion-usuarios.md        # Usuarios, grupos y OUs
│   ├── 05-union-clientes.md          # Unión de clientes al dominio
│   ├── 06-gpos.md                    # Políticas de grupo
│   ├── 07-recursos-compartidos.md    # File Server y permisos
│   ├── 08-trusts.md                  # Confianzas de dominio
│   ├── 09-auditoria.md               # Seguridad y logging
│   └── 10-automatizacion.md          # Scripts y tareas programadas
├── configuracion/                     # Archivos de configuración
│   ├── smb.conf                      # Configuración de Samba
│   ├── krb5.conf                     # Configuración de Kerberos
│   ├── netplan/                      # Configuraciones de red
│   ├── pam_mount.conf.xml            # Montaje automático de recursos
│   └── scripts/                      # Scripts de automatización
│       ├── backup_samba.sh           # Script de backup del AD
│       └── user_creation.sh          # Script de creación masiva de usuarios
├── evidencias/                        # Capturas de pantalla y pruebas
│   ├── 01-instalacion/               # Evidencias de instalación
│   ├── 02-configuracion/             # Evidencias de configuración
│   ├── 03-usuarios-grupos/           # Gestión de usuarios y OUs
│   ├── 04-clientes/                  # Unión de clientes
│   ├── 05-gpos/                      # Políticas aplicadas
│   ├── 06-recursos/                  # Recursos compartidos
│   ├── 07-trusts/                    # Confianzas de dominio
│   └── 08-auditoria/                 # Logs y auditoría
└── LICENSE                            # Licencia del proyecto
```

## 🚀 Guía de Implementación Completa

### 📋 Tabla de Contenidos

1. [Preparación del Entorno Virtual](#1-preparación-del-entorno-virtual)
2. [Instalación de Ubuntu Server](#2-instalación-de-ubuntu-server)
3. [Configuración de Red](#3-configuración-de-red)
4. [Instalación de Samba y Dependencias](#4-instalación-de-samba-y-dependencias)
5. [Promoción a Domain Controller](#5-promoción-a-domain-controller)
6. [Gestión de Usuarios, Grupos y OUs](#6-gestión-de-usuarios-grupos-y-ous)
7. [Unión de Clientes al Dominio](#7-unión-de-clientes-al-dominio)
8. [Configuración de GPOs](#8-configuración-de-gpos)
9. [Recursos Compartidos y Permisos](#9-recursos-compartidos-y-permisos)
10. [Confianzas de Dominio](#10-confianzas-de-dominio)
11. [Auditoría y Seguridad](#11-auditoría-y-seguridad)
12. [Automatización y Tareas Programadas](#12-automatización-y-tareas-programadas)

---

## 1. Preparación del Entorno Virtual

### 🖥️ Especificaciones de la VM (Servidor DC01)

### 🌐 Configuración de Red en VirtualBox

La VM debe tener **dos adaptadores de red**:

- **Adaptador 1 (Bridge/NAT)**: Para acceso a Internet y descarga de paquetes
- **Adaptador 2 (Red Interna)**: Para el tráfico del dominio
  - Nombre de la red interna: `intnet`
  - IP estática: `172.30.20.32/25`

![Configuración de red VirtualBox](/evidencias/01-instalacion/Instalacion%20Linux%20Vbox.png)

> **📸 Ver más evidencias**: [/evidencias/01-instalacion/](/evidencias/01-instalacion/)

---

## 2. Instalación de Ubuntu Server

# Ver miembros de un grupo
sudo samba-tool group listmembers Students
1. **Seleccionar ISO**: Ubuntu Server 24.04 LTS
2. **Configuración de almacenamiento**: Usar disco completo (20 GB)
3. **Perfil de usuario**: Crear usuario administrador local
4. **OpenSSH Server**: ✅ Instalar para administración remota
5. **Snap packages**: ⬜ Desmarcar para instalación más rápida
6. **Roles adicionales**: ⬜ No instalar ninguno

### ✅ Checkpoint Inicial

Tras la instalación, el sistema debe:
- ✅ Arrancar correctamente
- ✅ Permitir login con el usuario creado
- ✅ Tener conectividad de red básica


---

## 3. Configuración de Red

### 🔧 Configuración IP Estática con Netplan
Editar el archivo de configuración de red:

```bash
sudo nano /etc/netplan/00-installer-config.yaml(o el archivo que tu sistema cree)
```

**Configuración recomendada**:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.1.45/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
         - 8.8.8.8
    enp0s8:
      dhcp4: no
      addresses:
        - 192.168.2.45/24
      nameservers:
        addresses:
         - 127.0.0.1      # DNS local (Samba)
```

![Configuración de red VirtualBox](/evidencias/02-configuracion/netplan_serv.png)

**Aplicar cambios**:
samba-tool domain level show

```bash
sudo netplan apply
```

### 🚫 Deshabilitar IPv6

Samba AD DS funciona mejor con IPv4 únicamente:

```bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 🏷️ Configurar Hostname

```bash
sudo hostnamectl set-hostname ls03
```

### 📝 Editar /etc/hosts

```bash
sudo nano /etc/hosts
```

Contenido:

```
127.0.0.1       localhost
127.0.1.1       ls03
192.168.1.2     ls03.lab03.local ls03
```


### ✅ Verificación

```bash
ip addr show                    # Ver configuración de red
ping -c 4 8.8.8.8              # Probar conectividad Internet
hostname --fqdn                 # Debe mostrar: ls03.lab03.local
```

![Asegurate de los DNS](/evidencias/02-configuracion/hosts_serv.png)

---

## 4. Instalación de Samba y Dependencias

### 📦 Instalación de Paquetes

```bash
sudo apt update
sudo apt install samba krb5-user winbind smbclient dnsutils -y
```

### 📚 Descripción de Paquetes

| Paquete | Función |
|---------|---------|
| **samba** | Núcleo principal - Permite que Linux actúe como DC |
| **krb5-user** | Cliente Kerberos - Sistema de autenticación de AD |
| **winbind** | Integra usuarios y grupos del dominio en Linux |
| **smbclient** | Cliente SMB para pruebas y diagnóstico |
| **dnsutils** | Herramientas DNS (dig, nslookup) para validación |

### ⚙️ Configuración Inicial de Kerberos

Durante la instalación, se solicitará:

- **Default realm**: `LAB03.LOCAL` (en MAYÚSCULAS)
- **KDC**: `ls03.lab03.local`
- **Admin server**: `ls03.lab03.local`

![Configuración Kerberos](/evidencias/02-configuracion/krb.png)

Si durante la instalación, hay algun parametro no correcto:

```bash
sudo dpkg-reconfigure krb5-config
```
Restaurar valores por defecto (reset total)

```bash
sudo apt purge krb5-user krb5-config -y
sudo apt install krb5-user
```

### 🔧 Preparación del DNS

Samba necesita controlar el puerto 53. Desactivar el resolver de Ubuntu:

```bash
# Detener systemd-resolved
sudo systemctl disable --now systemd-resolved

# Eliminar el enlace simbólico
sudo unlink /etc/resolv.conf

# Crear archivo DNS estático
sudo nano /etc/resolv.conf
```

Contenido:

```
nameserver 192.168.1.2
search lab03.local
```

---

## 5. Promoción a Domain Controller

### 🛑 Detener Servicios Conflictivos

```bash
sudo systemctl stop smbd nmbd winbind
sudo systemctl disable smbd nmbd winbind
```

### 🎯 Backup de Configuración Original

```bash
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

### 🚀 Provisionar el Dominio

Este comando crea el Active Directory:

```bash
sudo samba-tool domain provision --use-rfc2307 --interactive
```

**Parámetros a introducir**:

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| **Realm** | `lab03.local` | Nombre del dominio Kerberos |
| **Domain** | `lab03` | Nombre NetBIOS del dominio |
| **Server Role** | `dc` | Domain Controller |
| **DNS backend** | `SAMBA_INTERNAL` | DNS integrado de Samba |
| **DNS forwarder** | `10.239.3.7` | DNS externo para resolución |
| **Administrator password** | (elegir contraseña segura) | Mínimo 8 caracteres |


### ⚙️ Ajustes Finales

#### 1. Configurar Interfaz de Escucha

Editar `/etc/samba/smb.conf`:

```bash
sudo nano /etc/samba/smb.conf
```

Añadir en la sección `[global]`:

```ini
[global]
    # ... configuración existente ...
    interfaces = lo enp0s3  # Tu interfaz de red interna
    bind interfaces only = yes
```

#### 2. Configurar Cliente Kerberos

```bash
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
```

#### 3. Arrancar el Servicio AD DC

```bash
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc
```

### ✅ Verificación del Domain Controller

```bash
# Ver nivel del dominio
sudo samba-tool domain level show

# Verificar DNS (registros SRV)
host -t SRV _ldap._tcp.lab03.local
host -t SRV _kerberos._tcp.lab03.local

# Listar usuarios del dominio
sudo samba-tool user list

# Probar autenticación Kerberos
kinit administrator
klist
```

**Resultado esperado**:

```
administrator@LAB03.LOCAL
    Valid starting     Expires            Service principal
    01/15/26 10:00:00  01/15/26 20:00:00  krbtgt/LAB03.LOCAL@LAB03.LOCAL
```

![Verificación del DC](/evidencias/02-configuracion/kinit.png)

---

## 6. Gestión de Usuarios, Grupos y OUs

### 👤 Creación de Usuarios

```bash
# Crear usuarios del dominio
sudo samba-tool user create alice "admin_21"
sudo samba-tool user create bob "admin_21"
sudo samba-tool user create charlie "admin_21"

# Listar usuarios
sudo samba-tool user list
```

### 👥 Creación de Grupos

```bash
# Crear grupos de seguridad
sudo samba-tool group add IT_Admins
sudo samba-tool group add Students

# Añadir usuarios a grupos
sudo samba-tool group addmembers Students bob,charlie
sudo samba-tool group addmembers IT_Admins alice

# Ver miembros de un grupo
sudo samba-tool group listmembers Students
```

### 🗂️ Creación de Unidades Organizativas (OUs)

```bash
# Crear estructura de OUs
sudo samba-tool ou create "OU=IT_Department,DC=lab03,DC=local"
sudo samba-tool ou create "OU=HR_Department,DC=lab03,DC=local"
sudo samba-tool ou create "OU=Students,DC=lab03,DC=local"

# Mover usuarios a sus OUs
sudo samba-tool user move bob "OU=Students,DC=lab03,DC=local"
sudo samba-tool user move charlie "OU=Students,DC=lab03,DC=local"
sudo samba-tool user move alice "OU=IT_Department,DC=lab03,DC=local"
```

### 🔍 Consultar Información de Usuarios

```bash
# Ver grupos de un usuario
sudo samba-tool user getgroups bob

# Ver información detallada
sudo samba-tool user show bob
```

![Gestión de usuarios y OUs](/evidencias/03-usuarios-grupos/mover_usu_OU.png)

---

## 7. Unión de Clientes al Dominio

### 🖥️ Cliente Ubuntu Desktop

#### Especificaciones de la VM

| Componente | Valor |
|------------|-------|
| **Hostname** | lc03 |
| **Sistema** | Ubuntu Desktop 24.04 |
| **RAM** | 2 GB |
| **Red** | Red Interna (`intnet`) |


#### Configuración de Red

**Editar el archivo de configuración de red**:

```bash
sudo nano /etc/netplan/00-installer-config.yaml(o el archivo que tu sistema cree)
```

**Configuración recomendada**:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  # Adaptador de red interna
      dhcp4: true
    enp0s8:
      dhcp4: false
      addresses:
        - 192.168.1.3/24
      nameservers:
        addresses:
          - 192.168.1.2

```

#### 📦 Instalación de Paquetes

```bash
sudo apt update
sudo apt install realmd sssd sssd-tools samba-common krb5-user \
                 packagekit samba-common-bin adcli -y
```

#### 🔧 Configuración de Red

**1. DNS (/etc/resolv.conf)**

```bash
sudo nano /etc/resolv.conf
```

```
nameserver 192.168.1.2    # IP del DC - RED INTERNA
search lab03.local
```

**2. Hosts (/etc/hosts)**

```bash
sudo nano /etc/hosts
```

```
127.0.0.1       localhost
127.0.1.1       lc03
192.168.1.2    ls03.lab03.local ls03
```
![Archivo configurado](/evidencias/02-configuracion/hosts_cli.png)

**3. Kerberos (/etc/krb5.conf)**

```bash
sudo nano /etc/krb5.conf
```

```ini
[libdefaults]
    default_realm = LAB03.LOCAL
    dns_lookup_realm = false
    dns_lookup_kdc = true

[realms]
    LAB03.LOCAL = {
        kdc = ls03.lab03.local
        admin_server = ls03.lab03.local
    }

[domain_realm]
    .lab03.local = LAB03.LOCAL
    lab03.local = LAB03.LOCAL
```

#### 🏠 Creación Automática de Directorios Home

```bash
sudo pam-auth-update --enable mkhomedir
```

#### 🔗 Unión al Dominio

```bash
# Descubrir el dominio
realm discover lab03.local

# Unir al dominio
sudo realm join lab03.local -U Administrator --verbose
```

![Unión de cliente Ubuntu](/evidencias/04-clientes/realm_join.png)

#### ✅ Verificación

```bash
# Verificar estado del dominio
realm list

# Verificar usuario del dominio
id bob@lab03.local

# Iniciar sesión como usuario del dominio
su - bob@lab03.local
```

#### 🖱️ Login Gráfico (GDM)

Para permitir login gráfico con usuarios del dominio:

```bash
sudo nano /etc/pam.d/gdm-password
```

Añadir al final:

```
session  required  pam_mkhomedir.so skel=/etc/skel umask=0077
```

![Login gráfico con usuario del dominio](/evidencias/04-clientes/ubuntu-graphical-login.png)

### 💻 Cliente Windows (if needed)

#### 📋 Requisitos Previos

1. Windows 10/11 Professional o Enterprise
2. Conectado a la misma red interna que el DC
3. DNS apuntando al DC: `172.30.20.32`

#### 🔗 Unión al Dominio

1. **Panel de Control** → **Sistema** → **Cambiar configuración**
2. **Cambiar** → **Dominio**: `lab03.local`
3. Introducir credenciales de **Administrator**
4. Reiniciar el equipo

#### 🛠️ Instalación de RSAT (Remote Server Administration Tools)

Para gestionar GPOs desde Windows:

1. **Configuración** → **Aplicaciones** → **Características opcionales**
2. **Agregar una característica**
3. Buscar e instalar: **RSAT: Group Policy Management Tools**

---

## 8. Configuración de GPOs desde Ubuntu Server

### 🎯 Creación de GPO

```bash
# Crear nueva GPO
sudo samba-tool gpo create "Student_Policy" -U administrator

# Listar GPOs y obtener GUID
sudo samba-tool gpo listall

# Vincular GPO a una OU
sudo samba-tool gpo setlink "OU=Students,DC=lab03,DC=local" {GUID} -U administrator

# Verificar vínculo
sudo samba-tool gpo getlink "OU=Students,DC=lab03,DC=local" -U administrator
```

### 🔧 Solución de Permisos (ERROR HRESULT E_ACCESSDENIED)

Si aparece error al editar desde Windows:

```bash
# Resetear ACLs en SYSVOL
sudo samba-tool ntacl sysvolreset
```

### 🖥️ Edición de GPO desde Windows (RSAT)

1. Abrir **gpmc.msc** (Group Policy Management Console)
2. Navegar a **Forest: lab03.local** → **Domains** → **lab03.local** → **Students**
3. Click derecho en **Student_Policy** → **Edit**

#### Ejemplo: Bloquear acceso al Panel de Control

**Ruta**: User Configuration → Policies → Administrative Templates → Control Panel

**Configuración**: "Prohibit access to Control Panel and PC settings" → **Enabled**

### 🐧 Aplicación en Cliente Linux

**Nota importante**: Las políticas de registro de Windows (Registry.pol) **NO se aplican** en clientes Linux (GNOME/SSSD). Sin embargo, las políticas de **seguridad** y **contraseñas** sí se aplican.

### 💻 Verificación en Cliente Windows

```powershell
# Actualizar políticas
gpupdate /force

# Ver políticas aplicadas
gpresult /r
```

Intentar abrir Panel de Control → Debería aparecer mensaje de error: "Esta operación ha sido cancelada..."

### 🔐 Políticas de Contraseñas y Seguridad

Estas políticas SÍ afectan a todos los clientes (Windows y Linux):

```bash
# Ver política actual
samba-tool domain passwordsettings show

# Configurar política de contraseñas
sudo samba-tool domain passwordsettings set --min-pwd-length=8
sudo samba-tool domain passwordsettings set --account-lockout-threshold=3
sudo samba-tool domain passwordsettings set --account-lockout-duration=5
```

---

## 9. Recursos Compartidos y Permisos

### 💾 Añadir Disco Dedicado para Almacenamiento

#### En VirtualBox (VM apagada):

1. **Crear disco virtual**:
   ```
   VirtualBox → Seleccionar VM "ls03" → Settings → Storage
   Controller: SATA → Click en icono "+" → Create new disk
   ```

2. **Configuración**:
   - Tipo: VDI (VirtualBox Disk Image)
   - Storage: Dynamically allocated
   - Tamaño: **15 GB**
   - Nombre: `Linux Server AD_1.vdi`

#### En Ubuntu Server (arrancar VM):

3. **Identificar el nuevo disco**:
   ```bash
   lsblk
   ```
   
   Salida esperada:
   ```
   sdb      8:16   0   15G  0 disk     ← NUEVO DISCO
   ```

4. **Particionar**:
   ```bash
   sudo fdisk /dev/sdb
   ```
   
   Comandos: `n` → `p` → `1` → `[Enter]` → `[Enter]` → `w`

5. **Formatear**:
   ```bash
   sudo mkfs.ext4 /dev/sdb1
   ```

6. **Crear punto de montaje**:
   ```bash
   sudo mkdir -p /srv/samba
   ```

7. **Configurar montaje automático** (`/etc/fstab`):
   ```bash
   # Obtener UUID
   sudo blkid /dev/sdb1
   
   # Editar fstab
   sudo nano /etc/fstab
   ```
   
   Añadir:
   ```
   # Disco dedicado para recursos compartidos Samba
   UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890  /srv/samba  ext4  defaults  0  2
   ```
   
   Verificar:
   ```bash
   sudo mount -a
   df -h | grep samba
   ```

---
### 📁 Preparación del Servidor

#### 1. Crear Estructura de Directorios

```bash
sudo mkdir -p /srv/samba/StudentDocs
sudo mkdir -p /srv/samba/HRDocs
sudo mkdir -p /srv/samba/ITDocs
sudo mkdir -p /srv/samba/Public
```

#### 2. Instalar Librerias Winbind (si es necesario)

```bash
sudo apt-get install libnss-winbind libpam-winbind
sudo ldconfig
```

Editar `/etc/samba/smb.conf` en la sección `[global]`:

```ini
winbind use default domain = yes
template shell = /bin/bash
template homedir = /home/%U
```

#### 3. Configurar Permisos Base

```bash
# Asignar grupo propietario y permisos
sudo chown :Students /srv/samba/StudentDocs
sudo chmod 3770 /srv/samba/StudentDocs

sudo chown :IT_Admins /srv/samba/ITDocs
sudo chmod 3770 /srv/samba/ITDocs

sudo chown :"Domain Users" /srv/samba/Public
sudo chmod 3777 /srv/samba/Public
```
---

**Explicación de permisos (3770)**:
- **3**: SetGID + Sticky Bit (hereda grupo + protege borrado)
- **7**: Propietario (rwx)
- **7**: Grupo (rwx)
- **0**: Otros (sin acceso)

### 📝 Configuración de Recursos Compartidos

Editar `/etc/samba/smb.conf`:

```bash
sudo nano /etc/samba/smb.conf
```

Añadir al final:

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

[Public]
    path = /srv/samba/Public
    read only = no
    valid users = @"Domain Users"
    guest ok = no
```

**Reiniciar Samba**:

```bash
sudo smbcontrol all reload-config
```

### 🪟 Gestión de ACLs desde Windows

1. Desde el cliente Windows, abrir **Explorador de archivos**
2. Conectar a `\\lab03.local` o `(IP-SERVIDOR)`
3. Click derecho en carpeta → **Propiedades** → **Seguridad**
4. **Editar** → Añadir grupos y configurar permisos

**Ejemplo**:
- **Students**: Modificar (Read, Write, Delete)
- **IT_Admins**: Control Total
- **Finance** (si existe): **Denegar** todo

![Gestión de permisos en Windows](/evidencias/06-recursos/windows-acl-management.png)

### 🐧 Montaje Automático en Cliente Linux

#### 📦 Instalación

```bash
sudo apt install libpam-mount cifs-utils
```

#### ⚙️ Configuración

Editar `/etc/security/pam_mount.conf.xml`:

```xml
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">
<pam_mount>
    <debug enable="1" />
    
    <!-- Montaje para Students -->
    <volume user="*" sgrp="students@lab03.local" 
            fstype="cifs" 
            server="lab03.local" 
            path="StudentDocs" 
            mountpoint="~/StudentDocs" 
            options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID),file_mode=0700,dir_mode=0700" />
    
    <!-- Montaje para IT_Admins -->
    <volume user="*" sgrp="it_admins@lab03.local" 
            fstype="cifs" 
            server="lab03.local" 
            path="ITDocs" 
            mountpoint="~/ITDocs" 
            options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID),file_mode=0700,dir_mode=0700" />
    
    <!-- Montaje para todos los usuarios del dominio -->
    <volume user="*" sgrp="domain users@lab03.local" 
            fstype="cifs" 
            server="lab03.local" 
            path="Public" 
            mountpoint="~/Public" 
            options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID),file_mode=0700,dir_mode=0700" />
    
    <mntoptions allow="nosuid,nodev,loop,encryption,fsck,nonempty,allow_root,allow_other" />
    <mntoptions require="nosuid,nodev" />
    <logout wait="0" hup="no" term="no" kill="no" />
    <mkmountpoint enable="1" remove="true" />
</pam_mount>
```

#### ✅ Verificación

Al iniciar sesión como `bob@lab03.local`, se debe montar automáticamente `~/StudentDocs`.

```bash
# Ver montajes activos
mount | grep cifs

# Listar archivos
ls -la ~/StudentDocs
```

### 📊 Verificación del Sistema de Almacenamiento

```bash
# Ver uso del disco de datos
df -h /srv/samba

# Ver estructura completa
tree -L 2 /srv/samba

# Salida esperada:
# /srv/samba
# ├── StudentDocs
# ├── ITDocs
# ├── HRDocs
# └── Public

# Verificar permisos
ls -la /srv/samba

# Debe mostrar los grupos correctos y permisos 3770
```

---

### 🎯 Ventajas del Disco Dedicado

| Ventaja | Descripción |
|---------|-------------|
| **Separación de Datos** | Sistema operativo y datos en discos diferentes |
| **Escalabilidad** | Fácil aumentar capacidad o añadir más discos |
| **Backup Selectivo** | Respaldar solo los datos sin el sistema |
| **Rendimiento** | Reduce la carga de I/O en el disco del sistema |
| **Producción Real** | Configuración profesional usada en entornos empresariales |

---

![Montaje automático en Linux](/evidencias/06-recursos/linux-auto-mount.png)

---

## 10. Confianzas de Dominio

### 🌳 Escenario: Crear un Segundo Bosque

Vamos a crear un segundo dominio `lab03trust.local` y establecer una confianza de tipo **Forest Trust**.

### 🖥️ Preparación del Segundo Servidor

#### Especificaciones

| Parámetro | Valor |
|-----------|-------|
| **Hostname** | ls03trust |
| **Dominio** | lab03trust.local |
| **IP** | 192.168.2.3 |
| **RAM** | 4 GB |
| **CPU** | 2 núcleos |

#### 🔧 Configuración Inicial

```bash
# Renombrar servidor
sudo hostnamectl set-hostname ls03trust

# Configurar IP estática (Netplan)
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.2.3/24
      gateway4: 192.168.2.1
      nameservers:
        addresses:
         - 127.0.0.1
```

```bash
# Aplicar cambios
sudo netplan apply

# Configurar /etc/hosts
sudo nano /etc/hosts
```

```
127.0.0.1       localhost
127.0.1.1       ls03trust
192.168.2.3     ls03trust.lab03trust.local ls03trust
192.168.2.2     ls03.lab03.local ls03
```

#### ⏰ Sincronización de Hora

```bash
# Verificar zona horaria
timedatectl

# Configurar zona horaria
sudo timedatectl set-timezone Europe/Madrid

# Activar NTP
sudo timedatectl set-ntp true
```

### 📦 Instalación y Promoción

```bash
# Instalar paquetes
sudo apt update
sudo apt install acl attr samba samba-dsdb-modules samba-vfs-modules \
                 smbclient winbind libpam-winbind libnss-winbind \
                 krb5-config krb5-user dnsutils -y
```

**Configuración Kerberos**:
- **Realm**: `LAB03TRUST.LOCAL`
- **KDC**: `ls03trust.lab03trust.local`
- **Admin server**: `ls03trust.lab03trust.local`

#### 🚀 Provisión del Segundo Dominio

```bash
# Backup de configuración
sudo rm /etc/samba/smb.conf

# Provisionar
sudo samba-tool domain provision --use-rfc2307 --interactive
```

**Parámetros**:
- **Realm**: `lab03trust.local`
- **Domain**: `lab03trust`
- **Server Role**: `dc`
- **DNS backend**: `SAMBA_INTERNAL`
- **DNS forwarder**: `10.239.3.7`

```bash
# Configurar Kerberos
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# Arrancar servicio
sudo systemctl stop smbd nmbd winbind
sudo systemctl disable smbd nmbd winbind
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc
```

### 🌐 Configuración DNS para Trusts

#### Opción 1: Reenviadores Condicionales (Recomendado)

**En el servidor principal (ls03 - 192.168.2.2)**:

```bash
# Crear zona de reenvío
sudo samba-tool dns zonecreate 192.168.2.2 lab03trust.local -U Administrator

# Añadir NS del segundo dominio
sudo samba-tool dns add 192.168.2.2 lab03trust.local @ NS ls03trust.lab03trust.local -U Administrator

# Añadir registro A
sudo samba-tool dns add 192.168.2.2 lab03trust.local ls03trust A 192.168.2.3 -U Administrator

# Verificar
sudo samba-tool dns query 192.168.2.2 lab03trust.local @ ALL -U Administrator
nslookup ls03trust.lab03trust.local
```

**En el servidor secundario (ls03trust - 192.168.2.3)**:

```bash
# Crear zona de reenvío
sudo samba-tool dns zonecreate 192.168.2.3 lab03.local -U Administrator

# Añadir NS del dominio principal
sudo samba-tool dns add 192.168.2.3 lab03.local @ NS ls03.lab03.local -U Administrator

# Añadir registro A
sudo samba-tool dns add 192.168.2.3 lab03.local ls03 A 192.168.2.2 -U Administrator

# Verificar
sudo samba-tool dns query 192.168.2.3 lab03.local @ ALL -U Administrator
nslookup ls03.lab03.local
```

![Configuración DNS Trust](/evidencias/07-trusts/dns-forwarders.png)

### 🤝 Creación de la Confianza

**Desde el servidor principal (ls03)**:

```bash
sudo samba-tool domain trust create lab03trust.local \
    -U Administrator@LAB03TRUST.LOCAL --type=forest
```

O alternativamente, desde el servidor secundario:

```bash
sudo samba-tool domain trust create lab03.local \
    -U Administrator@LAB03.LOCAL --type=forest
```

### ✅ Verificación de la Confianza

```bash
# Listar confianzas
sudo samba-tool domain trust list

# Validar confianza
sudo samba-tool domain trust validate lab03.local -U administrator
```

![Confianza establecida](/evidencias/07-trusts/trust-validation.png)

### 🔍 Prueba Cross-Domain

Desde el dominio `lab03.local`, acceder a recursos del dominio `lab03trust.local`:

```bash
# Listar recursos del otro dominio
smbclient //ls03trust.lab03trust.local/StudentDocs \
    -U bob@lab03.local -W LAB03
```

![Acceso cross-domain](/evidencias/07-trusts/cross-domain-access.png)

---

## 11. Auditoría y Seguridad

### 📊 Configuración de Auditoría con Full Audit

#### 1. Configurar rsyslog

Crear archivo de configuración:

```bash
sudo nano /etc/rsyslog.d/samba-audit.conf
```

Contenido:

```
# Desviar logs de auditoría de Samba a archivo dedicado
local7.notice   /var/log/samba_audit.log
& stop
```

#### 2. Crear y Configurar el Archivo de Log

```bash
# Crear archivo
sudo touch /var/log/samba_audit.log

# Establecer permisos
sudo chown syslog:adm /var/log/samba_audit.log
sudo chmod 640 /var/log/samba_audit.log
```

#### 3. Reiniciar Servicios

```bash
# Reiniciar rsyslog
sudo systemctl restart rsyslog

# Recargar Samba
sudo smbcontrol all reload-config
```

### 📝 Visualización de Logs

```bash
# Ver logs en tiempo real
sudo tail -f /var/log/samba_audit.log

# Buscar eventos específicos
sudo grep "unlinkat" /var/log/samba_audit.log
sudo grep "bob" /var/log/samba_audit.log
```

**Ejemplo de entrada de log**:

```
Jan 15 14:23:45 ls03 smbd_audit: bob|192.168.2.100|lc03|StudentDocs|unlinkat|ok|file_deleted.txt
```

**Formato**: `usuario|IP_origen|hostname|recurso|acción|resultado|archivo`

![Logs de auditoría](/evidencias/08-auditoria/audit-logs.png)

### 🔒 Políticas de Seguridad

#### Política de Contraseñas

```bash
# Ver configuración actual
samba-tool domain passwordsettings show

# Configurar
sudo samba-tool domain passwordsettings set --complexity=on
sudo samba-tool domain passwordsettings set --min-pwd-length=10
sudo samba-tool domain passwordsettings set --min-pwd-age=1
sudo samba-tool domain passwordsettings set --max-pwd-age=90
sudo samba-tool domain passwordsettings set --history-length=12
```

#### Política de Bloqueo de Cuenta

```bash
sudo samba-tool domain passwordsettings set --account-lockout-threshold=5
sudo samba-tool domain passwordsettings set --account-lockout-duration=15
sudo samba-tool domain passwordsettings set --reset-account-lockout-after=15
```

---

## 12. Automatización y Tareas Programadas

### 💾 Script de Backup Automático

#### 1. Crear el Script

```bash
sudo nano /root/backup_samba.sh
```

Contenido del script:

```bash
#!/bin/bash

# --- CONFIGURACIÓN ---
DIR_DESTINO="/root/backups"
LOG_FILE="/var/log/samba_backup.log"
DIAS_A_GUARDAR=30

# --- COMANDOS (rutas absolutas) ---
TAR=/bin/tar
DATE=/bin/date
ECHO=/bin/echo
FIND=/usr/bin/find

# --- VARIABLES ---
FECHA=$($DATE +%F_%H-%M)
NOMBRE_ARCHIVO="backup_ad_$FECHA.tar.gz"
RUTA_COMPLETA="$DIR_DESTINO/$NOMBRE_ARCHIVO"

# Crear directorio de destino si no existe
mkdir -p $DIR_DESTINO

# --- 1. EJECUTAR BACKUP ---
$TAR -czf $RUTA_COMPLETA /var/lib/samba /etc/samba 2>/dev/null

# --- 2. VERIFICACIÓN Y LOG ---
if [ $? -eq 0 ]; then
    $ECHO "[$FECHA] OK: Backup creado: $NOMBRE_ARCHIVO" >> $LOG_FILE
    
    # --- 3. LIMPIEZA ---
    $FIND $DIR_DESTINO -name "backup_ad_*.tar.gz" -mtime +$DIAS_A_GUARDAR -delete
else
    $ECHO "[$FECHA] ERROR: Falló backup" >> $LOG_FILE
fi
```

#### 2. Hacer el Script Ejecutable

```bash
sudo chmod +x /root/backup_samba.sh
```

#### 3. Programar con Cron

```bash
sudo crontab -e
```

Añadir al final (backup diario a las 9:15):

```
15 9 * * * /root/backup_samba.sh
```

**Formato Cron**: `m h dom mon dow command`

| Campo | Valor | Descripción |
|-------|-------|-------------|
| m | 15 | Minuto (15) |
| h | 9 | Hora (09:00) |
| dom | * | Día del mes (todos) |
| mon | * | Mes (todos) |
| dow | * | Día de la semana (todos) |

#### 4. Verificar Funcionamiento

```bash
# Ejecutar manualmente
sudo /root/backup_samba.sh

# Ver log
cat /var/log/samba_backup.log

# Listar backups
ls -lh /root/backups/
```

![Script de backup](/evidencias/08-auditoria/backup-script.png)

### 📊 Monitorización de Procesos

#### htop - Monitorización en Tiempo Real

```bash
# Instalar
sudo apt install htop

# Ejecutar
htop
```

**Filtrar procesos de Samba**:
1. Presionar `F4` (Filter)
2. Escribir: `samba`
3. Ver procesos relacionados con AD

![Monitorización con htop](/evidencias/08-auditoria/htop-monitoring.png)

#### Gestión Remota de Procesos vía SSH

```bash
# Conectar remotamente al cliente
ssh bob@lab03.local@lc03.lab03.local

# Listar procesos del usuario
ps -aux | grep bob

# Pausar un proceso
kill -19 <PID>

# Reanudar un proceso
kill -18 <PID>

# Terminar un proceso
kill -9 <PID>
```

---

## 📊 Estado del Proyecto

### ✅ Tareas Completadas

- [x] Repositorio creado
- [x] Instalación base de Ubuntu Server
- [x] Configuración de red estática
- [x] Instalación y configuración de Samba AD DC
- [x] Creación de usuarios, grupos y OUs
- [x] Unión de clientes Linux y Windows al dominio
- [x] Configuración de GPOs híbridas (Linux/Windows)
- [x] Implementación de recursos compartidos
- [x] Configuración de permisos y ACLs
- [x] Montaje automático de recursos en Linux
- [x] Creación de confianzas de dominio (Forest Trust)
- [x] Configuración de auditoría y seguridad
- [x] Implementación de scripts de backup
- [x] Tareas programadas con Cron
- [x] Documentación completa del proyecto

---

## 📚 Recursos Adicionales

### 📖 Documentación Oficial

- [Samba Wiki - AD DC](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)
- [Samba Wiki - Trust Relationships](https://wiki.samba.org/index.php/Trust_Relationships)
- [Ubuntu Server Documentation](https://ubuntu.com/server/docs)
- [Kerberos Documentation](https://web.mit.edu/kerberos/krb5-latest/doc/)

### 🎓 Guías y Tutoriales

- [Red Hat - Integrating Linux with Active Directory](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/integrating_rhel_systems_directly_with_windows_active_directory/)
- [ArchWiki - Active Directory Integration](https://wiki.archlinux.org/title/Active_Directory_integration)

### 🛠️ Herramientas Útiles

- [RSAT Tools](https://www.microsoft.com/en-us/download/details.aspx?id=45520) - Remote Server Administration Tools
- [Apache Directory Studio](https://directory.apache.org/studio/) - Cliente LDAP gráfico
- [Wireshark](https://www.wireshark.org/) - Análisis de tráfico de red

---

## 🤝 Contribuciones

Este proyecto es de carácter educativo. Si deseas contribuir con mejoras o correcciones:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la licencia educativa. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

## ✍️ Autor

**Administrador de Sistemas**

- 🎓 Proyecto de prácticas - Active Directory en Linux
- 📧 Contacto: [rsaura9@gmail.com]
- 🐙 GitHub: [@Psyaura](https://github.com/psyaura)

---

## 🙏 Agradecimientos

- A la comunidad de Samba por su excelente documentación
- A Canonical por Ubuntu Server
- A todos los que contribuyen al software libre

---

<div align="center">

**🌟 Si este proyecto te ha sido útil, no olvides darle una estrella 🌟**

[![Star this repo](https://img.shields.io/github/stars/tu-usuario/Domain-Controller-Active-Directory-with-Ubuntu-Server?style=social)](https://github.com/tu-usuario/Domain-Controller-Active-Directory-with-Ubuntu-Server)

</div>

---

<div align="center">
<sub>Desarrollado con ❤️  para fines educativos | 2025</sub>
</div>
