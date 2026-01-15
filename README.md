# Domain-Controller-Active-Directory-with-Ubunut-Server

## 📌 Descripción del proyecto

Este proyecto consiste en la instalación y configuración de un Controlador de Dominio (Domain Controller) basado en Ubuntu Server utilizando Samba Active Directory.
El objetivo es crear un entorno de autenticación centralizada que permita gestionar usuarios, grupos, políticas y equipos dentro de una red local.

Este repositorio reúne la documentación, configuraciones y evidencias necesarias para la entrega de la práctica.

## 🧩 Objetivos del proyecto

- Instalar y preparar Ubuntu Server para funcionar como Domain Controller.

- Configurar Samba en modo AD DC.

- Implementar y validar un servicio DNS integrado.

- Crear usuarios y grupos dentro del dominio.

- Unir clientes al dominio.

- Realizar pruebas de autenticación.

- Documentar cada paso del proceso.

## 🛠️ Tecnologías utilizadas

- Ubuntu Server

- Samba Active Directory (AD DC)

- Samba DNS interno

- Herramientas de administración de Linux

- Equipos clientes Linux o Windows (para pruebas)

## 📂 Estructura del repositorio


```
Domain-Controller-Active-Directory-with-Ubuntu-Server/
├── README.md                          # Este archivo
├── documentacion/                     # Documentación técnica detallada
│   ├── 01-instalacion-base.md        # Instalación de Ubuntu Server
│   ├── 02-configuracion-red.md       # Configuración de red estática
│   ├── 03-samba-ad-dc.md             # Promoción a DC
│   ├── 04-gestion-usuarios.md        # Usuarios, grupos y OUs
│   ├── 05-union-clientes.md          # Unión de clientes al dominio
│   ├── 06-gpos.md                    # Políticas de grupo
│   ├── 07-recursos-compartidos.md    # File Server y permisos
│   ├── 08-trusts.md                  # Confianzas de dominio
│   ├── 09-auditoria.md               # Seguridad y logging
│   └── 10-automatizacion.md          # Scripts y tareas programadas
├── configuracion/                     # Archivos de configuración
│   ├── smb.conf                      # Configuración de Samba
│   ├── krb5.conf                     # Configuración de Kerberos
│   ├── netplan/                      # Configuraciones de red
│   ├── pam_mount.conf.xml            # Montaje automático de recursos
│   └── scripts/                      # Scripts de automatización
│       ├── backup_samba.sh           # Script de backup del AD
│       └── user_creation.sh          # Script de creación masiva de usuarios
├── evidencias/                        # Capturas de pantalla y pruebas
│   ├── 01-instalacion/               # Evidencias de instalación
│   ├── 02-configuracion/             # Evidencias de configuración
│   ├── 03-usuarios-grupos/           # Gestión de usuarios y OUs
│   ├── 04-clientes/                  # Unión de clientes
│   ├── 05-gpos/                      # Políticas aplicadas
│   ├── 06-recursos/                  # Recursos compartidos
│   ├── 07-trusts/                    # Confianzas de dominio
│   └── 08-auditoria/                 # Logs y auditoría
└── LICENSE                            # Licencia del proyecto
```

## 🚀 Progreso del proyecto

- [ ] Repositorio creado

- [ ] Instalación base de Ubuntu Server

- [ ] Configuración de red

- [ ] Instalación y configuración de Samba AD DC

- [ ] Unión de clientes

- [ ] Pruebas de autenticación

- [ ] Documentación final

> [!NOTE]
> Useful information that users should know, este contenido esta dedicado al ambito educativo.


## 🚀 Guía de Implementación Completa

### 📋 Tabla de Contenidos

1. [Preparación del Entorno Virtual](#1-preparación-del-entorno-virtual)
2. [Instalación de Ubuntu Server](#2-instalación-de-ubuntu-server)
3. [Configuración de Red](#3-configuración-de-red)
4. [Instalación de Samba y Dependencias](#4-instalación-de-samba-y-dependencias)
5. [Promoción a Domain Controller](#5-promoción-a-domain-controller)
6. [Gestión de Usuarios, Grupos y OUs](#6-gestión-de-usuarios-grupos-y-ous)
7. [Unión de Clientes al Dominio](#7-unión-de-clientes-al-dominio)
8. [Configuración de GPOs](#8-configuración-de-gpos)
9. [Recursos Compartidos y Permisos](#9-recursos-compartidos-y-permisos)
10. [Confianzas de Dominio](#10-confianzas-de-dominio)
11. [Auditoría y Seguridad](#11-auditoría-y-seguridad)
12. [Automatización y Tareas Programadas](#12-automatización-y-tareas-programadas)
