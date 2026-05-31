#!/bin/bash

# daopctn_gui Uninstall Script
# Removes all installed configs, themes, and desktop entries

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m'

CONFIG_DIR="$HOME/.config"

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[-]${NC} $1"; }

remove_config() {
    local path="$1"
    local label="$2"
    if [ -e "$path" ] || [ -L "$path" ]; then
        rm -rf "$path"
        print_success "Removed $label"
    else
        print_warning "Not found: $label (skipping)"
    fi
}

echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║        daopctn_gui Uninstall Script                  ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "${1}" != "--yes" ]; then
    read -p "Remove all daopctn_gui configs? This cannot be undone. (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cancelled."
        exit 0
    fi
fi

echo ""
print_info "Removing configs..."
echo ""

remove_config "$CONFIG_DIR/nvim"           "nvim"
remove_config "$CONFIG_DIR/ghostty"        "ghostty"
remove_config "$CONFIG_DIR/btop"           "btop"
remove_config "$CONFIG_DIR/cava"           "cava"
remove_config "$CONFIG_DIR/neofetch"       "neofetch"
remove_config "$CONFIG_DIR/starship.toml"  "starship.toml"
remove_config "$CONFIG_DIR/terminator"     "terminator"
remove_config "$HOME/.themes/manga-mono"   "GTK manga-mono theme"
remove_config "$HOME/.local/share/applications/ghostty.desktop" "ghostty.desktop"

# Reset GTK theme to default if it was manga-mono
if command -v gsettings &>/dev/null; then
    current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
    if [ "$current_theme" = "manga-mono" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme Adwaita
        print_success "GTK theme reset to Adwaita"
    fi
fi

echo ""
print_success "Uninstall complete."
