# 🖥️ Samba Active Directory DC en AWS + Carpetas Compartidas

> **Guía técnica** — Despliegue de un Controlador de Dominio Samba 4 sobre Ubuntu Server en AWS EC2, con configuración completa de carpetas compartidas accesibles desde Windows.
>
> `Ubuntu Server 22.04` · `AWS EC2` · `Samba 4` · `Windows Client`

---

## 📋 Índice

- [Arquitectura del entorno](#-arquitectura-del-entorno)
- [Preparación del servidor](#-preparación-del-servidor)
- [Promoción del controlador de dominio](#-promoción-del-controlador-de-dominio)
- [Verificación del dominio](#-verificación-del-dominio)
- [Configuración de carpetas compartidas](#-configuración-de-carpetas-compartidas)
- [Unir el cliente Windows al dominio](#-unir-el-cliente-windows-al-dominio)
- [Gestión de usuarios y grupos](#-gestión-de-usuarios-y-grupos)
- [Troubleshooting](#-troubleshooting)
- [Cheatsheet — Comandos clave](#-cheatsheet--comandos-clave)

---

## 🏗️ Arquitectura del entorno

| Parámetro | Valor |
|---|---|
| SO Servidor | Ubuntu Server 22.04 LTS (EC2 en AWS) |
| Servicio AD | Samba 4 — Controlador de Dominio |
| Dominio | `ASIR.LOCAL` |
| Realm Kerberos | `ASIR.LOCAL` |
| IP Servidor | `172.31.16.133` (privada AWS) |
| Cliente | Windows 10/11 unido al dominio |

> ⚠️ **Security Groups AWS** — Asegúrate de abrir los siguientes puertos de entrada:
> `53` (DNS) · `88` (Kerberos) · `389` (LDAP) · `445` (SMB) · `636` (LDAPS) · `3268` (Global Catalog)

---

## ⚙️ Preparación del servidor

### 1. Actualización y dependencias

```bash
# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar Samba y herramientas necesarias
sudo apt install -y samba krb5-config krb5-user winbind \
    libnss-winbind libpam-winbind smbclient

# Detener y deshabilitar servicios por defecto
sudo systemctl stop smbd nmbd winbind
sudo systemctl disable smbd nmbd winbind
```

### 2. Configurar el hostname

El hostname debe coincidir con el nombre NetBIOS del DC:

```bash
sudo hostnamectl set-hostname dc1.asir.local

# Editar /etc/hosts — añadir la línea con el FQDN
sudo nano /etc/hosts
# Añadir: 172.31.16.133  dc1.asir.local  dc1

# Verificar
hostname -f
```

### 3. Configurar DNS para que apunte a sí mismo

Samba AD incluye su propio servidor DNS, por lo que el servidor debe usarse como DNS primario:

```bash
# Editar configuración de red Netplan (Ubuntu 22.04)
sudo nano /etc/netplan/00-installer-config.yaml

# Asegurarse de tener:
#   nameservers:
#     addresses: [127.0.0.1]

sudo netplan apply
```

---

## 🚀 Promoción del controlador de dominio

### 1. Respaldar y eliminar smb.conf existente

```bash
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

### 2. Provisionar el dominio con samba-tool

```bash
sudo samba-tool domain provision \
    --use-rfc2307 \
    --realm=ASIR.LOCAL \
    --domain=ASIR \
    --adminpass='P@ssw0rd123!' \
    --dns-backend=SAMBA_INTERNAL \
    --server-role=dc
```

| Flag | Descripción |
|---|---|
| `--use-rfc2307` | Añade atributos POSIX (UID/GID) al esquema AD |
| `--realm` | Kerberos realm, siempre en **MAYÚSCULAS** |
| `--domain` | Nombre NetBIOS del dominio (máx. 15 chars) |
| `--adminpass` | Contraseña del administrador del dominio |
| `--dns-backend` | `SAMBA_INTERNAL` usa el DNS propio de Samba |
| `--server-role=dc` | Rol de controlador de dominio primario |

### 3. Copiar configuración Kerberos

```bash
# Samba genera un krb5.conf optimizado para el dominio
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
```

### 4. Iniciar y habilitar samba-ad-dc

```bash
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc

# Verificar estado
sudo systemctl status samba-ad-dc
```

---

## ✅ Verificación del dominio

### Nivel funcional del dominio

```bash
sudo samba-tool domain level show
```

### Verificar registros DNS del AD

```bash
# Registro SRV de LDAP (confirma que el AD está operativo)
host -t SRV _ldap._tcp.asir.local 127.0.0.1

# Registro de Kerberos
host -t SRV _kerberos._udp.asir.local 127.0.0.1

# Resolver el propio DC
host -t A dc1.asir.local 127.0.0.1
```

### Obtener ticket Kerberos del administrador

```bash
kinit administrator@ASIR.LOCAL

# Ver tickets activos
klist
```

> 💡 Si `kinit` funciona correctamente, la autenticación Kerberos del dominio está operativa. Este paso es clave antes de unir equipos al dominio.

### Verificar con smbclient

```bash
smbclient -L localhost -U administrator
# Debería listar: sysvol, netlogon y los shares configurados
```

---

## 📁 Configuración de carpetas compartidas

### 1. Crear la estructura de directorios

```bash
# Crear directorios para los shares
sudo mkdir -p /srv/samba/ITDocs
sudo mkdir -p /srv/samba/netlogon

# Crear grupo si no existe
sudo groupadd sambashare

# Asignar grupo y permisos
sudo chown -R root:sambashare /srv/samba/ITDocs
sudo chmod -R 2770 /srv/samba/ITDocs
```

### 2. Configurar smb.conf

Editar `/etc/samba/smb.conf` y añadir las secciones al final:

```bash
sudo nano /etc/samba/smb.conf
```

```ini
[global]
    workgroup = ASIR
    realm = ASIR.LOCAL
    netbios name = DC1
    server role = active directory domain controller
    dns forwarder = 8.8.8.8
    idmap_ldb:use rfc2307 = yes

# ── Shares de sistema (obligatorios en un DC) ──────────────
[sysvol]
    path = /var/lib/samba/sysvol
    read only = no

[netlogon]
    path = /var/lib/samba/sysvol/asir.local/scripts
    read only = no

# ── Share de documentación IT ──────────────────────────────
[ITDocs]
    # --- Ruta y descripción ---
    path = /srv/samba/ITDocs
    comment = Documentación del departamento IT

    # --- Visibilidad y acceso ---
    browseable = yes
    writable = yes
    guest ok = no
    valid users = @admins @"domain users"   ; grupos permitidos
    invalid users = root baduser @guests    ; usuarios/grupos denegados

    # --- Permisos de ficheros ---
    read only = no
    create mask = 0664
    directory mask = 0775
    force group = sambashare

    # --- Rendimiento ---
    oplocks = yes
    level2 oplocks = yes

    # --- Seguridad adicional ---
    hide dot files = yes
    follow symlinks = no
```

### 3. Referencia de directivas

| Directiva | Descripción |
|---|---|
| `valid users` | Lista blanca de usuarios/grupos (`@grupo`). Solo ellos pueden conectar. |
| `invalid users` | Lista negra. Rechaza el acceso aunque el usuario esté en `valid users`. Útil para bloquear `root`. |
| `create mask` | Permisos UNIX de los ficheros creados desde Windows (`0664` = rw-rw-r--) |
| `directory mask` | Permisos UNIX de las carpetas creadas desde Windows (`0775` = rwxrwxr-x) |
| `force group` | Fuerza que los ficheros creados pertenezcan a este grupo. Útil para acceso compartido entre usuarios. |
| `oplocks` | Permite caché local en el cliente Windows. Mejora rendimiento en redes estables. |
| `hide dot files` | Oculta ficheros de Linux que empiezan por `.` (ej. `.bashrc`) a los clientes Windows. |
| `follow symlinks` | En `no`, evita que un usuario escape del share siguiendo un enlace simbólico. |
| `browseable` | Si el share aparece en la lista de red. En `no`, existe pero hay que acceder por ruta directa. |
| `comment` | Descripción visible en el Explorador de Windows al listar los shares. |

### 4. Aplicar cambios

```bash
# Verificar sintaxis antes de reiniciar
sudo testparm

# Reiniciar el servicio
sudo systemctl restart samba-ad-dc

# Confirmar que el share aparece
smbclient -L localhost -U administrator
```

---

## 🪟 Unir el cliente Windows al dominio

### 1. Configurar DNS en Windows

El cliente Windows debe usar el DC de Samba como DNS primario:

```
Panel de Control → Centro de redes → Cambiar configuración del adaptador
→ Propiedades TCP/IPv4
→ DNS preferido: 172.31.16.133
```

### 2. Unir al dominio

```
Sistema → Cambiar configuración → Cambiar nombre o dominio
→ Dominio: asir.local
→ Credenciales: administrator / P@ssw0rd123!
→ Reiniciar el equipo
```

### 3. Acceder a los shares desde Windows

```cmd
:: Listar shares del DC
net view \\172.31.16.133

:: Mapear unidad de red
net use Z: \\172.31.16.133\ITDocs /persistent:yes

:: Ver conexiones SMB activas
net use

:: Limpiar todas las sesiones (fix del error de múltiples conexiones)
net use * /delete
```

> 💡 Si aparece el error **"Multiple connections to a server by the same user using more than one user name"**, ejecuta `net use * /delete` para eliminar las sesiones previas y vuelve a conectar.

---

## 👥 Gestión de usuarios y grupos

### Usuarios

```bash
# Crear un usuario en el dominio
sudo samba-tool user create raul 'P@ssw0rd123!' \
    --given-name=Raul \
    --surname=Apellido \
    --mail-address=raul@asir.local

# Listar todos los usuarios del dominio
sudo samba-tool user list

# Mostrar detalles de un usuario
sudo samba-tool user show raul

# Cambiar contraseña
sudo samba-tool user setpassword raul --newpassword='NuevoPass123!'

# Deshabilitar / habilitar usuario
sudo samba-tool user disable raul
sudo samba-tool user enable raul
```

### Grupos

```bash
# Crear un grupo
sudo samba-tool group add admins

# Añadir usuario a un grupo
sudo samba-tool group addmembers admins raul

# Ver miembros de un grupo
sudo samba-tool group listmembers admins

# Listar todos los grupos
sudo samba-tool group list

# Eliminar usuario de un grupo
sudo samba-tool group removemembers admins raul
```

---

## 🔧 Troubleshooting

### Comandos de diagnóstico

```bash
# Ver logs de Samba en tiempo real
sudo journalctl -fu samba-ad-dc

# Verificar el servicio
sudo systemctl status samba-ad-dc

# Comprobar puertos abiertos por Samba
sudo ss -tlnp | grep samba

# Verificar DNS desde el servidor
dig @127.0.0.1 asir.local
dig @127.0.0.1 _ldap._tcp.asir.local SRV

# Autenticación Kerberos
kinit administrator@ASIR.LOCAL && klist

# Buscar objetos en el directorio LDAP
sudo ldbsearch -H /var/lib/samba/private/sam.ldb \
    -b 'DC=asir,DC=local' '(objectClass=user)'
```

### Problemas frecuentes

| Problema | Solución |
|---|---|
| `samba-ad-dc` no arranca | Verificar sintaxis con `testparm` y revisar `journalctl -u samba-ad-dc` |
| Error DNS en Windows | Confirmar que el DNS del cliente apunta a la IP del servidor Samba |
| `kinit` falla | Comprobar que `/etc/krb5.conf` está copiado correctamente del provisionado |
| Share no accesible | Revisar permisos con `ls -la` y confirmar que el usuario está en `valid users` |
| Múltiples conexiones SMB | Ejecutar `net use * /delete` en el cliente Windows |
| Clock skew en Kerberos | Sincronizar hora del cliente con el DC — `timedatectl` en Linux, hora del servidor en Windows |
| Usuario no puede escribir | Verificar `create mask`, `directory mask` y que el usuario pertenece a `sambashare` |

---

## 📌 Cheatsheet — Comandos clave

```bash
# ── PROVISIÓN DEL DOMINIO ──────────────────────────────────────────
sudo samba-tool domain provision --use-rfc2307 --realm=ASIR.LOCAL \
    --domain=ASIR --adminpass='P@ssw0rd123!' \
    --dns-backend=SAMBA_INTERNAL --server-role=dc

# ── KERBEROS ───────────────────────────────────────────────────────
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# ── INICIAR SERVICIO ───────────────────────────────────────────────
sudo systemctl unmask samba-ad-dc
sudo systemctl enable --now samba-ad-dc

# ── VERIFICACIÓN ───────────────────────────────────────────────────
sudo samba-tool domain level show
host -t SRV _ldap._tcp.asir.local 127.0.0.1
kinit administrator@ASIR.LOCAL && klist
smbclient -L localhost -U administrator
sudo testparm

# ── USUARIOS ───────────────────────────────────────────────────────
sudo samba-tool user create <usuario> <contraseña>
sudo samba-tool user list
sudo samba-tool user setpassword <usuario> --newpassword='...'

# ── GRUPOS ─────────────────────────────────────────────────────────
sudo samba-tool group add <grupo>
sudo samba-tool group addmembers <grupo> <usuario>
sudo samba-tool group listmembers <grupo>

# ── SHARES (desde Windows CMD) ─────────────────────────────────────
net view \\172.31.16.133
net use Z: \\172.31.16.133\ITDocs /persistent:yes
net use * /delete
```

---

<div align="center">

**ASIR · EduTech Castellón**  
Administración de Sistemas Informáticos en Red

</div>
