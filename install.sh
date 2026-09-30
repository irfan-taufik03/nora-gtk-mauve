#!/usr/bin/env bash

# Nora GTK Mauve Theme Installer

THEME_NAME="Nora-gtk-mauve"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="${SRC_DIR}/${THEME_NAME}"

# Color codes
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --system        Install theme system-wide to /usr/share/themes (requires root/sudo)"
    echo "  -d, --dest DIR      Specify custom destination directory (GTK theme only)"
    echo "  -p, --plasma        Also install KDE Plasma extras (color scheme, Kvantum theme, Aurorae decoration)"
    echo "  -r, --remove        Uninstall / remove the theme"
    echo "  -h, --help          Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Installs for current user to ~/.themes and ~/.local/share/themes"
    echo "  $0 -p               # Installs GTK theme + KDE Plasma extras for current user"
    echo "  sudo $0 -s          # Installs system-wide to /usr/share/themes"
    echo "  sudo $0 -s -p       # Installs system-wide incl. Plasma extras"
    echo "  $0 -r               # Uninstalls theme from user directory"
    echo "  $0 -r -p            # Uninstalls theme + Plasma extras"
}

DEST_DIR=""
SYSTEM_INSTALL=false
UNINSTALL=false
PLASMA=false

PLASMA_SRC="${SRC_DIR}/plasma"
PLASMA_NAME="NoraMauve"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--system)
            SYSTEM_INSTALL=true
            shift
            ;;
        -d|--dest)
            DEST_DIR="$2"
            shift 2
            ;;
        -p|--plasma)
            PLASMA=true
            shift
            ;;
        -r|--remove|--uninstall)
            UNINSTALL=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Check theme source folder exists
if [[ ! -d "${THEME_SRC}" ]]; then
    print_error "Source theme directory '${THEME_SRC}' not found!"
    exit 1
fi

# KDE Plasma extras: color scheme, Kvantum theme, Aurorae window decoration
install_plasma() {
    if [[ ! -d "${PLASMA_SRC}" ]]; then
        print_warn "Plasma extras not found in '${PLASMA_SRC}', skipping."
        return
    fi
    print_info "Installing KDE Plasma extras..."
    if [[ "${SYSTEM_INSTALL}" == true ]] || [[ "$EUID" -eq 0 ]]; then
        local cs_dest="/usr/share/color-schemes"
        local kv_dest="/usr/share/Kvantum"
        local au_dest="/usr/share/aurorae/themes"
    else
        local cs_dest="${HOME}/.local/share/color-schemes"
        local kv_dest="${HOME}/.config/Kvantum"
        local au_dest="${HOME}/.local/share/aurorae/themes"
    fi
    mkdir -p "${cs_dest}" "${kv_dest}" "${au_dest}"
    cp -f "${PLASMA_SRC}/color-schemes/${PLASMA_NAME}.colors" "${cs_dest}/"
    print_success "Color scheme -> ${cs_dest}/${PLASMA_NAME}.colors"
    rm -rf "${kv_dest}/${PLASMA_NAME}"
    cp -r "${PLASMA_SRC}/kvantum/${PLASMA_NAME}" "${kv_dest}/"
    print_success "Kvantum theme -> ${kv_dest}/${PLASMA_NAME}/"
    rm -rf "${au_dest}/${PLASMA_NAME}"
    cp -r "${PLASMA_SRC}/aurorae/${PLASMA_NAME}" "${au_dest}/"
    print_success "Aurorae decoration -> ${au_dest}/${PLASMA_NAME}/"
}

uninstall_plasma() {
    print_info "Uninstalling KDE Plasma extras..."
    if [[ "${SYSTEM_INSTALL}" == true ]] || [[ "$EUID" -eq 0 ]]; then
        local cs_dest="/usr/share/color-schemes"
        local kv_dest="/usr/share/Kvantum"
        local au_dest="/usr/share/aurorae/themes"
    else
        local cs_dest="${HOME}/.local/share/color-schemes"
        local kv_dest="${HOME}/.config/Kvantum"
        local au_dest="${HOME}/.local/share/aurorae/themes"
    fi
    rm -f "${cs_dest}/${PLASMA_NAME}.colors" && print_success "Removed ${cs_dest}/${PLASMA_NAME}.colors"
    rm -rf "${kv_dest}/${PLASMA_NAME}" && print_success "Removed ${kv_dest}/${PLASMA_NAME}/"
    rm -rf "${au_dest}/${PLASMA_NAME}" && print_success "Removed ${au_dest}/${PLASMA_NAME}/"
}

# Determine default destination directory
if [[ -z "${DEST_DIR}" ]]; then
    if [[ "${SYSTEM_INSTALL}" == true ]] || [[ "$EUID" -eq 0 ]]; then
        DEST_DIRS=("/usr/share/themes")
    else
        DEST_DIRS=("${HOME}/.themes" "${HOME}/.local/share/themes")
    fi
else
    DEST_DIRS=("${DEST_DIR}")
fi

if [[ "${UNINSTALL}" == true ]]; then
    print_info "Uninstalling ${THEME_NAME}..."
    for dir in "${DEST_DIRS[@]}"; do
        target="${dir}/${THEME_NAME}"
        if [[ -d "${target}" ]]; then
            rm -rf "${target}"
            print_success "Removed ${target}"
        else
            print_warn "Not found in ${dir}"
        fi
    done
    if [[ "${PLASMA}" == true ]]; then
        uninstall_plasma
    fi
    print_success "Uninstall completed."
    exit 0
fi

# Install
print_info "Installing ${THEME_NAME}..."
for dir in "${DEST_DIRS[@]}"; do
    mkdir -p "${dir}"
    target="${dir}/${THEME_NAME}"
    
    if [[ -d "${target}" ]]; then
        print_warn "Overwriting existing theme at ${target}..."
        rm -rf "${target}"
    fi

    cp -r "${THEME_SRC}" "${dir}/"
    print_success "Installed to ${target}"
done

echo ""
print_success "Theme installation finished successfully!"
echo -e "To apply the theme via command line (GNOME/GTK):"
echo -e "  ${YELLOW}gsettings set org.gnome.desktop.interface gtk-theme \"${THEME_NAME}\"${NC}"
echo -e "  ${YELLOW}gsettings set org.gnome.desktop.wm.preferences theme \"${THEME_NAME}\"${NC}"

if [[ "${PLASMA}" == true ]]; then
    install_plasma
    echo ""
    print_success "Plasma extras installed!"
    echo -e "Apply them in ${YELLOW}System Settings${NC}:"
    echo -e "  Appearance > Colors            -> ${YELLOW}Nora Mauve${NC}"
    echo -e "  Appearance > Application Style -> ${YELLOW}Kvantum${NC}, then Kvantum Manager -> ${YELLOW}NoraMauve${NC}"
    echo -e "  Appearance > Window Decorations -> ${YELLOW}NoraMauve${NC} (Aurorae)"
fi
