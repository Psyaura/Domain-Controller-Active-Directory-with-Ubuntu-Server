## 📄 04-User-management.md

# 04 - User, Group and OU Management

## User Creation

- samba-tool user create alice "admin_21"
- samba-tool user create bob "admin_21"
- samba-tool user create charlie "admin_21"

## Group Creation

- samba-tool group add IT_Admins
- samba-tool group add Students
- samba-tool group addmembers Students bob,charlie

## OU Creation

- samba-tool ou create "OU=IT_Department,DC=lab03,DC=local"
- samba-tool ou create "OU=Students,DC=lab03,DC=local"

## Move Users to OUs

- samba-tool user move bob "OU=Students,DC=lab03,DC=local"

## Password Policies

- samba-tool domain passwordsettings show
- samba-tool domain passwordsettings set --min-pwd-length=8

## 📸 Evidence

The following screenshots document this process:
