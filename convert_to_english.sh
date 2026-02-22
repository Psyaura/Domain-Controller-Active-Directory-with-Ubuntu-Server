#!/bin/bash

###############################################################################
# Script: convert_to_english.sh
# Description: Converts the entire AD project repository to English
#              INCLUDING subfolders inside evidence/
# Author: System Administrator
# Date: 2025-02-22
# Version: 2.0
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d .git ]; then
    print_error "This is not a git repository. Please run this script from the repository root."
    exit 1
fi

# Check if we're in the correct directory
if [ ! -d "documentacion" ] && [ ! -d "evidencias" ]; then
    print_error "Required folders 'documentacion' or 'evidencias' not found."
    print_error "Please run this script from the repository root."
    exit 1
fi

print_status "Starting project conversion to English..."
echo ""

###############################################################################
# STEP 1: Create backup
###############################################################################

print_status "Step 1/8: Creating backup..."

BACKUP_DIR="backup_before_english_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup important files and folders
[ -f README.md ] && cp README.md "$BACKUP_DIR/"
[ -f README_ENGLISH.md ] && cp README_ENGLISH.md "$BACKUP_DIR/"
[ -d documentacion ] && cp -r documentacion "$BACKUP_DIR/" 2>/dev/null || true
[ -d evidencias ] && cp -r evidencias "$BACKUP_DIR/" 2>/dev/null || true

print_success "Backup created in: $BACKUP_DIR"
echo ""

###############################################################################
# STEP 2: Rename main folders
###############################################################################

print_status "Step 2/8: Renaming main folders..."

# Rename documentacion -> documentation
if [ -d "documentacion" ]; then
    git mv documentacion documentation
    print_success "documentacion/ → documentation/"
else
    print_warning "documentacion/ not found, skipping"
fi

# Rename evidencias -> evidence
if [ -d "evidencias" ]; then
    git mv evidencias evidence
    print_success "evidencias/ → evidence/"
else
    print_warning "evidencias/ not found, skipping"
fi

echo ""

###############################################################################
# STEP 2.5: Rename evidence subfolders
###############################################################################

print_status "Step 2.5/8: Renaming evidence subfolders..."

if [ -d "evidence" ]; then
    cd evidence
    
    # Rename subfolders to English
    [ -d "01-instalacion" ] && git mv "01-instalacion" "01-installation" && echo "  ✓ 01-instalacion/ → 01-installation/"
    [ -d "02-configuracion" ] && git mv "02-configuracion" "02-configuration" && echo "  ✓ 02-configuracion/ → 02-configuration/"
    [ -d "03-usuarios-grupos" ] && git mv "03-usuarios-grupos" "03-users-groups" && echo "  ✓ 03-usuarios-grupos/ → 03-users-groups/"
    [ -d "04-clientes" ] && git mv "04-clientes" "04-clients" && echo "  ✓ 04-clientes/ → 04-clients/"
    [ -d "05-gpos" ] && git mv "05-gpos" "05-gpos" && echo "  ✓ 05-gpos/ (no change)"
    [ -d "06-recursos" ] && git mv "06-recursos" "06-resources" && echo "  ✓ 06-recursos/ → 06-resources/"
    [ -d "07-trusts" ] && git mv "07-trusts" "07-trusts" && echo "  ✓ 07-trusts/ (no change)"
    [ -d "08-auditoria" ] && git mv "08-auditoria" "08-auditing" && echo "  ✓ 08-auditoria/ → 08-auditing/"
    
    cd ..
    print_success "Evidence subfolders renamed"
else
    print_warning "evidence/ folder not found"
fi

echo ""

###############################################################################
# STEP 3: Rename documentation MD files
###############################################################################

print_status "Step 3/8: Renaming documentation files..."

