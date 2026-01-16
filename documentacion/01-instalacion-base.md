## 📄 01-instalacion-base.md

### Secciones principales:

**Ya tienes este archivo completo como ejemplo**, pero aquí está el resumen de lo que contiene:

1. **Objetivo**: Instalar Ubuntu Server 24.04 LTS como base para el DC

2. **Requisitos Previos**:
   - VirtualBox 7.x instalado
   - ISO de Ubuntu Server 24.04 LTS
   - 8 GB RAM en host mínimo

3. **Especificaciones de la VM**:
   - Tabla con: RAM (4GB), CPU (2), Disco (20GB), Red (2 adaptadores)

4. **Proceso de Instalación Paso a Paso**:
   - Crear VM en VirtualBox
   - Configurar adaptadores de red (NAT + Red Interna)
   - Montar ISO
   - Instalación de Ubuntu Server:
     - Idioma: English
     - Teclado: Spanish
     - Tipo: Ubuntu Server
     - Red: DHCP temporal
     - Storage: Usar disco completo
     - Perfil: username `admin`, hostname `ls03`
     - SSH: Marcar OpenSSH Server ✓
     - Featured snaps: No marcar ninguno
   - Reinicio y primer login

5. **Verificación Post-Instalación**:
   ```bash
   lsb_release -a
   ping -c 4 8.8.8.8
   ip addr show
   sudo apt update && sudo apt upgrade -y
   ```

6. **Solución de Problemas**:
   - No se detectan interfaces de red
   - No hay acceso a Internet
   - VM extremadamente lenta
   - SSH no responde

**Evidencias:**
- `Instalacion Linux Vbox.png`
- `Configuracion discos.png`
- [RECOMENDADO] ssh-enabled.png
- [RECOMENDADO] ubuntu-boot.png

---

[📚 Índice](README.md) | [➡️ Siguiente: Configuración de Red](02-configuracion-red.md)
