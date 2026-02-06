## 📄 05-union-clientes.md

### Secciones principales:

1. **Objetivo**: Unir clientes Linux y Windows al dominio lab03.local

2. **Cliente Ubuntu Desktop**:
   - Instalación de paquetes: `realmd sssd sssd-tools samba-common krb5-user packagekit samba-common-bin adcli`
   - Configuración `/etc/resolv.conf` → apuntar al DC
   - Configuración `/etc/hosts` → añadir DC
   - Configuración `/etc/krb5.conf` → realm LAB03.LOCAL
   - Comando: `realm discover lab03.local`
   - Comando: `sudo realm join lab03.local -U Administrator --verbose`
   - Verificación: `realm list`, `id bob@lab03.local`
   - PAM: `sudo pam-auth-update --enable mkhomedir`
   - GDM: Editar `/etc/pam.d/gdm-password` para crear home

3. **Cliente Windows**:
   - Configuración DNS → IP del DC
   - Unión al dominio desde Panel de Control
   - Instalación RSAT para gpmc.msc

## 📸 Evidencias

Las siguientes capturas documentan este proceso:
```
📂 evidencias/04-clientes/
├── realm_discover.png                  - Descubrimiento del dominio lab03.local
├── realm_join.png                      - Unión del cliente Ubuntu al dominio
├── realm_list.png                      - Verificación de dominio unido
├── id_comprobacion.png                 - Comando id verificando usuario del dominio
└── pam_sesion_grafica.png              - Login gráfico con usuario del dominio
```

---

[⬅️ Anterior: Gestión de Usuarios](04-gestion-usuarios.md) | [📚 Índice](README.md) | [➡️ Siguiente: GPOs](06-gpos.md)
