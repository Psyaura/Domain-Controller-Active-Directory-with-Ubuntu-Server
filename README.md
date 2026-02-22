# 🖥️ Active Directory Domain Controller with Ubuntu Server + Samba4

[![Ubuntu Server](https://img.shields.io/badge/Ubuntu%20Server-24.04%20LTS-E95420?logo=ubuntu)](https://ubuntu.com/)
[![Samba](https://img.shields.io/badge/Samba-4.x-A80030?logo=samba)](https://www.samba.org/)
[![Active Directory](https://img.shields.io/badge/Active%20Directory-Compatible-0078D4?logo=microsoft)](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/)
[![License](https://img.shields.io/badge/License-Educational-green)](LICENSE)

## 📌 Project Description

This project documents the complete implementation of a **Domain Controller** based on **Ubuntu Server** using **Samba Active Directory**. The goal is to create a fully functional centralized authentication environment that enables management of users, groups, policies (GPOs), shared resources, and domain trusts within a simulated enterprise network.

This repository includes detailed technical documentation, step-by-step configurations, automation scripts, and visual evidence of the complete implementation process.

> [!NOTE]
> This content is dedicated to the educational and training field in systems administration.

## 🎯 Project Objectives

- ✅ **Installation and configuration** of Ubuntu Server as Domain Controller
- ✅ **Samba AD DC implementation** with integrated DNS
- ✅ **Creation and management** of users, groups, and Organizational Units (OUs)
- ✅ **Group Policy configuration** (GPOs) in hybrid Linux/Windows environment
- ✅ **Client joining** Linux and Windows to the domain
- ✅ **Shared resources implementation** with ACLs and advanced permissions
- ✅ **Domain trust configuration** (Domain/Forest Trusts)
- ✅ **Auditing and security** with event logging
- ✅ **Task automation** with Cron and backup scripts
- ✅ **Process management and system monitoring**

## 🛠️ Technologies Used

| Technology | Version | Purpose |
|------------|---------|---------|
| Ubuntu Server | 24.04 LTS | Base operating system |
| Samba | 4.x | Active Directory Domain Services |
| Kerberos | 5 | Authentication system |
| Winbind | Latest | AD user/group integration |
| SSSD | Latest | System Security Services Daemon |
| CIFS/SMB | 3.x | File sharing protocol |
| DNS (Samba Internal) | - | Domain name resolution |
| VirtualBox | 7.x | Virtualization platform |

## 📂 Repository Structure

```
Domain-Controller-Active-Directory-with-Ubuntu-Server/
├── README.md                          # This file
├── documentacion/                     # Detailed technical documentation
│   ├── 01-instalacion-base.md        # Ubuntu Server installation
│   ├── 02-configuracion-red.md       # Static network configuration
│   ├── 03-samba-ad-dc.md             # DC promotion
│   ├── 04-gestion-usuarios.md        # Users, groups and OUs
│   ├── 05-union-clientes.md          # Client domain joining
│   ├── 06-gpos.md                    # Group policies
│   ├── 07-recursos-compartidos.md    # File Server and permissions
│   ├── 08-trusts.md                  # Domain trusts
│   ├── 09-auditoria.md               # Security and logging
│   └── 10-automatizacion.md          # Scripts and scheduled tasks
├── configuracion/                     # Configuration files
│   ├── smb.conf                      # Samba configuration
│   ├── krb5.conf                     # Kerberos configuration
│   ├── netplan/                      # Network configurations
│   ├── pam_mount.conf.xml            # Automatic resource mounting
│   └── scripts/                      # Automation scripts
│       ├── backup_samba.sh           # AD backup script
│       └── user_creation.sh          # Mass user creation script
├── evidencias/                        # Screenshots and tests
│   ├── 01-instalacion/               # Installation evidence
│   ├── 02-configuracion/             # Configuration evidence
│   ├── 03-usuarios-grupos/           # Users and OUs management
│   ├── 04-clientes/                  # Client joining
│   ├── 05-gpos/                      # Applied policies
│   ├── 06-recursos/                  # Shared resources
│   ├── 07-trusts/                    # Domain trusts
│   └── 08-auditoria/                 # Logs and auditing
└── LICENSE                            # Project license
```

## 🚀 Complete Implementation Guide

### 📋 Table of Contents

1. [Virtual Environment Preparation](#1-virtual-environment-preparation)
2. [Ubuntu Server Installation](#2-ubuntu-server-installation)
3. [Network Configuration](#3-network-configuration)
4. [Samba and Dependencies Installation](#4-samba-and-dependencies-installation)
5. [Domain Controller Promotion](#5-domain-controller-promotion)
6. [Users, Groups and OUs Management](#6-users-groups-and-ous-management)
7. [Client Domain Joining](#7-client-domain-joining)
8. [GPO Configuration](#8-gpo-configuration)
9. [Shared Resources and Permissions](#9-shared-resources-and-permissions)
10. [Domain Trusts](#10-domain-trusts)
11. [Auditing and Security](#11-auditing-and-security)
12. [Automation and Scheduled Tasks](#12-automation-and-scheduled-tasks)

---

## 1. Virtual Environment Preparation

### 🖥️ VM Specifications (DC01 Server)

| Component | Value |
|-----------|-------|
| **VM Name** | ls03 |
| **OS** | Ubuntu Server 24.04 LTS |
| **RAM** | 4 GB |
| **CPU** | 2 cores |
| **Hard Disk** | 20 GB (VDI, Dynamically allocated) |
| **Network Adapter 1** | NAT/Bridge (Internet) |
| **Network Adapter 2** | Internal Network (intnet) - 192.168.1.45/24 |

### 🌐 VirtualBox Network Configuration

The VM must have **two network adapters**:

- **Adapter 1 (Bridge/NAT)**: For Internet access and package downloads
- **Adapter 2 (Internal Network)**: For domain traffic
  - Internal network name: `intnet`
  - Static IP: `172.30.20.32/25`

![VirtualBox network configuration](/evidencias/01-instalacion/Instalacion%20Linux%20Vbox.png)

> **📸 See more evidence**: [/evidencias/01-instalacion/](/evidencias/01-instalacion/)

---

## 2. Ubuntu Server Installation

1. **Select ISO**: Ubuntu Server 24.04 LTS
2. **Storage configuration**: Use entire disk (20 GB)
3. **User profile**: Create local administrator user
4. **OpenSSH Server**: ✅ Install for remote administration
5. **Snap packages**: ⬜ Uncheck for faster installation
6. **Additional roles**: ⬜ Do not install any

### ✅ Initial Checkpoint

After installation, the system must:
- ✅ Boot correctly
- ✅ Allow login with created user
- ✅ Have basic network connectivity

---

## 3. Network Configuration

### 🔧 Static IP Configuration with Netplan

Edit the network configuration file:

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

**Recommended configuration**:

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
         - 127.0.0.1      # Local DNS (Samba)
```

![VirtualBox network configuration](/evidencias/02-configuracion/netplan_serv.png)

**Apply changes**:

```bash
sudo netplan apply
```

### 🚫 Disable IPv6

Samba AD DS works better with IPv4 only:

```bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 🏷️ Configure Hostname

```bash
sudo hostnamectl set-hostname ls03
```

### 📝 Edit /etc/hosts

```bash
sudo nano /etc/hosts
```

Content:

```
127.0.0.1       localhost
127.0.1.1       ls03
192.168.1.2     ls03.lab03.local ls03
```

### ✅ Verification

```bash
ip addr show                    # View network configuration
ping -c 4 8.8.8.8              # Test Internet connectivity
hostname --fqdn                 # Should display: ls03.lab03.local
```

![Make sure of DNS](/evidencias/02-configuracion/hosts_serv.png)

---

## 4. Samba and Dependencies Installation

### 📦 Package Installation

```bash
sudo apt update
sudo apt install samba krb5-user winbind smbclient dnsutils -y
```

### 📚 Package Description

| Package | Function |
|---------|---------|
| **samba** | Main core - Allows Linux to act as DC |
| **krb5-user** | Kerberos client - AD authentication system |
| **winbind** | Integrates domain users and groups into Linux |
| **smbclient** | SMB client for testing and diagnostics |
| **dnsutils** | DNS tools (dig, nslookup) for validation |

### ⚙️ Initial Kerberos Configuration

During installation, you will be asked for:

- **Default realm**: `LAB03.LOCAL` (in UPPERCASE)
- **KDC**: `ls03.lab03.local`
- **Admin server**: `ls03.lab03.local`

![Kerberos configuration](/evidencias/02-configuracion/krb.png)

If during installation there is an incorrect parameter:

```bash
sudo dpkg-reconfigure krb5-config
```

Restore default values (total reset):

```bash
sudo apt purge krb5-user krb5-config -y
sudo apt install krb5-user
```

### 🔧 DNS Preparation

Samba needs to control port 53. Disable Ubuntu's resolver:

```bash
# Stop systemd-resolved
sudo systemctl disable --now systemd-resolved

# Remove symbolic link
sudo unlink /etc/resolv.conf

# Create static DNS file
sudo nano /etc/resolv.conf
```

Content:

```
nameserver 192.168.1.2
search lab03.local
```

---

## 5. Domain Controller Promotion

### 🛑 Stop Conflicting Services

```bash
sudo systemctl stop smbd nmbd winbind
sudo systemctl disable smbd nmbd winbind
```

### 🎯 Backup Original Configuration

```bash
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

### 🚀 Provision the Domain

This command creates the Active Directory:

```bash
sudo samba-tool domain provision --use-rfc2307 --interactive
```

**Parameters to enter**:

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Realm** | `lab03.local` | Kerberos domain name |
| **Domain** | `lab03` | Domain NetBIOS name |
| **Server Role** | `dc` | Domain Controller |
| **DNS backend** | `SAMBA_INTERNAL` | Samba integrated DNS |
| **DNS forwarder** | `10.239.3.7` | External DNS for resolution |
| **Administrator password** | (choose secure password) | Minimum 8 characters |

### ⚙️ Final Adjustments

#### 1. Configure Listening Interface

Edit `/etc/samba/smb.conf`:

```bash
sudo nano /etc/samba/smb.conf
```

Add in `[global]` section:

```ini
[global]
    # ... existing configuration ...
    interfaces = lo enp0s3  # Your internal network interface
    bind interfaces only = yes
```

#### 2. Configure Kerberos Client

```bash
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
```

#### 3. Start AD DC Service

```bash
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc
```

### ✅ Domain Controller Verification

```bash
# View domain level
sudo samba-tool domain level show

# Verify DNS (SRV records)
host -t SRV _ldap._tcp.lab03.local
host -t SRV _kerberos._tcp.lab03.local

# List domain users
sudo samba-tool user list

# Test Kerberos authentication
kinit administrator
klist
```

**Expected result**:

```
administrator@LAB03.LOCAL
    Valid starting     Expires            Service principal
    01/15/26 10:00:00  01/15/26 20:00:00  krbtgt/LAB03.LOCAL@LAB03.LOCAL
```

![DC verification](/evidencias/02-configuracion/kinit.png)

---

## 6. Users, Groups and OUs Management

### 👤 User Creation

```bash
# Create domain users
sudo samba-tool user create alice "admin_21"
sudo samba-tool user create bob "admin_21"
sudo samba-tool user create charlie "admin_21"

# List users
sudo samba-tool user list
```

### 👥 Group Creation

```bash
# Create security groups
sudo samba-tool group add IT_Admins
sudo samba-tool group add Students

# Add users to groups
sudo samba-tool group addmembers Students bob,charlie
sudo samba-tool group addmembers IT_Admins alice

# View group members
sudo samba-tool group listmembers Students
```

### 🗂️ Organizational Units (OUs) Creation

```bash
# Create OU structure
sudo samba-tool ou create "OU=IT_Department,DC=lab03,DC=local"
sudo samba-tool ou create "OU=HR_Department,DC=lab03,DC=local"
sudo samba-tool ou create "OU=Students,DC=lab03,DC=local"

# Move users to their OUs
sudo samba-tool user move bob "OU=Students,DC=lab03,DC=local"
sudo samba-tool user move charlie "OU=Students,DC=lab03,DC=local"
sudo samba-tool user move alice "OU=IT_Department,DC=lab03,DC=local"
```

### 🔍 Query User Information

```bash
# View user's groups
sudo samba-tool user getgroups bob

# View detailed information
sudo samba-tool user show bob
```

![Users and OUs management](/evidencias/03-usuarios-grupos/mover_usu_OU.png)

---

## 7. Client Domain Joining

### 🖥️ Ubuntu Desktop Client

#### VM Specifications

| Component | Value |
|------------|-------|
| **Hostname** | lc03 |
| **System** | Ubuntu Desktop 24.04 |
| **RAM** | 2 GB |
| **Network** | Internal Network (`intnet`) |

#### Network Configuration

**Edit network configuration file**:

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

**Recommended configuration**:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  
      dhcp4: true
    enp0s8:  # Internal network adapter
      dhcp4: false
      addresses:
        - 192.168.1.3/24
      nameservers:
        addresses:
          - 192.168.1.2
```

#### 📦 Package Installation

```bash
sudo apt update
sudo apt install realmd sssd sssd-tools samba-common krb5-user \
                 packagekit samba-common-bin adcli -y
```

#### 🔧 Network Configuration

**1. DNS (/etc/resolv.conf)**

```bash
# sudo nano /etc/resolv.conf
nameserver 192.168.1.2    # DC IP - INTERNAL NETWORK
search lab03.local
```

![Configured file](/evidencias/02-configuracion/resolv_cli.png)

**2. Hosts (/etc/hosts)**

```bash
# sudo nano /etc/hosts
127.0.0.1       localhost
127.0.1.1       lc03
192.168.1.2    ls03.lab03.local ls03
```

![Configured file](/evidencias/02-configuracion/hosts_cli.png)

**3. Kerberos (krb5.conf) | Not necessary on this type of client**

> ⚠️ **When to manually edit `/etc/krb5.conf` on the client?**
>
> On a client joined to the domain with `realm join` **it's not necessary**. Only needed in these cases:
>
> - Client needs to access **remote domain** resources (e.g., `lab03.local` client mounts folders from `lab04.local`)
> - `realm join` didn't generate `krb5.conf` correctly
> - DNS doesn't resolve SRV records and you need to **hardcode the KDC**
> - Client uses `kinit` manually against external domains

```ini
# sudo nano /etc/krb5.conf

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

#### 🏠 Automatic Home Directory Creation

```bash
sudo pam-auth-update --enable mkhomedir
```

#### 🔗 Domain Joining

```bash
# Discover domain
realm discover lab03.local

# Join domain
sudo realm join lab03.local -U Administrator --verbose
```

![Ubuntu client joining](/evidencias/04-clientes/realm_join.png)

#### ✅ Verification

```bash
# Verify domain status
realm list

# Verify domain user
id bob@lab03.local

# Login as domain user
su - bob@lab03.local
```

#### 🖱️ Graphical Login (GDM)

##### 🏠 Automatic Home Directory Creation

```bash
sudo pam-auth-update --enable mkhomedir
```

> 🔄 Log out and log back in graphically with a domain user.

##### ⚠️ If graphical login doesn't allow access:

```bash
sudo nano /etc/pam.d/gdm-password
```

Add at the end:

```
session  required  pam_mkhomedir.so skel=/etc/skel umask=0077
```

![Graphical login with domain user](/evidencias/04-clientes/ubuntu-graphical-login.png)

### 💻 Windows Client (if needed)

#### 📋 Prerequisites

1. Windows 10/11 Professional or Enterprise
2. Connected to same internal network as DC
3. DNS pointing to DC: `172.30.20.32`

#### 🔗 Domain Joining

1. **Control Panel** → **System** → **Change settings**
2. **Change** → **Domain**: `lab03.local`
3. Enter **Administrator** credentials
4. Restart computer

#### 🛠️ RSAT Installation (Remote Server Administration Tools)

To manage GPOs from Windows:

1. **Settings** → **Apps** → **Optional features**
2. **Add a feature**
3. Search and install: **RSAT: Group Policy Management Tools**

---

## 8. GPO Configuration from Ubuntu Server

### 🎯 GPO Creation

```bash
# Create new GPO
sudo samba-tool gpo create "Student_Policy" -U administrator

# List GPOs and get GUID
sudo samba-tool gpo listall

# Link GPO to an OU
sudo samba-tool gpo setlink "OU=Students,DC=lab03,DC=local" {GUID} -U administrator

# Verify link
sudo samba-tool gpo getlink "OU=Students,DC=lab03,DC=local" -U administrator
```

### 🔧 Permission Fix (ERROR HRESULT E_ACCESSDENIED)

If error appears when editing from Windows:

```bash
# Reset ACLs on SYSVOL
sudo samba-tool ntacl sysvolreset
```

### 🖥️ GPO Editing from Windows (RSAT)

1. Open **gpmc.msc** (Group Policy Management Console)
2. Navigate to **Forest: lab03.local** → **Domains** → **lab03.local** → **Students**
3. Right-click on **Student_Policy** → **Edit**

#### Example: Block Control Panel Access

**Path**: User Configuration → Policies → Administrative Templates → Control Panel

**Setting**: "Prohibit access to Control Panel and PC settings" → **Enabled**

### 🐧 Application on Linux Client

**Important note**: Windows registry policies (Registry.pol) **DO NOT apply** on Linux clients (GNOME/SSSD). However, **security** and **password** policies DO apply.

### 💻 Verification on Windows Client

```powershell
# Update policies
gpupdate /force

# View applied policies
gpresult /r
```

Try to open Control Panel → Error message should appear: "This operation has been cancelled..."

### 🔐 Password and Security Policies

These policies DO affect all clients (Windows and Linux):

```bash
# View current policy
samba-tool domain passwordsettings show

# Configure password policy
sudo samba-tool domain passwordsettings set --min-pwd-length=8
sudo samba-tool domain passwordsettings set --account-lockout-threshold=3
sudo samba-tool domain passwordsettings set --account-lockout-duration=5
```

---

## 9. Shared Resources and Permissions

### 💾 Add Dedicated Disk for Storage

#### On VirtualBox (VM powered off):

1. **Create virtual disk**:
   ```
   VirtualBox → Select VM "ls03" → Settings → Storage
   Controller: SATA → Click "+" icon → Create new disk
   ```

2. **Configuration**:
   - Type: VDI (VirtualBox Disk Image)
   - Storage: Dynamically allocated
   - Size: **15 GB**
   - Name: `Linux Server AD_1.vdi`

#### On Ubuntu Server (start VM):

3. **Identify new disk**:
   ```bash
   lsblk
   ```
   
   Expected output:
   ```
   sdb      8:16   0   15G  0 disk     ← NEW DISK
   ```

4. **Partition**:
   ```bash
   sudo fdisk /dev/sdb
   ```
   
   Commands: `n` → `p` → `1` → `[Enter]` → `[Enter]` → `w`

5. **Format**:
   ```bash
   sudo mkfs.ext4 /dev/sdb1
   ```

6. **Create mount point**:
   ```bash
   sudo mkdir -p /srv/samba
   ```

7. **Configure automatic mounting** (`/etc/fstab`):
   ```bash
   # Get UUID
   sudo blkid /dev/sdb1
   
   # Edit fstab
   sudo nano /etc/fstab
   ```
   
   Add:
   ```
   # Dedicated disk for Samba shared resources
   UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890  /srv/samba  ext4  defaults  0  2
   ```
   
   Verify:
   ```bash
   sudo mount -a
   df -h | grep samba
   ```

### 📁 Server Preparation

#### 1. Create Directory Structure

```bash
sudo mkdir -p /srv/samba/StudentDocs
sudo mkdir -p /srv/samba/HRDocs
sudo mkdir -p /srv/samba/ITDocs
sudo mkdir -p /srv/samba/Public
```

#### 2. Configure Base Permissions

```bash
# Assign group ownership and permissions
sudo chown :Students /srv/samba/StudentDocs
sudo chmod 3770 /srv/samba/StudentDocs

sudo chown :IT_Admins /srv/samba/ITDocs
sudo chmod 3770 /srv/samba/ITDocs

sudo chown :"Domain Users" /srv/samba/Public
sudo chmod 3777 /srv/samba/Public
```

## 🔧 Troubleshooting: "Domain Users Group" Error

### ❌ Error Symptom

If this error appears when trying to configure permissions:

![Error Domain Users Group](/evidencias/06-recursos/error_domain_users_group.png)

### 🔍 Problem Cause

**NSS (Name Service Switch) cannot resolve AD groups** because Winbind libraries are not installed or properly configured.

> **⚠️ Important**: Without these libraries, Linux is "blind" to Active Directory users and groups, even though Samba is running. The Samba server can authenticate users, but the Linux operating system doesn't recognize them for filesystem operations.

### ✅ Solution

#### 1. Install Winbind Libraries

```bash
sudo apt-get install libnss-winbind libpam-winbind
sudo ldconfig
```

**Package explanation**:
- `libnss-winbind`: Allows Linux to resolve AD users/groups via NSS
- `libpam-winbind`: Enables PAM authentication with AD credentials
- `ldconfig`: Updates shared library cache

#### 2. Configure Winbind in Samba

Edit `/etc/samba/smb.conf` in `[global]` section:

```bash
sudo nano /etc/samba/smb.conf
```

Add or verify these lines:

```ini
[global]
    # ... existing configuration ...
    
    # Winbind configuration
    winbind use default domain = yes
    template shell = /bin/bash
    template homedir = /home/%U
```

**Parameter explanation**:
- `winbind use default domain = yes`: Allows using username only without domain
- `template shell = /bin/bash`: Default shell for AD users
- `template homedir = /home/%U`: Automatic home directory based on username

#### 3. Restart Services

```bash
sudo systemctl restart samba-ad-dc
```

⚠️ If it doesn't work ⚠️

> Verify NSS configuration

```bash
cat /etc/nsswitch.conf | grep -E "passwd|group"
```

> Must have `winbind` in group line:

```bash
passwd:         files systemd winbind
group:          files systemd winbind
```

#### 4. Verify Group Resolution

```bash
# Verify Linux can see Domain Users group
getent group "Domain Users"
```

---

**Permission explanation (3770)**:
- **3**: SetGID + Sticky Bit (inherits group + protects deletion)
- **7**: Owner (rwx)
- **7**: Group (rwx)
- **0**: Others (no access)

### 📝 Shared Resources Configuration

Edit `/etc/samba/smb.conf`:

```bash
sudo nano /etc/samba/smb.conf
```

Add at the end:

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
    # Auditing
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

**Restart Samba**:

```bash
sudo smbcontrol all reload-config
```

### 🪟 ACL Management from Windows

1. From Windows client, open **File Explorer**
2. Connect to `\\lab03.local` or `(SERVER-IP)`
3. Right-click on folder → **Properties** → **Security**
4. **Edit** → Add groups and configure permissions

**Example**:
- **Students**: Modify (Read, Write, Delete)
- **IT_Admins**: Full Control
- **Finance** (if exists): **Deny** all

![Permission management in Windows](/evidencias/06-recursos/windows-acl-management.png)

### 🐧 Automatic Mounting on Linux Client

#### 📦 Installation

```bash
sudo apt install libpam-mount cifs-utils
```

#### ⚙️ Configuration

Edit `/etc/security/pam_mount.conf.xml`:

```xml
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">
<pam_mount>
    <debug enable="1" />
    
    <!-- Mount for Students -->
    <volume user="*" sgrp="students@lab03.local" 
            fstype="cifs" 
            server="lab03.local" 
            path="StudentDocs" 
            mountpoint="~/StudentDocs" 
            options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID),file_mode=0700,dir_mode=0700" />
    
    <!-- Mount for IT_Admins -->
    <volume user="*" sgrp="it_admins@lab03.local" 
            fstype="cifs" 
            server="lab03.local" 
            path="ITDocs" 
            mountpoint="~/ITDocs" 
            options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID),file_mode=0700,dir_mode=0700" />
    
    <!-- Mount for all domain users -->
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

#### ✅ Verification

When logging in as `bob@lab03.local`, `~/StudentDocs` should automatically mount.

```bash
# View active mounts
mount | grep cifs

# List files
ls -la ~/StudentDocs
```

### 📊 Storage System Verification

```bash
# View data disk usage
df -h /srv/samba

# View complete structure
tree -L 2 /srv/samba

# Expected output:
# /srv/samba
# ├── StudentDocs
# ├── ITDocs
# ├── HRDocs
# └── Public

# Verify permissions
ls -la /srv/samba

# Should show correct groups and 3770 permissions
```

---

### 🎯 Dedicated Disk Advantages

| Advantage | Description |
|---------|-------------|
| **Data Separation** | Operating system and data on different disks |
| **Scalability** | Easy to increase capacity or add more disks |
| **Selective Backup** | Back up only data without system |
| **Performance** | Reduces I/O load on system disk |
| **Production Reality** | Professional configuration used in enterprise environments |

---

![Automatic mounting on Linux](/evidencias/06-recursos/linux-auto-mount.png)

---

## 10. Domain Trusts

### 🌳 Scenario: Create Second Forest

We'll create a second domain `lab03trust.local` and establish a **Forest Trust** type trust.

### 🖥️ Second Server Preparation

#### Specifications

| Parameter | Value |
|-----------|-------|
| **Hostname** | ls03trust |
| **Domain** | lab03trust.local |
| **IP** | 192.168.2.3 |
| **RAM** | 4 GB |
| **CPU** | 2 cores |

#### 🔧 Initial Configuration

```bash
# Rename server
sudo hostnamectl set-hostname ls03trust

# Configure static IP (Netplan)
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
# Apply changes
sudo netplan apply

# Configure /etc/hosts
sudo nano /etc/hosts
```

```
127.0.0.1       localhost
127.0.1.1       ls03trust
192.168.2.3     ls03trust.lab03trust.local ls03trust
192.168.2.2     ls03.lab03.local ls03
```

#### ⏰ Time Synchronization

```bash
# Verify timezone
timedatectl

# Configure timezone
sudo timedatectl set-timezone Europe/Madrid

# Enable NTP
sudo timedatectl set-ntp true
```

### 📦 Installation and Promotion

```bash
# Install packages
sudo apt update
sudo apt install acl attr samba samba-dsdb-modules samba-vfs-modules \
                 smbclient winbind libpam-winbind libnss-winbind \
                 krb5-config krb5-user dnsutils -y
```

**Kerberos configuration**:
- **Realm**: `LAB03TRUST.LOCAL`
- **KDC**: `ls03trust.lab03trust.local`
- **Admin server**: `ls03trust.lab03trust.local`

#### 🚀 Second Domain Provision

```bash
# Backup configuration
sudo rm /etc/samba/smb.conf

# Provision
sudo samba-tool domain provision --use-rfc2307 --interactive
```

**Parameters**:
- **Realm**: `lab03trust.local`
- **Domain**: `lab03trust`
- **Server Role**: `dc`
- **DNS backend**: `SAMBA_INTERNAL`
- **DNS forwarder**: `10.239.3.7`

```bash
# Configure Kerberos
sudo cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# Start service
sudo systemctl stop smbd nmbd winbind
sudo systemctl disable smbd nmbd winbind
sudo systemctl unmask samba-ad-dc
sudo systemctl enable samba-ad-dc
sudo systemctl start samba-ad-dc
```

### 🌐 DNS Configuration for Trusts

#### Option 1: Manual Configuration

On each DC, `resolv.conf` must point to itself:

```bash
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf
```

```bash
# On dc01 (lab03.local)
echo "nameserver 192.168.2.30" > /etc/resolv.conf
echo "search lab03.local" >> /etc/resolv.conf

# On dc02 (lab04.local)
echo "nameserver 192.168.2.40" > /etc/resolv.conf
echo "search lab04.local" >> /etc/resolv.conf
```

```bash
sudo systemctl restart samba-ad-dc
```

**Configure chain forwarder in `smb.conf`:**

```ini
# dc01/smb.conf → forwards to dc02
dns forwarder = 192.168.2.40

# dc02/smb.conf → forwards to internet
dns forwarder = 192.168.2.30
```

> This way dc01 resolves `lab04.local` through dc02, and dc02 resolves internet through Google DNS.

**Add records in each DC's `/etc/hosts`:**

```bash
# On dc01
echo "192.168.2.40    dc02.lab04.local    lab04.local" >> /etc/hosts

# On dc02
echo "192.168.2.30    dc01.lab03.local    lab03.local" >> /etc/hosts
```

#### Option 2: Conditional Forwarders

**On primary server (ls03 - 192.168.2.2)**:

```bash
# Create forward zone
sudo samba-tool dns zonecreate 192.168.2.2 lab03trust.local -U Administrator

# Add NS for second domain
sudo samba-tool dns add 192.168.2.2 lab03trust.local @ NS ls03trust.lab03trust.local -U Administrator

# Add A record
sudo samba-tool dns add 192.168.2.2 lab03trust.local ls03trust A 192.168.2.3 -U Administrator

# Verify
sudo samba-tool dns query 192.168.2.2 lab03trust.local @ ALL -U Administrator
nslookup ls03trust.lab03trust.local
```

**On secondary server (ls03trust - 192.168.2.3)**:

```bash
# Create forward zone
sudo samba-tool dns zonecreate 192.168.2.3 lab03.local -U Administrator

# Add NS for primary domain
sudo samba-tool dns add 192.168.2.3 lab03.local @ NS ls03.lab03.local -U Administrator

# Add A record
sudo samba-tool dns add 192.168.2.3 lab03.local ls03 A 192.168.2.2 -U Administrator

# Verify
sudo samba-tool dns query 192.168.2.3 lab03.local @ ALL -U Administrator
nslookup ls03.lab03.local
```

### 🤝 Trust Creation

**From primary server (ls03)**:

```bash
sudo samba-tool domain trust create lab03trust.local \
    -U Administrator@LAB03TRUST.LOCAL --type=forest
```

Or alternatively, from secondary server:

```bash
sudo samba-tool domain trust create lab03.local \
    -U Administrator@LAB03.LOCAL --type=forest
```

### ✅ Trust Verification

```bash
# List trusts
sudo samba-tool domain trust list

# Validate trust
sudo samba-tool domain trust validate lab04.local -U Administrator@LAB04.LOCAL
```

### 🔍 Cross-Domain Test

From domain `lab03.local`, access resources from domain `lab03trust.local`:

```bash
# List resources from other domain
smbclient //ls03trust.lab03trust.local/StudentDocs \
    -U bob@lab03.local -W LAB03
```

![Cross-domain access](/evidencias/07-trusts/cross-domain-access.png)

---

## 11. Auditing and Security

### 📊 Full Audit Configuration

#### 1. Configure rsyslog

Create configuration file:

```bash
sudo nano /etc/rsyslog.d/samba-audit.conf
```

Content:

```
# Redirect Samba audit logs to dedicated file
local7.notice   /var/log/samba_audit.log
& stop
```

#### 2. Create and Configure Log File

```bash
# Create file
sudo touch /var/log/samba_audit.log

# Set permissions
sudo chown syslog:adm /var/log/samba_audit.log
sudo chmod 640 /var/log/samba_audit.log
```

#### 3. Restart Services

```bash
# Restart rsyslog
sudo systemctl restart rsyslog

# Reload Samba
sudo smbcontrol all reload-config
```

### 📝 Log Visualization

```bash
# View logs in real-time
sudo tail -f /var/log/samba_audit.log

# Search specific events
sudo grep "unlinkat" /var/log/samba_audit.log
sudo grep "bob" /var/log/samba_audit.log
```

**Example log entry**:

```
Jan 15 14:23:45 ls03 smbd_audit: bob|192.168.2.100|lc03|StudentDocs|unlinkat|ok|file_deleted.txt
```

**Format**: `user|source_IP|hostname|resource|action|result|file`

![Audit logs](/evidencias/08-auditoria/audit-logs.png)

### 🔒 Security Policies

#### Password Policy

```bash
# View current configuration
samba-tool domain passwordsettings show

# Configure
sudo samba-tool domain passwordsettings set --complexity=on
sudo samba-tool domain passwordsettings set --min-pwd-length=10
sudo samba-tool domain passwordsettings set --min-pwd-age=1
sudo samba-tool domain passwordsettings set --max-pwd-age=90
sudo samba-tool domain passwordsettings set --history-length=12
```

#### Account Lockout Policy

```bash
sudo samba-tool domain passwordsettings set --account-lockout-threshold=5
sudo samba-tool domain passwordsettings set --account-lockout-duration=15
sudo samba-tool domain passwordsettings set --reset-account-lockout-after=15
```

---

## 12. Automation and Scheduled Tasks

### 💾 Automatic Backup Script

#### 1. Create Script

```bash
sudo nano /root/backup_samba.sh
```

Script content:

```bash
#!/bin/bash

# --- CONFIGURATION ---
DIR_DESTINO="/root/backups"
LOG_FILE="/var/log/samba_backup.log"
DIAS_A_GUARDAR=30

# --- COMMANDS (absolute paths) ---
TAR=/bin/tar
DATE=/bin/date
ECHO=/bin/echo
FIND=/usr/bin/find

# --- VARIABLES ---
FECHA=$($DATE +%F_%H-%M)
NOMBRE_ARCHIVO="backup_ad_$FECHA.tar.gz"
RUTA_COMPLETA="$DIR_DESTINO/$NOMBRE_ARCHIVO"

# Create destination directory if it doesn't exist
mkdir -p $DIR_DESTINO

# --- 1. EXECUTE BACKUP ---
$TAR -czf $RUTA_COMPLETA /var/lib/samba /etc/samba 2>/dev/null

# --- 2. VERIFICATION AND LOG ---
if [ $? -eq 0 ]; then
    $ECHO "[$FECHA] OK: Backup created: $NOMBRE_ARCHIVO" >> $LOG_FILE
    
    # --- 3. CLEANUP ---
    $FIND $DIR_DESTINO -name "backup_ad_*.tar.gz" -mtime +$DIAS_A_GUARDAR -delete
else
    $ECHO "[$FECHA] ERROR: Backup failed" >> $LOG_FILE
fi
```

#### 2. Make Script Executable

```bash
sudo chmod +x /root/backup_samba.sh
```

#### 3. Schedule with Cron

```bash
sudo crontab -e
```

Add at the end (daily backup at 9:15):

```
15 9 * * * /root/backup_samba.sh
```

**Cron format**: `m h dom mon dow command`

| Field | Value | Description |
|-------|-------|-------------|
| m | 15 | Minute (15) |
| h | 9 | Hour (09:00) |
| dom | * | Day of month (all) |
| mon | * | Month (all) |
| dow | * | Day of week (all) |

#### 4. Verify Operation

```bash
# Execute manually
sudo /root/backup_samba.sh

# View log
cat /var/log/samba_backup.log

# List backups
ls -lh /root/backups/
```

![Backup script](/evidencias/08-auditoria/backup-script.png)

### 📊 Process Monitoring

#### htop - Real-time Monitoring

```bash
# Install
sudo apt install htop

# Run
htop
```

**Filter Samba processes**:
1. Press `F4` (Filter)
2. Type: `samba`
3. View AD-related processes

![Monitoring with htop](/evidencias/08-auditoria/htop-monitoring.png)

#### Remote Process Management via SSH

```bash
# Connect remotely to client
ssh bob@lab03.local@lc03.lab03.local

# List user processes
ps -aux | grep bob

# Pause a process
kill -19 <PID>

# Resume a process
kill -18 <PID>

# Terminate a process
kill -9 <PID>
```

---

## 📊 Project Status

### ✅ Completed Tasks

- [x] Repository created
- [x] Ubuntu Server base installation
- [x] Static network configuration
- [x] Samba AD DC installation and configuration
- [x] Users, groups and OUs creation
- [x] Linux and Windows client joining to domain
- [x] Hybrid GPO configuration (Linux/Windows)
- [x] Shared resources implementation
- [x] Permissions and ACLs configuration
- [x] Automatic resource mounting on Linux
- [x] Domain trust creation (Forest Trust)
- [x] Auditing and security configuration
- [x] Backup scripts implementation
- [x] Scheduled tasks with Cron
- [x] Complete project documentation

---

## 📚 Additional Resources

### 📖 Official Documentation

- [Samba Wiki - AD DC](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)
- [Samba Wiki - Trust Relationships](https://wiki.samba.org/index.php/Trust_Relationships)
- [Ubuntu Server Documentation](https://ubuntu.com/server/docs)
- [Kerberos Documentation](https://web.mit.edu/kerberos/krb5-latest/doc/)

### 🎓 Guides and Tutorials

- [Red Hat - Integrating Linux with Active Directory](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/integrating_rhel_systems_directly_with_windows_active_directory/)
- [ArchWiki - Active Directory Integration](https://wiki.archlinux.org/title/Active_Directory_integration)

### 🛠️ Useful Tools

- [RSAT Tools](https://www.microsoft.com/en-us/download/details.aspx?id=45520) - Remote Server Administration Tools
- [Apache Directory Studio](https://directory.apache.org/studio/) - Graphical LDAP client
- [Wireshark](https://www.wireshark.org/) - Network traffic analysis

---

## 🤝 Contributions

This project is educational in nature. If you wish to contribute improvements or corrections:

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## ✍️ Author

**Systems Administrator**

- 🎓 Internship Project - Active Directory on Linux
- 📧 Contact: [rsaura9@gmail.com]
- 🐙 GitHub: [@Psyaura](https://github.com/psyaura)

---

## 🙏 Acknowledgments

- To the Samba community for their excellent documentation
- To Canonical for Ubuntu Server
- To all who contribute to free software

---

<div align="center">

**🌟 If this project has been useful to you, don't forget to give it a star 🌟**

[![Star this repo](https://img.shields.io/github/stars/tu-usuario/Domain-Controller-Active-Directory-with-Ubuntu-Server?style=social)](https://github.com/tu-usuario/Domain-Controller-Active-Directory-with-Ubuntu-Server)

</div>

---

<div align="center">
<sub>Developed with ❤️ for educational purposes | 2025</sub>
</div>
