# 04 - Gestión de Usuarios, Grupos y OUs

## Creación de Usuarios
- samba-tool user create alice "admin_21"
- samba-tool user create bob "admin_21"
- samba-tool user create charlie "admin_21"

## Creación de Grupos
- samba-tool group add IT_Admins
- samba-tool group add Students
- samba-tool group addmembers Students bob,charlie

## Creación de OUs
- samba-tool ou create "OU=IT_Department,DC=lab03,DC=local"
- samba-tool ou create "OU=Students,DC=lab03,DC=local"

## Mover Usuarios a OUs
- samba-tool user move bob "OU=Students,DC=lab03,DC=local"

## Políticas de Contraseñas
- samba-tool domain passwordsettings show
- samba-tool domain passwordsettings set --min-pwd-length=8

## Evidencias
📂 evidencias/03-usuarios-grupos/
- crear_usuarios.png
- crear_grupos.png
- Creacion_OU.png
- meter_usu_grupos.png
- mover_usu_OU.png

[⬅️ Anterior](03-samba-ad-dc.md) | [➡️ Siguiente](05-union-clientes.md)
