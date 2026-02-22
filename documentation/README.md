# 📚 Documentación Técnica del Proyecto

Esta carpeta contiene la documentación técnica detallada de cada fase del proyecto de Active Directory con Ubuntu Server + Samba4.

---

## 📋 Índice de Documentación

### 🔧 Fase 1: Instalación y Configuración Base

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [01-Base-installation.md](01-Base-installation.md) | Instalación de Ubuntu Server y configuración de VM | ⬜ |
| [02-Network-configuration.md](02-Network-configuration.md) | Configuración de red estática, hostname y DNS | ⬜ |
| [03-Samba-AD-DC.md](03-Samba-AD-DC.md) | Instalación de Samba y promoción a Domain Controller | ⬜ |

### 👥 Fase 2: Gestión de Identidades

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [04-User-management.md](04-User-management.md) | Creación y gestión de usuarios, grupos y OUs | ⬜ |

### 🖥️ Fase 3: Integración de Clientes

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [05-Client-joining.md](05-Client-joining.md) | Unión de clientes Linux y Windows al dominio | ⬜ |

### 🔐 Fase 4: Políticas y Permisos

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [06-GPOs.md](06-GPOs.md) | Configuración de Group Policy Objects (GPOs) | ⬜ |
| [07-Shared-resources.md](07-Shared-resources.md) | File Server, recursos compartidos y permisos | ⬜ |

### 🤝 Fase 5: Confianzas y Dominios

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [08-Domain-trusts.md](08-Domain-trusts.md) | Configuración de confianzas entre dominios (Forest Trust) | ⬜ |

### 📊 Fase 6: Seguridad y Administración

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| [09-Auditing.md](09-Auditing.md) | Auditoría, logs y políticas de seguridad | ⬜ |
| [10-Automation.md](10-Automation.md) | Scripts de backup, cron y monitorización | ⬜ |

---

## 📖 Cómo Usar Esta Documentación

### Para Estudiantes
1. Lee los documentos en orden (01 → 10)
2. Sigue los pasos detallados en cada archivo
3. Consulta las evidencias referenciadas
4. Practica los comandos en tu entorno

### Para Evaluadores
- Cada documento contiene la metodología completa de implementación
- Las evidencias están referenciadas al final de cada sección
- Los comandos incluyen explicaciones detalladas
- Se documentan tanto éxitos como errores encontrados

### Para Referencia Futura
- Usa el índice para acceder directamente a temas específicos
- Los comandos están listos para copiar y adaptar
- Se incluyen secciones de troubleshooting

---

## 🎯 Nivel de Detalle

Cada documento incluye:

✅ **Objetivos claros** de la sección
✅ **Requisitos previos** necesarios
✅ **Comandos completos** con explicaciones
✅ **Configuraciones** de archivos importantes
✅ **Verificaciones** para comprobar el éxito
✅ **Troubleshooting** para errores comunes
✅ **Referencias** a evidencias visuales
✅ **Próximos pasos** hacia la siguiente fase

---

## 📂 Documentos Relacionados

- **README Principal**: [../README.md](../README.md) - Vista general del proyecto
- **Evidencias**: [../evidence/](../evidence/) - Capturas de pantalla organizadas
- **Configuraciones**: [../configuracion/](../configuracion/) - Archivos de configuración
- **Guía de Contenido**: [../CONTENIDO_MD_FILES.md](../CONTENIDO_MD_FILES.md) - Qué incluir en cada MD

---

## 🔄 Estado de Completitud

| Fase | Documentos | Completos | %  |
|------|-----------|-----------|-----|
| Fase 1 | 3 | 0 | 0% |
| Fase 2 | 1 | 0 | 0% |
| Fase 3 | 1 | 0 | 0% |
| Fase 4 | 2 | 0 | 0% |
| Fase 5 | 1 | 0 | 0% |
| Fase 6 | 2 | 0 | 0% |
| **TOTAL** | **10** | **0** | **0%** |

---

## 📝 Convenciones de Documentación

### Formato de Comandos

```bash
# Comentario explicativo
comando --opcion valor

# Salida esperada:
# resultado del comando
```

### Formato de Archivos de Configuración

```ini
# /ruta/al/archivo.conf
[seccion]
    parametro = valor
    # Comentario sobre el parámetro
```

### Bloques de Atención

> **⚠️ Importante**: Información crítica que no debe ignorarse

> **💡 Tip**: Sugerencia o buena práctica

> **📌 Nota**: Información adicional útil

---

## 🛠️ Tecnologías Documentadas

- Ubuntu Server 24.04 LTS
- Samba 4.x (Active Directory Domain Services)
- Kerberos 5 (Autenticación)
- DNS (Samba Internal)
- LDAP (Directorio)
- GPOs (Group Policy Objects)
- CIFS/SMB (File Sharing)
- rsyslog (Logging)
- cron (Task Scheduling)

---

## 📞 Soporte

Si encuentras algún error en la documentación o tienes sugerencias de mejora:

1. Revisa la sección de **Troubleshooting** del documento relevante
2. Consulta las **evidencias** para ver ejemplos visuales
3. Verifica que seguiste todos los **pasos previos**
4. Consulta la **documentación oficial** de Samba

---

## 📄 Licencia

Esta documentación es parte del proyecto educativo de Active Directory con Ubuntu Server.

---

<div align="center">

**📚 Documentación completa y detallada para aprendizaje y referencia**

[⬅️ Volver al README Principal](../README.md)

</div>

---

<div align="center">
<sub>Documentación Técnica | Proyecto AD Ubuntu Server | 2025</sub>
</div>
