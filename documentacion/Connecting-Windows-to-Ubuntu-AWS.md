# Connecting to Ubuntu Server on AWS from Windows Server

## 1. Create Key Pair Before Launching the Instance

Before launching any Windows instance on AWS, you need to create a key pair to decrypt the Administrator password.

1. Go to **EC2 → Key Pairs → Create Key Pair**
2. Configure:
   - **Type**: RSA
   - **Format**: .pem
3. The `.pem` file will download automatically — **save it securely**, it cannot be downloaded again.

> **Important:** If you don't create the key pair with RSA format and PEM, you won't be able to decrypt the Windows password later.

When launching the instance, select this key pair in **Network settings**.

---

## 2. Get Windows Password

1. Go to **EC2 → Instances → select the Windows instance**
2. **Actions → Security → Get Windows Password**
3. Upload the `.pem` file or paste its content
4. Click **Decrypt Password**
5. Copy the generated password

> The password may take 4-5 minutes to become available after first boot.

---

## 3. Configure Security Group

In the Security Group associated with the instances, configure the following rules:

### 3.1 Inbound Rules

#### RDP Access (from outside)

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| RDP  | TCP      | 3389 | My IP  |

#### Ping Between Instances (internal network)

| Type            | Protocol | Port | Source      |
|-----------------|----------|------|-------------|
| All ICMP - IPv4 | ICMP     | All  | 10.0.0.0/16 |

#### Samba/SMB (for shared folders)

| Type       | Protocol | Port    | Source      |
|------------|----------|---------|-------------|
| Custom TCP | TCP      | 445     | 10.0.0.0/16 |
| Custom TCP | TCP      | 139     | 10.0.0.0/16 |
| Custom UDP | UDP      | 137-138 | 10.0.0.0/16 |

#### SSH Access (to Ubuntu Server)

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| SSH  | TCP      | 22   | My IP  |

### 3.2 Outbound Rules

⚠️ **CRITICAL: Configure outbound traffic**

| Type        | Protocol | Port Range | Destination |
|-------------|----------|------------|-------------|
| All traffic | All      | All        | 0.0.0.0/0   |

> **Important:** Without the outbound rule allowing all traffic, instances won't be able to communicate with each other or access the internet for updates and package downloads.

> Adjust the CIDR `10.0.0.0/16` to match your VPC range.

---

## 4. Network Prerequisites

### 4.1 Verify VPC Configuration

Ensure both instances are in the same VPC:

1. Go to **EC2 → Instances**
2. Select each instance and check the **VPC ID** in the details tab
3. Both must have the same VPC ID

### 4.2 Verify Subnet Configuration (Optional)

For better performance, place both instances in the same subnet or ensure proper routing between subnets.

### 4.3 Note Private IP Addresses

Get the private IP addresses of both instances:
```
Windows Server: 172.31.XX.XX (example)
Ubuntu Server:  172.31.YY.YY (example)
```

These will be used for internal communication.

---

## 5. Configure Samba on Ubuntu Server

Before connecting from Windows, ensure Samba is properly configured on Ubuntu:
```bash
# Install Samba
sudo apt update
sudo apt install samba -y

# Create a shared directory
sudo mkdir -p /srv/samba/shared
sudo chmod 777 /srv/samba/shared

# Configure Samba
sudo nano /etc/samba/smb.conf
```

Add at the end of `smb.conf`:
```ini
[Shared]
    path = /srv/samba/shared
    browseable = yes
    writable = yes
    guest ok = no
    valid users = ubuntu
```

Create Samba user:
```bash
# Add Samba user (use the same username as your Ubuntu user)
sudo smbpasswd -a ubuntu

# Restart Samba
sudo systemctl restart smbd
sudo systemctl enable smbd
```

Verify Samba is running:
```bash
sudo systemctl status smbd
```

---

## 6. Connect to Windows Server via RDP

Installation on Ubuntu Server with `xfreerdp`:
```bash
sudo apt install freerdp2-x11 -y
```

From terminal with `xfreerdp`:
```bash
xfreerdp /v:ec2-54-198-175-214.compute-1.amazonaws.com /u:Administrator /p:'YourPasswordHere'
```

Or using the public IP:
```bash
xfreerdp /v:<WINDOWS_PUBLIC_IP> /u:Administrator /p:'YourPasswordHere'
```

When connecting for the first time, accept the self-signed certificate with **Y**.

> **Tip:** If you prefer a GUI RDP client, install Remmina: `sudo apt install remmina -y`

---

## 7. Access Ubuntu Server Shared Folders from Windows

Once inside Windows Server via RDP:

### 7.1 Enable Network Discovery

Open PowerShell as Administrator and run:
```powershell
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
```

