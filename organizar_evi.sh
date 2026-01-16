#!/bin/bash

# Script para organizar automáticamente las evidencias del proyecto
# Autor: Administrador de Sistemas
# Descripción: Mueve las capturas de una carpeta única a la estructura organizada

echo "========================================================="
echo "  🗂️  ORGANIZADOR AUTOMÁTICO DE EVIDENCIAS"
echo "========================================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorios
SOURCE_DIR="evidencias"  # Carpeta con todas las evidencias juntas
BASE_DIR="evidencias"     # Directorio base donde crear estructura

# Verificar que existe el directorio de origen
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ Error: No existe el directorio '$SOURCE_DIR'${NC}"
    echo "Por favor, asegúrate de que tus capturas están en la carpeta 'evidencias/'"
    exit 1
fi

# Crear estructura de carpetas si no existe
echo -e "${BLUE}📁 Creando estructura de carpetas...${NC}"
echo ""

folders=(
    "01-instalacion"
    "02-configuracion"
    "03-usuarios-grupos"
    "04-clientes"
    "05-gpos"
    "06-recursos"
    "07-trusts"
    "08-auditoria"
)

for folder in "${folders[@]}"; do
    mkdir -p "$BASE_DIR/$folder"
done

echo -e "${GREEN}✓ Estructura de carpetas creada${NC}"
echo ""

# Contador de archivos movidos
moved_count=0
skipped_count=0

echo -e "${BLUE}🔄 Organizando evidencias...${NC}"
echo ""

# Función para mover archivo
move_file() {
    local file=$1
    local dest_folder=$2
    local reason=$3
    
    if [ -f "$SOURCE_DIR/$file" ]; then
        mv "$SOURCE_DIR/$file" "$BASE_DIR/$dest_folder/"
        echo -e "  ${GREEN}✓${NC} Movido: $file → $dest_folder/ ${YELLOW}($reason)${NC}"
        ((moved_count++))
    fi
}

# ==========================================
# 01-INSTALACION
# ==========================================
echo -e "${YELLOW}[01-instalacion]${NC}"
move_file "Instalacion Linux Vbox.png" "01-instalacion" "instalación VBox"
move_file "Configuracion discos.png" "01-instalacion" "configuración discos"
echo ""

# ==========================================
# 02-CONFIGURACION
# ==========================================
echo -e "${YELLOW}[02-configuracion]${NC}"
move_file "Cambiar-el-nombre-host.png" "02-configuracion" "hostname"
move_file "red_interna_cli.png" "02-configuracion" "red interna"
move_file "hosts_cli.png" "02-configuracion" "hosts"
move_file "resolv_cli.png" "02-configuracion" "resolv.conf"
move_file "etc-resolv.png" "02-configuracion" "resolv.conf"
move_file "hosts_final.png" "02-configuracion" "hosts final"
move_file "netplan_ls03trust.png" "02-configuracion" "netplan"
move_file "SAMBA-AD running.png" "02-configuracion" "Samba AD activo"
move_file "dns_query.png" "02-configuracion" "DNS query"
move_file "kerberos_tcp_lab03.png" "02-configuracion" "Kerberos SRV"
move_file "kinit.png" "02-configuracion" "Kerberos ticket"
move_file "kerb_realm_cli.png" "02-configuracion" "Kerberos realm"
move_file "krb.png" "02-configuracion" "Kerberos"
move_file "krb_serv_cli.png" "02-configuracion" "Kerberos server"
move_file "smbclient_show_net_folders.png" "02-configuracion" "smbclient"
echo ""

# ==========================================
# 03-USUARIOS-GRUPOS
# ==========================================
echo -e "${YELLOW}[03-usuarios-grupos]${NC}"
move_file "crear_usuarios.png" "03-usuarios-grupos" "creación usuarios"
move_file "crear_grupos.png" "03-usuarios-grupos" "creación grupos"
move_file "Creacion_OU.png" "03-usuarios-grupos" "creación OUs"
move_file "meter_usu_grupos.png" "03-usuarios-grupos" "usuarios en grupos"
move_file "mover_usu_OU.png" "03-usuarios-grupos" "mover usuarios a OUs"
echo ""

# ==========================================
# 04-CLIENTES
# ==========================================
echo -e "${YELLOW}[04-clientes]${NC}"
move_file "realm_discover.png" "04-clientes" "realm discover"
move_file "realm_join.png" "04-clientes" "realm join"
move_file "realm_list.png" "04-clientes" "realm list"
move_file "id_comprobacion.png" "04-clientes" "verificación id"
move_file "pam_sesion_grafica.png" "04-clientes" "sesión gráfica"
echo ""

