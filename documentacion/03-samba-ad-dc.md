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

## Evidencias
📂 evidencias/02-configuracion/
- SAMBA-AD running.png
- dns_query.png
- kinit.png
- kerberos_tcp_lab03.local.png

[⬅️ Anterior](02-configuracion-red.md) | [➡️ Siguiente](04-gestion-usuarios.md)
