# 03 - Instalación y Configuración de Samba AD DC

## Objetivo
Promocionar el servidor Ubuntu a Controlador de Dominio usando Samba AD.

## Instalación de Paquetes
- apt install samba krb5-user winbind smbclient dnsutils
- Configuración de Kerberos durante instalación
- Explicar cada paquete

## Preparación del DNS
- Detener systemd-resolved
- Configurar resolv.conf

## Provisión del Dominio
- samba-tool domain provision
- Parámetros: Realm, Domain, Server Role, etc.

## Configuración Post-Provisión
- Copiar krb5.conf
- Configurar interfaces en smb.conf
- Arrancar samba-ad-dc

## Verificación
- samba-tool domain level show
- host -t SRV _ldap._tcp.lab03.local
- kinit administrator
- klist

## 📸 Evidencias

Las siguientes capturas documentan este proceso:
```
📂 evidencias/02-configuracion/
├── SAMBA-AD running.png                - Servicio samba-ad-dc activo y funcionando
├── dns_query.png                       - Consultas DNS exitosas al dominio
├── kinit.png                           - Obtención de ticket Kerberos con kinit
├── kerberos_tcp_lab03.png              - Registros SRV de Kerberos en DNS
├── kerb_realm_cli.png                  - Configuración del realm Kerberos
├── krb.png                             - Archivo /etc/krb5.conf configurado
├── krb_serv_cli.png                    - Verificación del servidor Kerberos
└── smbclient_show_net_folders.png      - Recursos compartidos netlogon y sysvol
```

[⬅️ Anterior](02-configuracion-red.md) | [➡️ Siguiente](04-gestion-usuarios.md)
