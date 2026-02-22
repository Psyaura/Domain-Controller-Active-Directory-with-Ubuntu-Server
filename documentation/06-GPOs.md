## 📄 06-GPOs.md

### Main Sections:

1. **Creation from Linux**:
```bash
   sudo samba-tool gpo create "Student_Policy" -U administrator
   sudo samba-tool gpo listall  # Get GUID
   sudo samba-tool gpo setlink "OU=Students,DC=lab03,DC=local" {GUID}
```

2. **Permission Fix**:
```bash
   sudo samba-tool ntacl sysvolreset
```

3. **Editing from Windows**:
   - Install RSAT
   - Open `gpmc.msc`
   - Edit "Student_Policy"
   - Configure: User Config → Policies → Admin Templates → Control Panel
   - Enable: "Prohibit access to Control Panel"

4. **Application and Verification**:
   - Windows: `gpupdate /force`
   - Try to open Control Panel → Error
   - Linux: Registry policies DO NOT apply (only security policies)

5. **Password Policies**:
```bash
   samba-tool domain passwordsettings set --min-pwd-length=8
   samba-tool domain passwordsettings set --account-lockout-threshold=3
```

## 📸 Evidence

The following screenshots document this process:
```
📂 evidence/05-gpos/
├── admin_desde_cli.png                 - GPO creation from command line
├── command_reset_sysvol.png            - samba-tool ntacl sysvolreset command
├── gpmc.msc.png                        - Group Policy Management Console
├── habilitar_politca_rsat.png          - Policy enablement from RSAT
├── RSAT.png                            - RSAT installation on Windows
├── RSAT_directivas.png                 - Policy management from RSAT
├── link_gpo.png                        - GPO linking to OU with setlink
├── studen_policy_in_server_show.png    - Student_Policy visible on server
├── student_policy_from_server.png      - GPO verification from server
└── denied_control panel.png            - Control Panel blocked by GPO
```

---

[⬅️ Previous: Client Joining](05-Client-joining.md) | [📚 Index](README.md) | [➡️ Next: Shared Resources](07-Shared-resources.md)
