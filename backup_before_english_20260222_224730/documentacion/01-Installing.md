## 📄 01-Installing.md

### Main Sections:

**You already have this complete file as an example**, but here's a summary of what it contains:

1. **Objective**: Install Ubuntu Server 24.04 LTS as the base for the DC

2. **Prerequisites**:
   - VirtualBox 7.x installed
   - Ubuntu Server 24.04 LTS ISO
   - Minimum 8 GB RAM on host

3. **VM Specifications**:
   - Table with: RAM (4GB), CPU (2), Disk (20GB), Network (2 adapters)

4. **Step-by-Step Installation Process**:
   - Create VM in VirtualBox
   - Configure network adapters (NAT + Internal Network)
   - Mount ISO
   - Ubuntu Server installation:
     - Language: English
     - Keyboard: Spanish
     - Type: Ubuntu Server
     - Network: Temporary DHCP
     - Storage: Use entire disk
     - Profile: username `admin`, hostname `ls03`
     - SSH: Check OpenSSH Server ✓
     - Featured snaps: Do not check any
   - Reboot and first login

5. **Post-Installation Verification**:
```bash
   lsb_release -a
   ping -c 4 8.8.8.8
   ip addr show
   sudo apt update && sudo apt upgrade -y
```

6. **Troubleshooting**:
   - Network interfaces not detected
   - No Internet access
   - Extremely slow VM
   - SSH not responding

## 📸 Evidence

The following screenshots document this process:
```
📂 evidencias/01-instalacion/
├── Instalacion Linux Vbox.png          - VM configuration in VirtualBox
├── Configuracion discos.png            - Virtual hard disk configuration
├── ssh-enabled.png             [RECOMMENDED] - OpenSSH Server checked during installation
└── ubuntu-boot.png             [RECOMMENDED] - First successful server boot
```

[📚 Index](README.md) | [➡️ Next: Network Configuration](02-configuracion-red.md)