if [ -d "documentation" ]; then
    cd documentation
    
    # Rename MD files
    [ -f "01-instalacion-base.md" ] && git mv "01-instalacion-base.md" "01-Base-installation.md" && echo "  ✓ 01-Base-installation.md"
    [ -f "02-configuracion-red.md" ] && git mv "02-configuracion-red.md" "02-Network-configuration.md" && echo "  ✓ 02-Network-configuration.md"
    [ -f "03-samba-ad-dc.md" ] && git mv "03-samba-ad-dc.md" "03-Samba-AD-DC.md" && echo "  ✓ 03-Samba-AD-DC.md"
    [ -f "04-gestion-usuarios.md" ] && git mv "04-gestion-usuarios.md" "04-User-management.md" && echo "  ✓ 04-User-management.md"
    [ -f "05-union-clientes.md" ] && git mv "05-union-clientes.md" "05-Client-joining.md" && echo "  ✓ 05-Client-joining.md"
    [ -f "06-gpos.md" ] && git mv "06-gpos.md" "06-GPOs.md" && echo "  ✓ 06-GPOs.md"
    [ -f "07-recursos-compartidos.md" ] && git mv "07-recursos-compartidos.md" "07-Shared-resources.md" && echo "  ✓ 07-Shared-resources.md"
    [ -f "08-trusts.md" ] && git mv "08-trusts.md" "08-Domain-trusts.md" && echo "  ✓ 08-Domain-trusts.md"
    [ -f "09-auditoria.md" ] && git mv "09-auditoria.md" "09-Auditing.md" && echo "  ✓ 09-Auditing.md"
    [ -f "10-automatizacion.md" ] && git mv "10-automatizacion.md" "10-Automation.md" && echo "  ✓ 10-Automation.md"
    
    cd ..
    print_success "Documentation files renamed"
else
    print_warning "documentation/ folder not found"
fi

echo ""

###############################################################################
# STEP 4: Rename README files
###############################################################################

print_status "Step 4/8: Managing README files..."

if [ -f "README_ENGLISH.md" ]; then
    # Save Spanish version
    if [ -f "README.md" ]; then
        git mv README.md README_ES.md
        print_success "README.md → README_ES.md (Spanish version saved)"
    fi
    
    # Make English version the main README
    git mv README_ENGLISH.md README.md
    print_success "README_ENGLISH.md → README.md (English is now main)"
else
    print_warning "README_ENGLISH.md not found"
    if [ -f "README.md" ]; then
        git mv README.md README_ES.md
        print_success "README.md → README_ES.md"
    fi
fi

echo ""

###############################################################################
# STEP 5: Update all internal links in documentation files
###############################################################################

print_status "Step 5/8: Updating links in documentation files..."

