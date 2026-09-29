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
    echo "  -d, --dest DIR      Specify custom destination directory"
    echo "  -r, --remove        Uninstall / remove the theme"
    echo "  -h, --help          Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Installs for current user to ~/.themes and ~/.local/share/themes"
    echo "  sudo $0 -s          # Installs system-wide to /usr/share/themes"
    echo "  $0 -r               # Uninstalls theme from user directory"
}

DEST_DIR=""
SYSTEM_INSTALL=false
UNINSTALL=false

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
