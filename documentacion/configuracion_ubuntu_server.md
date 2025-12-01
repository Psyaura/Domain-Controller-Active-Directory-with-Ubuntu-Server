## 1. Crear la VM Ubuntu Server
- 4 GB RAM (aprox.)
- 2 CPU 
- 20 GB disco

Ubuntu Server 22.04/24.04 LTS

## 2. Añadir dos adaptadores de red
✔ Adapter 1 → Adaptador puente (para instalar paquetes)
✔ Adapter 2 → Internal Network (tráfico de dominio)
Nombre del internal: intnet

## 3. Durante la instalación
Nombramos la maquina , usuario y configuramos una contraseña segura

Desactivamos lvm (en nuestro caso), usuamos todo el disco.

Instalar OpenSSH Server
Desmarcar “Snap packages” si quieres instalar rápido.
NO instalar roles extra.

> [!NOTE]
> Reiniciamos el equipo tras la instalacion como nos indica, y quitamos el disco de instalacion (ISO).