### 7.2 Change Network Profile to Private
```powershell
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private
```

Verify the change:
```powershell
Get-NetConnectionProfile
```

### 7.3 Access Shared Resources

Open File Explorer and type in the address bar:
```
\\<UBUNTU_PRIVATE_IP>
```

Example:
```
\\172.31.16.133
```

Enter the Ubuntu server's Samba credentials when prompted:
- **Username:** ubuntu
- **Password:** [the password you set with smbpasswd]

---

## 8. Connectivity Verification

### 8.1 From Windows Server

Open PowerShell and run:
```powershell
# Check ping
ping 172.31.16.133

# Check SMB port
Test-NetConnection 172.31.16.133 -Port 445

# Check network adapter
ipconfig /all
```

### 8.2 From Ubuntu Server
```bash
# Check Samba status
sudo systemctl status smbd

# Check listening ports
sudo netstat -tulpn | grep smbd

# Check firewall (UFW) status
sudo ufw status

# Test connection to Windows
ping <WINDOWS_PRIVATE_IP>
```

---

## 9. Troubleshooting

### Problem: Cannot connect via RDP

**Solutions:**
1. Verify Security Group allows RDP (port 3389) from your IP
2. Check that the Windows instance is running
3. Wait 4-5 minutes after first launch for password to be available
4. Verify you're using the correct public DNS/IP

### Problem: Cannot ping between instances

**Solutions:**
1. Verify Security Group allows ICMP traffic
2. Check both instances are in the same VPC
3. Verify **outbound rules** allow all traffic
4. Check Windows Firewall is not blocking ICMP

### Problem: Cannot access Samba shares

**Solutions:**

**On Ubuntu Server:**
```bash
# Restart Samba
sudo systemctl restart smbd

# Check if port 445 is open
sudo ufw allow 445/tcp
sudo ufw allow 139/tcp
sudo ufw allow 137:138/udp

# Verify Samba user exists
sudo pdbedit -L
```

**On Windows Server:**
```powershell
# Reset network discovery
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

# Flush DNS
ipconfig /flushdns

# Check connectivity
Test-NetConnection <UBUNTU_PRIVATE_IP> -Port 445
```

### Problem: "Network path not found"

**Solutions:**
1. Verify you're using the **private IP** (172.31.x.x), not public IP
2. Check Samba service is running on Ubuntu
3. Verify credentials are correct
4. Try accessing with FQDN: `\\ip-172-31-16-133.ec2.internal`

### Problem: Outbound traffic blocked

**Symptoms:**
- Cannot download packages with `apt` or `yum`
- Instances cannot communicate
- Cannot access internet from instances

**Solution:**
1. Go to **EC2 → Security Groups**
2. Select your Security Group
3. **Outbound rules** tab
4. Click **Edit outbound rules**
5. Ensure there's a rule:
   - Type: All traffic
   - Destination: 0.0.0.0/0

---

## 10. Best Practices

### Security Recommendations

1. **Use Elastic IP** for Windows Server if you need a fixed public IP
2. **Restrict RDP access** to specific IPs instead of 0.0.0.0/0
3. **Use VPN or AWS Session Manager** instead of exposing RDP to the internet
4. **Enable CloudWatch** for monitoring instance health
5. **Regular backups** with AMI snapshots
6. **Use IAM roles** instead of storing credentials

### Network Optimization

1. Place instances in the same **Availability Zone** for lower latency
2. Use **Enhanced Networking** for better performance
3. Consider **VPC Peering** for multi-VPC setups
4. Use **PrivateLink** for accessing AWS services without internet gateway

### Cost Optimization

1. Use **t3** instances for development/testing (cheaper)
2. **Stop instances** when not in use (you still pay for storage)
3. Use **Spot Instances** for non-critical workloads
4. Monitor with **AWS Cost Explorer**

---

## 11. Quick Reference Commands

### Ubuntu Server
```bash
# Check Samba status
sudo systemctl status smbd

# View Samba logs
sudo tail -f /var/log/samba/log.smbd

# List Samba users
sudo pdbedit -L

# Test Samba configuration
testparm

# Check network interfaces
ip addr show

# Check routes
ip route show
```

### Windows Server
```powershell
# View network configuration
ipconfig /all

# Test connection
Test-NetConnection <IP> -Port <PORT>

# View firewall rules
Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'True'}

# Check SMB version
Get-SmbConnection
```

---

## 12. Additional Resources

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Samba Official Documentation](https://www.samba.org/samba/docs/)
- [AWS Security Groups Guide](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- [Windows Server on AWS](https://aws.amazon.com/windows/)

---

<div align="center">
<sub>AWS Connectivity Guide | Windows ↔ Ubuntu | 2025</sub>
</div>
