## 📄 07-Shared-resources.md

### Main Sections:

#### 0. **Add Dedicated Disk for Shared Resources**

**On VirtualBox (VM powered off)**:
- Create virtual disk: 15 GB, VDI, Dynamically allocated
- Name: `Linux Server AD_1.vdi`
- Add to SATA Controller

**On Ubuntu Server**:
```bash
# Identify disk
lsblk  # Should show /dev/sdb

# Partition
sudo fdisk /dev/sdb
# Commands: n → p → 1 → [Enter] → +10G → w

# Format
sudo mkfs.ext4 /dev/sdb1

# Create mount point
sudo mkdir -p /srv/samba
sudo mount /dev/sdb1 /srv/samba

# Configure automatic mounting
sudo blkid /dev/sdb1  # Copy UUID
sudo nano /etc/fstab
# Add: UUID=xxx  /srv/samba  ext4  defaults  0  2

# Verify
sudo mount -a
df -h | grep samba
```

#### 1. **Server Preparation**
```bash
# Create directory structure
sudo mkdir -p /srv/samba/{StudentDocs,ITDocs,HRDocs,Public}

# Install winbind libraries
sudo apt-get install libnss-winbind libpam-winbind
sudo ldconfig
```

Edit `/etc/samba/smb.conf` in `[global]`:
```ini
winbind use default domain = yes
template shell = /bin/bash
template homedir = /home/%U
```

Configure permissions (3770):
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

**Permission explanation (3770)**: SetGID + Sticky Bit + rwxrwx---

#### 2. **smb.conf Configuration**

Add at the end of `/etc/samba/smb.conf`:
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
    # Auditing with full_audit

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

Restart: `sudo smbcontrol all reload-config`

#### 3. **ACL Management from Windows**

- Explorer → `\\lab03.local`
- Right-click on folder → Properties → Security
- Edit → Add groups (Students, IT_Admins, etc.)
- Configure permissions (Modify, Read, Write)
- Deny access to specific groups if necessary

#### 4. **Automatic Mounting on Linux Client**
```bash
sudo apt install libpam-mount cifs-utils
sudo nano /etc/security/pam_mount.conf.xml
```

Configure volumes by group:
```xml
<volume user="*" sgrp="students@lab03.local" 
        fstype="cifs" 
        server="lab03.local" 
        path="StudentDocs" 
        mountpoint="~/StudentDocs" 
        options="sec=ntlmssp,cruid=%(USERUID),uid=%(USERUID),gid=%(USERGID)" />
```

Verification: `mount | grep cifs`

## 📸 Evidence

The following screenshots document this process:
```
📂 evidencias/06-recursos/
├── disk-creation-vbox.png              [NEW] - Disk creation in VirtualBox
├── disk-partition-fdisk.png            [NEW] - Partitioning with fdisk
├── disk-format-mkfs.png                [NEW] - Disk formatting
├── disk-mount-fstab.png                [NEW] - Configuration in fstab
├── directory-structure-data.png        [NEW] - Structure in /srv/samba
├── directory-permissions.png           [NEW] - Configured 3770 permissions
├── smb.conf.png                        - smb.conf configuration
├── Network_folders_windows.png         - Folders viewed from Windows
├── error_domain_users_group.png        - Domain Users error solution
├── windows-acl-security.png            [RECOMMENDED] - Security tab
├── windows-acl-students.png            [RECOMMENDED] - Students permissions
├── linux-pam-mount-config.png          [RECOMMENDED] - pam_mount.conf.xml
├── linux-auto-mount.png                [RECOMMENDED] - Mounted folders
└── linux-mounted-shares.png            [RECOMMENDED] - mount | grep cifs
```

---

[⬅️ Previous: GPOs](06-GPOs.md) | [📚 Index](README.md) | [➡️ Next: Trusts](08-Domain-trusts.md)