if [ -d "documentation" ]; then
    for file in documentation/*.md; do
        if [ -f "$file" ]; then
            # Update folder references
            sed -i 's/documentacion\//documentation\//g' "$file"
            sed -i 's/evidencias\//evidence\//g' "$file"
            
            # Update evidence subfolder references
            sed -i 's/\/01-instalacion\//\/01-installation\//g' "$file"
            sed -i 's/\/02-configuracion\//\/02-configuration\//g' "$file"
            sed -i 's/\/03-usuarios-grupos\//\/03-users-groups\//g' "$file"
            sed -i 's/\/04-clientes\//\/04-clients\//g' "$file"
            sed -i 's/\/06-recursos\//\/06-resources\//g' "$file"
            sed -i 's/\/08-auditoria\//\/08-auditing\//g' "$file"
            
            # Update file references in navigation links
            sed -i 's/01-instalacion-base\.md/01-Base-installation.md/g' "$file"
            sed -i 's/02-configuracion-red\.md/02-Network-configuration.md/g' "$file"
            sed -i 's/03-samba-ad-dc\.md/03-Samba-AD-DC.md/g' "$file"
            sed -i 's/04-gestion-usuarios\.md/04-User-management.md/g' "$file"
            sed -i 's/05-union-clientes\.md/05-Client-joining.md/g' "$file"
            sed -i 's/06-gpos\.md/06-GPOs.md/g' "$file"
            sed -i 's/07-recursos-compartidos\.md/07-Shared-resources.md/g' "$file"
            sed -i 's/08-trusts\.md/08-Domain-trusts.md/g' "$file"
            sed -i 's/09-auditoria\.md/09-Auditing.md/g' "$file"
            sed -i 's/10-automatizacion\.md/10-Automation.md/g' "$file"
            
            echo "  ✓ Updated: $(basename "$file")"
        fi
    done
    print_success "Documentation links updated"
else
    print_warning "documentation/ folder not found"
fi

echo ""

###############################################################################
# STEP 6: Update README.md main file
###############################################################################

print_status "Step 6/8: Updating main README.md..."

if [ -f "README.md" ]; then
    # Update folder references
    sed -i 's/documentacion\//documentation\//g' README.md
    sed -i 's/evidencias\//evidence\//g' README.md
    
    # Update evidence subfolder references
    sed -i 's/\/01-instalacion\//\/01-installation\//g' README.md
    sed -i 's/\/02-configuracion\//\/02-configuration\//g' README.md
    sed -i 's/\/03-usuarios-grupos\//\/03-users-groups\//g' README.md
    sed -i 's/\/04-clientes\//\/04-clients\//g' README.md
    sed -i 's/\/06-recursos\//\/06-resources\//g' README.md
    sed -i 's/\/08-auditoria\//\/08-auditing\//g' README.md
    
    # Update file references
    sed -i 's/01-instalacion-base\.md/01-Base-installation.md/g' README.md
    sed -i 's/02-configuracion-red\.md/02-Network-configuration.md/g' README.md
    sed -i 's/03-samba-ad-dc\.md/03-Samba-AD-DC.md/g' README.md
    sed -i 's/04-gestion-usuarios\.md/04-User-management.md/g' README.md
    sed -i 's/05-union-clientes\.md/05-Client-joining.md/g' README.md
    sed -i 's/06-gpos\.md/06-GPOs.md/g' README.md
    sed -i 's/07-recursos-compartidos\.md/07-Shared-resources.md/g' README.md
    sed -i 's/08-trusts\.md/08-Domain-trusts.md/g' README.md
    sed -i 's/09-auditoria\.md/09-Auditing.md/g' README.md
    sed -i 's/10-automatizacion\.md/10-Automation.md/g' README.md
    
    print_success "README.md links updated"
else
    print_warning "README.md not found"
fi

echo ""

###############################################################################
# STEP 7: Update README_ES.md (Spanish version)
###############################################################################

print_status "Step 7/8: Updating README_ES.md (Spanish version)..."

if [ -f "README_ES.md" ]; then
    # Update folder references even in Spanish version (folders are now in English)
    sed -i 's/documentacion\//documentation\//g' README_ES.md
    sed -i 's/evidencias\//evidence\//g' README_ES.md
    
    # Update evidence subfolder references
    sed -i 's/\/01-instalacion\//\/01-installation\//g' README_ES.md
    sed -i 's/\/02-configuracion\//\/02-configuration\//g' README_ES.md
    sed -i 's/\/03-usuarios-grupos\//\/03-users-groups\//g' README_ES.md
    sed -i 's/\/04-clientes\//\/04-clients\//g' README_ES.md
    sed -i 's/\/06-recursos\//\/06-resources\//g' README_ES.md
    sed -i 's/\/08-auditoria\//\/08-auditing\//g' README_ES.md
    
    print_success "README_ES.md links updated"
else
    print_warning "README_ES.md not found"
fi

echo ""

###############################################################################
# STEP 8: Update scripts
###############################################################################

print_status "Step 8/8: Updating scripts..."

# Update any shell scripts that reference the old folder names
for script in *.sh scripts/*.sh 2>/dev/null; do
    if [ -f "$script" ]; then
        # Update folder references
        sed -i 's/documentacion\//documentation\//g' "$script"
        sed -i 's/evidencias\//evidence\//g' "$script"
        
        # Update evidence subfolder references
        sed -i 's/\/01-instalacion\//\/01-installation\//g' "$script"
        sed -i 's/\/02-configuracion\//\/02-configuration\//g' "$script"
        sed -i 's/\/03-usuarios-grupos\//\/03-users-groups\//g' "$script"
        sed -i 's/\/04-clientes\//\/04-clients\//g' "$script"
        sed -i 's/\/06-recursos\//\/06-resources\//g' "$script"
        sed -i 's/\/08-auditoria\//\/08-auditing\//g' "$script"
        
        echo "  ✓ Updated: $script"
    fi
done

print_success "Scripts updated"
echo ""

###############################################################################
# FINAL SUMMARY
###############################################################################

echo ""
echo "=========================================================================="
print_success "PROJECT CONVERSION TO ENGLISH COMPLETED!"
echo "=========================================================================="
echo ""
echo "📋 Summary of changes:"
echo ""
echo "  📁 Main folders renamed:"
echo "     • documentacion/ → documentation/"
echo "     • evidencias/ → evidence/"
echo ""
echo "  📂 Evidence subfolders renamed:"
echo "     • 01-instalacion/ → 01-installation/"
echo "     • 02-configuracion/ → 02-configuration/"
echo "     • 03-usuarios-grupos/ → 03-users-groups/"
echo "     • 04-clientes/ → 04-clients/"
echo "     • 05-gpos/ (no change)"
echo "     • 06-recursos/ → 06-resources/"
echo "     • 07-trusts/ (no change)"
echo "     • 08-auditoria/ → 08-auditing/"
echo ""
echo "  📄 Documentation files renamed:"
echo "     • 01-instalacion-base.md → 01-Base-installation.md"
echo "     • 02-configuracion-red.md → 02-Network-configuration.md"
echo "     • 03-samba-ad-dc.md → 03-Samba-AD-DC.md"
echo "     • 04-gestion-usuarios.md → 04-User-management.md"
echo "     • 05-union-clientes.md → 05-Client-joining.md"
echo "     • 06-gpos.md → 06-GPOs.md"
echo "     • 07-recursos-compartidos.md → 07-Shared-resources.md"
echo "     • 08-trusts.md → 08-Domain-trusts.md"
echo "     • 09-auditoria.md → 09-Auditing.md"
echo "     • 10-automatizacion.md → 10-Automation.md"
echo ""
echo "  📖 README files:"
echo "     • README.md → README_ES.md (Spanish)"
echo "     • README_ENGLISH.md → README.md (English - now main)"
echo ""
echo "  🔗 Links updated in:"
echo "     • All documentation/*.md files"
echo "     • README.md (English)"
echo "     • README_ES.md (Spanish)"
echo "     • All scripts/*.sh files"
echo ""
echo "  💾 Backup saved in:"
echo "     • $BACKUP_DIR/"
echo ""
echo "=========================================================================="
echo ""
print_status "Next steps:"
echo ""
echo "  1. Review changes:"
echo "     ${YELLOW}git status${NC}"
echo "     ${YELLOW}git diff${NC}"
echo ""
echo "  2. Test the repository:"
echo "     • Check README.md renders correctly"
echo "     • Verify all links work"
echo "     • Test navigation between docs"
echo "     • Check evidence folder structure"
echo ""
echo "  3. Commit changes:"
echo "     ${YELLOW}git add .${NC}"
echo "     ${YELLOW}git commit -m \"refactor: convert entire project to English including subfolders\"${NC}"
echo ""
echo "  4. Push to GitHub:"
echo "     ${YELLOW}git push origin main${NC}"
echo ""
echo "=========================================================================="
echo ""
print_warning "If anything goes wrong, restore from backup:"
echo "  ${YELLOW}cp -r $BACKUP_DIR/* ./${NC}"
echo ""
print_success "Script completed successfully! ✨"