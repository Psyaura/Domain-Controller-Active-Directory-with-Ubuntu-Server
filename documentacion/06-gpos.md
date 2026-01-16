## 📄 06-gpos.md

### Secciones principales:

1. **Creación desde Linux**:
   ```bash
   sudo samba-tool gpo create "Student_Policy" -U administrator
   sudo samba-tool gpo listall  # Obtener GUID
   sudo samba-tool gpo setlink "OU=Students,DC=lab03,DC=local" {GUID}
   ```

2. **Solución de Permisos**:
   ```bash
   sudo samba-tool ntacl sysvolreset
   ```

3. **Edición desde Windows**:
   - Instalar RSAT
   - Abrir `gpmc.msc`
   - Editar "Student_Policy"
   - Configurar: User Config → Policies → Admin Templates → Control Panel
   - Habilitar: "Prohibit access to Control Panel"

4. **Aplicación y Verificación**:
   - Windows: `gpupdate /force`
   - Intentar abrir Panel de Control → Error
   - Linux: Políticas de registro NO aplican (solo security policies)

5. **Políticas de Contraseñas**:
   ```bash
   samba-tool domain passwordsettings set --min-pwd-length=8
   samba-tool domain passwordsettings set --account-lockout-threshold=3
   ```

**Evidencias:**
- `admin_desde_cli.png`
- `command_reset_sysvol.png`
- `gpmc.msc.png`
- `habilitar_politca_rsat.png`
- `RSAT.png`
- `RSAT_directivas.png`
- `link_gpo.png`
- `studen_policy_in_server_show.png`
- `student_policy_from_server.png`
- `denied_control panel.png`

---
[⬅️ Anterior: Unión de Clientes](05-union-clientes.md) | [📚 Índice](README.md) | [➡️ Siguiente: Recursos Compartidos](07-recursos-compartidos.md)
