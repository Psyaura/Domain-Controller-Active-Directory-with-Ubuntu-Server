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

## 📸 Evidencias

Las siguientes capturas documentan este proceso:
```
📂 evidencias/05-gpos/
├── admin_desde_cli.png                 - Creación de GPO desde línea de comandos
├── command_reset_sysvol.png            - Comando samba-tool ntacl sysvolreset
├── gpmc.msc.png                        - Consola de administración de directivas de grupo
├── habilitar_politca_rsat.png          - Habilitación de política desde RSAT
├── RSAT.png                            - Instalación de RSAT en Windows
├── RSAT_directivas.png                 - Gestión de directivas desde RSAT
├── link_gpo.png                        - Vinculación de GPO a OU con setlink
├── studen_policy_in_server_show.png    - Student_Policy visible en el servidor
├── student_policy_from_server.png      - Verificación de GPO desde servidor
└── denied_control panel.png            - Panel de Control bloqueado por GPO
```

---

[⬅️ Anterior: Unión de Clientes](05-union-clientes.md) | [📚 Índice](README.md) | [➡️ Siguiente: Recursos Compartidos](07-recursos-compartidos.md)
