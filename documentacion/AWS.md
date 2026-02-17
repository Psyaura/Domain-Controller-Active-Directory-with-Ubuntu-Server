
# Conexión a Ubuntu Server en AWS desde Windows Server

## 1. Crear Key Pair antes de lanzar la instancia

Antes de lanzar cualquier instancia Windows en AWS, es necesario crear un par de claves para poder descifrar la contraseña del Administrator.

1. Ir a **EC2 → Key Pairs → Create Key Pair**
2. Configurar:
   - **Tipo**: RSA
   - **Formato**: .pem
3. Se descargará automáticamente el archivo `.pem` — **guardarlo bien**, no se puede volver a descargar.

> **Importante:** Si no se crea el key pair con formato RSA y PEM, no será posible descifrar la contraseña de Windows posteriormente.

Al lanzar la instancia, seleccionar este key pair en **Network settings**.

---

## 2. Obtener la contraseña de Windows

1. Ir a **EC2 → Instances → seleccionar la instancia Windows**
2. **Actions → Security → Get Windows Password**
3. Subir el archivo `.pem` o pegar su contenido
4. Click en **Decrypt Password**
5. Copiar la contraseña generada

> La contraseña puede tardar 4-5 minutos en estar disponible tras el primer arranque.

---

## 3. Configurar Security Group

En el Security Group asociado a las instancias, añadir las siguientes reglas de entrada:

### Acceso RDP (desde fuera)

| Tipo | Protocolo | Puerto | Origen |
|------|-----------|--------|--------|
| RDP  | TCP       | 3389   | My IP  |

### Ping entre instancias (red interna)

| Tipo             | Protocolo | Puerto | Origen          |
|------------------|-----------|--------|-----------------|
| All ICMP - IPv4  | ICMP      | All    | 10.0.0.0/16     |

### Samba/SMB (para carpetas compartidas)

| Tipo       | Protocolo | Puerto  | Origen      |
|------------|-----------|---------|-------------|
| Custom TCP | TCP       | 445     | 10.0.0.0/16 |
| Custom TCP | TCP       | 139     | 10.0.0.0/16 |
| Custom UDP | UDP       | 137-138 | 10.0.0.0/16 |

> Ajustar el CIDR `10.0.0.0/16` al rango de la VPC utilizada.

---

## 4. Conectarse al Windows Server por RDP

Instalación en el Ubuntu Server con `xfreerdp`:

```bash
sudo apt install freerdp2-x11
```

Desde la termianl con `xfreerdp`:

```bash
xfreerdp /v:ec2-54-198-175-214.compute-1.amazonaws.com /u:Administrator /p:'D(bW8S))tJce%YjC&t3p?V!=yJ$aU&SC'
```

Al conectarse por primera vez, aceptar el certificado autofirmado con **Y**.

---

## 5. Acceder a carpetas compartidas del Ubuntu Server

Una vez dentro del Windows Server por RDP:

### 5.1 Activar Network Discovery

Abrir PowerShell como Administrador y ejecutar:

```powershell
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
```

### 5.2 Cambiar perfil de red a Privado

```powershell
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private
```

### 5.3 Acceder a los recursos compartidos

Abrir el Explorador de archivos y escribir en la barra de direcciones:

```
\\<IP_PRIVADA_UBUNTU>
```

Ejemplo:

```
\\172.31.16.133
```

Introducir las credenciales de Samba del servidor Ubuntu cuando las solicite.

---

## 6. Verificación de conectividad

Desde PowerShell en el Windows Server:

```powershell
# Comprobar ping
ping 172.31.16.133

# Comprobar puerto SMB
Test-NetConnection 172.31.16.133 -Port 445
```