# ==========================================
# 05-GPOS
# ==========================================
echo -e "${YELLOW}[05-gpos]${NC}"
move_file "admin_desde_cli.png" "05-gpos" "admin CLI"
move_file "command_reset_sysvol.png" "05-gpos" "reset sysvol"
move_file "gpmc.msc.png" "05-gpos" "GPMC"
move_file "habilitar_politca_rsat.png" "05-gpos" "política RSAT"
move_file "RSAT.png" "05-gpos" "RSAT"
move_file "RSAT_directivas.png" "05-gpos" "directivas RSAT"
move_file "link_gpo.png" "05-gpos" "vincular GPO"
move_file "studen_policy_in_server_show.png" "05-gpos" "policy en server"
move_file "student_policy_from_server.png" "05-gpos" "policy desde server"
move_file "denied_control panel.png" "05-gpos" "panel bloqueado"
echo ""

# ==========================================
# 06-RECURSOS
# ==========================================
echo -e "${YELLOW}[06-recursos]${NC}"
move_file "smb.conf.png" "06-recursos" "smb.conf"
move_file "Network_folders_windows.png" "06-recursos" "carpetas red Windows"
move_file "error_domain_users_group.png" "06-recursos" "error domain users"
echo ""

# ==========================================
# 07-TRUSTS
# ==========================================
echo -e "${YELLOW}[07-trusts]${NC}"
move_file "etc_hosts_trust.png" "07-trusts" "hosts trust"
move_file "krb_lab03trust.png" "07-trusts" "kerberos trust"
move_file "serv_adm_kerb_lab03trust.png" "07-trusts" "kerberos admin trust"
move_file "serv_kerb_lab03trust.png" "07-trusts" "kerberos server trust"
move_file "krb_serv2_cli.png" "07-trusts" "kerberos CLI"
move_file "forwarders_ls03.png" "07-trusts" "DNS forwarders"
move_file "output_interactive_trust.png" "07-trusts" "creación trust"
move_file "verif_samba_ad_cd_trust.png" "07-trusts" "verificación trust"
echo ""

# ==========================================
# 08-AUDITORIA
# ==========================================
echo -e "${YELLOW}[08-auditoria]${NC}"
move_file "prep_auditoria.png" "08-auditoria" "preparación auditoría"
move_file "smb_conf_audit.png" "08-auditoria" "smb.conf audit"
move_file "smb_audit_log.png" "08-auditoria" "logs auditoría"
move_file "backup.png" "08-auditoria" "backup"
move_file "htop.png" "08-auditoria" "htop"
move_file "ssh_cliente_bob.png" "08-auditoria" "SSH cliente"
move_file "top-bash.png" "08-auditoria" "top"
move_file "stop_sl.png" "08-auditoria" "stop proceso"
move_file "Captura de pantalla de 2025-12-12 09-38-35.png" "08-auditoria" "captura genérica"
echo ""

echo "========================================================="
echo -e "${GREEN}✅ Organización completada${NC}"
echo "========================================================="
echo ""
echo -e "📊 Resumen:"
echo -e "  ${GREEN}✓${NC} Archivos movidos: ${GREEN}$moved_count${NC}"
echo ""

# Listar archivos restantes en la carpeta original
remaining_files=$(find "$SOURCE_DIR" -maxdepth 1 -type f | wc -l)

if [ $remaining_files -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Atención:${NC} Hay $remaining_files archivo(s) que no fueron organizados:"
    echo ""
    find "$SOURCE_DIR" -maxdepth 1 -type f -exec basename {} \; | while read file; do
        echo -e "  ${YELLOW}•${NC} $file"
    done
    echo ""
    echo "Estos archivos pueden ser:"
    echo "  - Evidencias con nombres diferentes"
    echo "  - Archivos que deben ir en otra sección"
    echo "  - Archivos no relacionados con el proyecto"
    echo ""
    echo "Revisa estos archivos manualmente y muévelos a la carpeta correcta."
else
    echo -e "${GREEN}🎉 ¡Todas las evidencias han sido organizadas!${NC}"
fi

echo ""
echo "========================================================="
echo "  📂 Estructura final:"
echo "========================================================="
echo ""

for folder in "${folders[@]}"; do
    file_count=$(find "$BASE_DIR/$folder" -type f | wc -l)
    if [ $file_count -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} $folder/ (${file_count} archivo(s))"
    else
        echo -e "  ${RED}✗${NC} $folder/ (vacía)"
    fi
done

echo ""
echo "========================================================="
echo "  📝 Próximos pasos:"
echo "========================================================="
echo ""
echo "1. Revisa cada carpeta y verifica que las evidencias están correctas"
echo "2. Añade más capturas si faltan (consulta los README.md en cada carpeta)"
echo "3. Actualiza los checkboxes en cada README.md"
echo "4. Commit y push a GitHub:"
echo ""
echo "   git add evidencias/"
echo "   git commit -m 'docs: Organizar evidencias del proyecto'"
echo "   git push origin main"
echo ""
echo "¡Éxito! 🚀"
echo ""
