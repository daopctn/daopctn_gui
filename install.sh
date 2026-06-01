#!/bin/bash

# daopctn_gui Installation Script
# Automated setup for Manga Mono terminal environment
# Designed for Ubuntu and similar Debian-based Linux distributions

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
OFFLINE_DIR="$SCRIPT_DIR/offline"
NVIM_DATA="$HOME/.local/share/nvim"
HAS_INTERNET=""

# ============================================
# Component selection flags (default: off)
# ============================================
INSTALL_NVIM=false
INSTALL_GHOSTTY=false
INSTALL_BTOP=false
INSTALL_CAVA=false
INSTALL_NEOFETCH=false
INSTALL_STARSHIP=false
INSTALL_FONTS=false
INSTALL_GTK=false
INSTALL_TERMINATOR=false
INSTALL_CLANGD=false
INSTALL_VSCODE=false
INSTALL_ALL=false
REINSTALL=false
INTERACTIVE=true

# ============================================
# Usage / Help
# ============================================
show_usage() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║        daopctn_gui Installation Script               ║"
    echo "║        Manga Mono Terminal Setup                  ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all          Install everything"
    echo "  --reinstall    Clean reinstall — removes existing configs then installs everything"
    echo "  --nvim         Install Neovim config"
    echo "  --ghostty      Install Ghostty config"
    echo "  --btop         Install btop config"
    echo "  --cava         Install cava config"
    echo "  --neofetch     Install neofetch config"
    echo "  --starship     Install Starship prompt config"
    echo "  --gtk          Install GTK 3 manga-mono theme"
    echo "  --terminator   Install Terminator config"
    echo "  --clangd       Install clangd LSP config (GCC11 + Qt5)"
    echo "  --vscode       Install VS Code Manga Mono theme"
    echo "  --fonts        Install Nerd Fonts (CaskaydiaCove)"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./install.sh                     # Interactive mode - pick what you want"
    echo "  ./install.sh --all               # Install everything"
    echo "  ./install.sh --nvim --ghostty    # Only install Neovim and Ghostty configs"
    echo "  ./install.sh --starship --fonts  # Only install Starship config and fonts"
    echo ""
}

# ============================================
# Parse CLI arguments
# ============================================
while [[ $# -gt 0 ]]; do
    case "$1" in
        --reinstall)
            REINSTALL=true
            INSTALL_ALL=true
            INTERACTIVE=false
            shift
            ;;
        --all)
            INSTALL_ALL=true
            INTERACTIVE=false
            shift
            ;;
        --nvim)
            INSTALL_NVIM=true
            INTERACTIVE=false
            shift
            ;;
        --ghostty)
            INSTALL_GHOSTTY=true
            INTERACTIVE=false
            shift
            ;;
        --btop)
            INSTALL_BTOP=true
            INTERACTIVE=false
            shift
            ;;
        --cava)
            INSTALL_CAVA=true
            INTERACTIVE=false
            shift
            ;;
        --neofetch)
            INSTALL_NEOFETCH=true
            INTERACTIVE=false
            shift
            ;;
        --starship)
            INSTALL_STARSHIP=true
            INTERACTIVE=false
            shift
            ;;
        --fonts)
            INSTALL_FONTS=true
            INTERACTIVE=false
            shift
            ;;
        --gtk)
            INSTALL_GTK=true
            INTERACTIVE=false
            shift
            ;;
        --terminator)
            INSTALL_TERMINATOR=true
            INTERACTIVE=false
            shift
            ;;
        --clangd)
            INSTALL_CLANGD=true
            INTERACTIVE=false
            shift
            ;;
        --vscode)
            INSTALL_VSCODE=true
            INTERACTIVE=false
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Run './install.sh --help' for usage info."
            exit 1
            ;;
    esac
done

# If --all, enable everything
if [ "$INSTALL_ALL" = true ]; then
    INSTALL_NVIM=true
    INSTALL_GHOSTTY=true
    INSTALL_BTOP=true
    INSTALL_CAVA=true
    INSTALL_NEOFETCH=true
    INSTALL_STARSHIP=true
    INSTALL_FONTS=true
    INSTALL_GTK=true
    INSTALL_TERMINATOR=true
    INSTALL_CLANGD=true
    INSTALL_VSCODE=true
fi

# ============================================
# Print helpers
# ============================================
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_internet() {
    if [ -n "$HAS_INTERNET" ]; then
        [ "$HAS_INTERNET" = "yes" ]
        return
    fi
    if curl -s --connect-timeout 3 --max-time 5 https://github.com >/dev/null 2>&1; then
        HAS_INTERNET="yes"
        return 0
    else
        HAS_INTERNET="no"
        return 1
    fi
}

has_offline_file() {
    [ -f "$OFFLINE_DIR/$1" ]
}

backup_config() {
    local config_name=$1
    local config_path="$CONFIG_DIR/$config_name"

    if [ -e "$config_path" ]; then
        print_warning "Existing $config_name config found. Creating backup..."
        mkdir -p "$BACKUP_DIR"
        mv "$config_path" "$BACKUP_DIR/"
        print_success "Backed up to: $BACKUP_DIR/$config_name"
        return 0
    fi
    return 1
}

install_config() {
    local src="$SCRIPT_DIR/$1"
    local dest="$CONFIG_DIR/$1"
    local name="$1"

    if [ ! -e "$src" ]; then
        print_warning "Source not found: $src (skipping)"
        return
    fi

    # Remove existing dest to prevent cp nesting src inside dest
    rm -rf "$dest"
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    print_success "Copied $name"
}

# ============================================
# Neovim: install v0.11.6 from GitHub releases
# https://github.com/neovim/neovim/releases/tag/v0.11.6
# Installs to ~/.local/bin/nvim (no sudo needed)
# ============================================
install_nvim_from_release() {
    local version="0.11.6"
    local arch
    arch=$(uname -m)
    local nvim_file="nvim-linux-${arch}.tar.gz"
    local url="https://github.com/neovim/neovim/releases/download/v${version}/${nvim_file}"
    local tarball=""

    print_info "Installing Neovim v${version}..."

    # Try internet first, fall back to offline bundle
    if check_internet && curl -fLo /tmp/nvim.tar.gz "$url" 2>/dev/null; then
        tarball="/tmp/nvim.tar.gz"
        print_info "Downloaded from GitHub"
    elif has_offline_file "$nvim_file"; then
        tarball="$OFFLINE_DIR/$nvim_file"
        print_info "Using offline bundle"
    else
        print_error "Cannot download Neovim and no offline bundle found."
        print_error "Run bundle.sh first to create offline archives."
        return 1
    fi

    mkdir -p "$HOME/.local"
    tar -xf "$tarball" -C "$HOME/.local" --strip-components=1
    [ "$tarball" = "/tmp/nvim.tar.gz" ] && rm -f /tmp/nvim.tar.gz

    if [ -f "$HOME/.local/bin/nvim" ]; then
        print_success "Neovim v${version} installed to ~/.local/bin/nvim"
    else
        print_error "Neovim installation may have failed. Check output above."
    fi

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_warning "~/.local/bin is not in your PATH."
        print_info "Add this to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

# ============================================
# Check if running on Linux
# ============================================
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems."
    exit 1
fi

# ============================================
# Banner
# ============================================
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║        daopctn_gui Installation Script               ║"
echo "║        Manga Mono Terminal Setup                  ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Clean install: remove existing configs first
if [ "$REINSTALL" = true ]; then
    echo ""
    print_warning "REINSTALL will DELETE all existing configs: nvim, ghostty, btop, cava, neofetch, starship, terminator, clangd."
    print_warning "Backups are NOT created before removal."
    echo ""
    read -p "  Are you sure? This cannot be undone. (yes/n): " -r
    echo ""
    if [[ "$REPLY" != "yes" ]]; then
        print_info "Reinstall cancelled."
        exit 0
    fi
    print_info "Removing existing configs..."
    bash "$SCRIPT_DIR/uninstall.sh" --yes
    echo ""
fi

print_info "Installation directory: $SCRIPT_DIR"

if check_internet; then
    print_success "Internet connection detected"
else
    print_warning "No internet connection — will use offline bundle if available"
    if [ -d "$OFFLINE_DIR" ]; then
        print_info "Offline bundle found at: $OFFLINE_DIR"
    else
        print_warning "No offline bundle found. Run bundle.sh with internet first."
    fi
fi
echo ""

# ============================================
# Interactive selection menu (if no flags given)
# ============================================
if [ "$INTERACTIVE" = true ]; then
    echo -e "${PURPLE}═══ Select Components to Install ═══${NC}"
    echo ""
    read -p "  Install everything? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_NVIM=true; INSTALL_GHOSTTY=true; INSTALL_BTOP=true
        INSTALL_CAVA=true; INSTALL_NEOFETCH=true; INSTALL_STARSHIP=true
        INSTALL_GTK=true; INSTALL_TERMINATOR=true; INSTALL_CLANGD=true
        INSTALL_VSCODE=true; INSTALL_FONTS=true
    else
        echo "Select individually (y/n for each):"
        echo ""

        ask_install() {
            local name="$1"
            local desc="$2"
            read -p "  Install ${name} (${desc})? (y/n): " -n 1 -r
            echo ""
            [[ $REPLY =~ ^[Yy]$ ]]
        }

        if ask_install "nvim"        "Neovim editor config";          then INSTALL_NVIM=true;       fi
        if ask_install "ghostty"     "Ghostty terminal config";       then INSTALL_GHOSTTY=true;    fi
        if ask_install "btop"        "btop system monitor config";    then INSTALL_BTOP=true;       fi
        if ask_install "cava"        "cava audio visualizer config";  then INSTALL_CAVA=true;       fi
        if ask_install "neofetch"    "neofetch system info config";   then INSTALL_NEOFETCH=true;   fi
        if ask_install "starship"    "Starship prompt config";        then INSTALL_STARSHIP=true;   fi
        if ask_install "gtk"         "GTK 3 theme (manga-mono)";      then INSTALL_GTK=true;        fi
        if ask_install "terminator"  "Terminator config";             then INSTALL_TERMINATOR=true; fi
        if ask_install "clangd"      "clangd LSP config (GCC11+Qt5)"; then INSTALL_CLANGD=true;     fi
        if ask_install "vscode"      "VS Code Manga Mono theme";      then INSTALL_VSCODE=true;     fi
        if ask_install "fonts"       "CaskaydiaCove Nerd Font";       then INSTALL_FONTS=true;      fi
    fi

    echo ""

    if [ "$INSTALL_NVIM" = false ] && [ "$INSTALL_GHOSTTY" = false ] && \
       [ "$INSTALL_BTOP" = false ] && [ "$INSTALL_CAVA" = false ] && \
       [ "$INSTALL_NEOFETCH" = false ] && [ "$INSTALL_STARSHIP" = false ] && \
       [ "$INSTALL_GTK" = false ] && [ "$INSTALL_TERMINATOR" = false ] && \
       [ "$INSTALL_CLANGD" = false ] && \
       [ "$INSTALL_VSCODE" = false ] && \
       [ "$INSTALL_FONTS" = false ]; then
        print_error "Nothing selected. Exiting."
        exit 0
    fi
fi

# Show what will be installed
echo -e "${PURPLE}═══ Installation Summary ═══${NC}"
echo ""
[ "$INSTALL_NVIM" = true ]        && echo -e "  ${GREEN}[✓]${NC} Neovim"        || true
[ "$INSTALL_GHOSTTY" = true ]    && echo -e "  ${GREEN}[✓]${NC} Ghostty"       || true
[ "$INSTALL_BTOP" = true ]       && echo -e "  ${GREEN}[✓]${NC} btop"          || true
[ "$INSTALL_CAVA" = true ]       && echo -e "  ${GREEN}[✓]${NC} cava"          || true
[ "$INSTALL_NEOFETCH" = true ]   && echo -e "  ${GREEN}[✓]${NC} neofetch"      || true
[ "$INSTALL_STARSHIP" = true ]   && echo -e "  ${GREEN}[✓]${NC} Starship"      || true
[ "$INSTALL_GTK" = true ]        && echo -e "  ${GREEN}[✓]${NC} GTK 3"         || true
[ "$INSTALL_TERMINATOR" = true ] && echo -e "  ${GREEN}[✓]${NC} Terminator"    || true
[ "$INSTALL_CLANGD" = true ]     && echo -e "  ${GREEN}[✓]${NC} clangd config" || true
[ "$INSTALL_VSCODE" = true ]     && echo -e "  ${GREEN}[✓]${NC} VS Code theme" || true
[ "$INSTALL_FONTS" = true ]      && echo -e "  ${GREEN}[✓]${NC} Nerd Fonts"    || true
echo ""

if [ "$INTERACTIVE" = true ]; then
    read -p "Proceed with installation? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi
    echo ""
fi

# ============================================
# Step 1: Check Dependencies (only for selected components)
# ============================================
echo -e "${PURPLE}═══ Step 1: Checking Dependencies ═══${NC}"
echo ""

MISSING_DEPS=()

# curl is only needed if no offline bundle (for downloading)
if ! has_offline_file "nvim-linux-$(uname -m).tar.gz"; then
    if command_exists "curl"; then
        print_success "curl is installed"
    else
        print_warning "curl is NOT installed (needed to download files — run bundle.sh first for offline use)"
        MISSING_DEPS+=("curl")
    fi
fi

# Only check deps for selected components
if [ "$INSTALL_NVIM" = true ]; then
    if command_exists "nvim" && nvim --version 2>/dev/null | grep -q "v0\.11\.6"; then
        print_success "nvim v0.11.6 is installed"
    elif command_exists "nvim"; then
        print_warning "nvim is installed but not v0.11.6 — will upgrade"
        MISSING_DEPS+=("nvim")
    else
        print_warning "nvim is NOT installed"
        MISSING_DEPS+=("nvim")
    fi

    # npm is only needed to RUN npm-based LSP servers, not to install them
    if command_exists "npm"; then
        print_success "npm is installed"
    else
        print_warning "npm is NOT installed — npm-based LSP servers (pyright, ts_ls, bashls, jsonls, yamlls) won't run"
    fi
fi

if [ "$INSTALL_BTOP" = true ]; then
    if command_exists "btop"; then
        print_success "btop is installed"
    else
        print_warning "btop is NOT installed"
        MISSING_DEPS+=("btop")
    fi
fi

if [ "$INSTALL_CAVA" = true ]; then
    if command_exists "cava"; then
        print_success "cava is installed"
    else
        print_warning "cava is NOT installed"
        MISSING_DEPS+=("cava")
    fi
fi

if [ "$INSTALL_NEOFETCH" = true ]; then
    if command_exists "neofetch"; then
        print_success "neofetch is installed"
    else
        print_warning "neofetch is NOT installed"
        MISSING_DEPS+=("neofetch")
    fi
fi

if [ "$INSTALL_STARSHIP" = true ]; then
    if command_exists "starship"; then
        print_success "starship is installed"
    else
        print_warning "starship is NOT installed"
        MISSING_DEPS+=("starship")
    fi
fi

if [ "$INSTALL_GHOSTTY" = true ]; then
    if has_offline_file "ghostty.AppImage"; then
        print_info "ghostty AppImage found — will install from offline/ghostty.AppImage"
    else
        print_warning "offline/ghostty.AppImage not found — skipping Ghostty config"
        INSTALL_GHOSTTY=false
    fi
fi

echo ""

# ============================================
# Step 2: Install Missing Dependencies
# ============================================
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${PURPLE}═══ Step 2: Installing Missing Dependencies ═══${NC}"
    echo ""
    print_info "Missing dependencies: ${MISSING_DEPS[*]}"
    echo ""

    read -p "Would you like to install missing dependencies? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Detect package manager (designed for Ubuntu/Debian-based distros)
        if command_exists apt; then
            PKG_MANAGER="apt"
            INSTALL_CMD="sudo apt update && sudo apt install -y"
        elif command_exists dnf; then
            PKG_MANAGER="dnf"
            INSTALL_CMD="sudo dnf install -y"
        elif command_exists pacman; then
            PKG_MANAGER="pacman"
            INSTALL_CMD="sudo pacman -S --noconfirm"
        else
            print_error "Could not detect a supported package manager (apt, dnf, pacman)."
            print_info "This script is designed for Ubuntu and similar Debian-based distros."
            print_info "Please install the missing dependencies manually and re-run the script."
            exit 1
        fi

        print_info "Using package manager: $PKG_MANAGER"

        # Install packages (except starship and nvim which need special handling)
        INSTALL_PKGS=()
        for dep in "${MISSING_DEPS[@]}"; do
            if [ "$dep" != "starship" ] && [ "$dep" != "nvim" ]; then
                INSTALL_PKGS+=("$dep")
            fi
        done

        if [ ${#INSTALL_PKGS[@]} -gt 0 ]; then
            print_info "Installing: ${INSTALL_PKGS[*]}"
            eval "$INSTALL_CMD ${INSTALL_PKGS[*]}"
            print_success "Packages installed successfully"
        fi

        # Install starship separately
        if [[ " ${MISSING_DEPS[@]} " =~ " starship " ]]; then
            print_info "Installing starship..."
            if check_internet && curl -sS https://starship.rs/install.sh | sh -s -- -y; then
                print_success "Starship installed"
            elif has_offline_file "starship.tar.gz"; then
                print_info "Using offline bundle for starship..."
                tar -xzf "$OFFLINE_DIR/starship.tar.gz" -C /tmp/
                mkdir -p "$HOME/.local/bin"
                mv /tmp/starship "$HOME/.local/bin/starship"
                chmod +x "$HOME/.local/bin/starship"
                print_success "Starship installed from offline bundle to ~/.local/bin/starship"
            else
                print_error "Cannot download Starship and no offline bundle found."
            fi
        fi

        # Install nvim from GitHub releases
        if [[ " ${MISSING_DEPS[@]} " =~ " nvim " ]]; then
            install_nvim_from_release
        fi
    else
        print_warning "Skipping dependency installation. Some features may not work."
    fi
else
    print_success "All required dependencies are already installed!"
fi

echo ""

# ============================================
# Step 3: Backup Existing Configs (only selected)
# ============================================
echo -e "${PURPLE}═══ Step 3: Backing Up Existing Configs ═══${NC}"
echo ""

BACKUP_CREATED=false

if [ "$INSTALL_NVIM" = true ] && backup_config "nvim"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_GHOSTTY" = true ] && backup_config "ghostty"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_BTOP" = true ] && backup_config "btop"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_CAVA" = true ] && backup_config "cava"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_NEOFETCH" = true ] && backup_config "neofetch"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_STARSHIP" = true ] && backup_config "starship.toml"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_CLANGD" = true ] && backup_config "clangd"; then BACKUP_CREATED=true; fi

if [ "$BACKUP_CREATED" = true ]; then
    print_success "Backups saved to: $BACKUP_DIR"
else
    print_info "No existing configs found to backup"
fi

echo ""

# ============================================
# Step 4: Install Selected Configs
# ============================================
echo -e "${PURPLE}═══ Step 4: Installing Configurations ═══${NC}"
echo ""

[ "$INSTALL_NVIM" = true ]      && install_config "nvim" || true
if [ "$INSTALL_GHOSTTY" = true ]; then
    echo -e "${PURPLE}═══ Installing Ghostty AppImage ═══${NC}"
    echo ""

    # Remove snap version if present
    if snap list ghostty &>/dev/null 2>&1; then
        print_info "Removing Ghostty snap..."
        sudo snap remove ghostty
        print_success "Ghostty snap removed"
    fi

    mkdir -p "$HOME/.local/bin"
    cp "$OFFLINE_DIR/ghostty.AppImage" "$HOME/.local/bin/ghostty"
    chmod +x "$HOME/.local/bin/ghostty"

    if [ -x "$HOME/.local/bin/ghostty" ]; then
        print_success "Ghostty installed to ~/.local/bin/ghostty"
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            print_warning "~/.local/bin is not in your PATH."
            print_info "Add to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
    else
        print_error "Ghostty install failed — skipping config"
        INSTALL_GHOSTTY=false
    fi
    echo ""
fi
[ "$INSTALL_GHOSTTY" = true ]   && install_config "ghostty"     || true
[ "$INSTALL_BTOP" = true ]      && install_config "btop"         || true
[ "$INSTALL_CAVA" = true ]      && install_config "cava"         || true
[ "$INSTALL_NEOFETCH" = true ]  && install_config "neofetch"     || true
[ "$INSTALL_STARSHIP" = true ]  && install_config "starship.toml" || true
[ "$INSTALL_CLANGD" = true ]    && install_config "clangd"       || true

if [ "$INSTALL_VSCODE" = true ]; then
    VSCODE_EXT_DIR="$HOME/.vscode/extensions/manga-mono"
    mkdir -p "$VSCODE_EXT_DIR"
    cp -r "$SCRIPT_DIR/vscode/manga-mono/." "$VSCODE_EXT_DIR/"
    print_success "VS Code Manga Mono theme installed to ~/.vscode/extensions/manga-mono"
    print_info "In VS Code: Ctrl+Shift+P → 'Color Theme' → select 'Manga Mono'"
fi

if [ "$INSTALL_GTK" = true ]; then
    print_info "Installing GTK 3 manga-mono theme..."
    mkdir -p "$HOME/.themes/manga-mono/gtk-3.0"
    cp "$SCRIPT_DIR/gtk/gtk-3.0/gtk.css" "$HOME/.themes/manga-mono/gtk-3.0/gtk.css"
    if command_exists gsettings; then
        gsettings set org.gnome.desktop.interface gtk-theme manga-mono
        print_success "GTK theme set to manga-mono"
    else
        print_success "GTK theme copied — apply manually via gnome-tweaks or gsettings"
    fi
fi

if [ "$INSTALL_TERMINATOR" = true ]; then
    print_info "Installing Terminator config..."
    mkdir -p "$CONFIG_DIR/terminator"
    backup_config "terminator"
    cp "$SCRIPT_DIR/terminator/config" "$CONFIG_DIR/terminator/config"
    print_success "Terminator config installed"
fi

echo ""

# ============================================
# Step 5: Restore Offline Nvim Data (if no internet)
# ============================================
if [ "$INSTALL_NVIM" = true ] && has_offline_file "nvim-plugins.tar.gz"; then
    echo -e "${PURPLE}═══ Offline: Restoring Neovim Data ═══${NC}"
    echo ""

    mkdir -p "$NVIM_DATA"

    # Restore plugins
    if has_offline_file "nvim-plugins.tar.gz"; then
        print_info "Restoring nvim plugins from offline bundle..."
        tar -xzf "$OFFLINE_DIR/nvim-plugins.tar.gz" -C "$NVIM_DATA"
        print_success "Plugins restored to $NVIM_DATA/lazy/"
    else
        print_warning "No offline nvim-plugins.tar.gz found. Plugins won't be available until internet is restored."
    fi

    # Restore mason LSP servers
    if has_offline_file "mason-packages.tar.gz"; then
        print_info "Restoring mason LSP servers from offline bundle..."
        tar -xzf "$OFFLINE_DIR/mason-packages.tar.gz" -C "$NVIM_DATA"
        print_success "Mason packages restored to $NVIM_DATA/mason/"
    else
        print_warning "No offline mason-packages.tar.gz found. LSP servers won't be available until internet is restored."
    fi

    # Restore treesitter parsers
    if has_offline_file "treesitter-parsers.tar.gz"; then
        ts_parser_dir="$NVIM_DATA/site/parser"
        mkdir -p "$ts_parser_dir"
        print_info "Restoring treesitter parsers from offline bundle..."
        tar -xzf "$OFFLINE_DIR/treesitter-parsers.tar.gz" -C "$ts_parser_dir"
        print_success "Treesitter parsers restored"
    fi

    echo ""
fi

# ============================================
# Ghostty: set as default terminal
# ============================================
if [ "$INSTALL_GHOSTTY" = true ]; then
    echo -e "${PURPLE}═══ Ghostty: Setting as Default Terminal ═══${NC}"
    echo ""

    if command_exists gsettings; then
        gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
        gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
        print_success "Ghostty set as default terminal"
    else
        print_warning "gsettings not found — skipping default terminal setup"
        print_info "To set manually, run:"
        print_info "  gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'"
    fi

    # Create .desktop file for app launcher
    DESKTOP_DIR="$HOME/.local/share/applications"
    mkdir -p "$DESKTOP_DIR"
    cat > "$DESKTOP_DIR/ghostty.desktop" <<EOF
[Desktop Entry]
Name=Ghostty
Comment=Fast, feature-rich terminal emulator
Exec=$HOME/.local/bin/ghostty
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
StartupNotify=true
EOF
    chmod +x "$DESKTOP_DIR/ghostty.desktop"
    print_success "Ghostty added to app launcher"

    echo ""
fi

# ============================================
# Step 5: Install Nerd Fonts (if selected)
# ============================================
if [ "$INSTALL_FONTS" = true ]; then
    echo -e "${PURPLE}═══ Step 6: Nerd Fonts Setup ═══${NC}"
    echo ""

    FONT_DIR="$HOME/.local/share/fonts"

    print_info "Installing CaskaydiaCove Nerd Font..."

    mkdir -p "$FONT_DIR"
    cd /tmp

    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
    font_zip=""

    if check_internet && curl -fLo /tmp/CascadiaCode.zip "$FONT_URL" 2>/dev/null; then
        font_zip="/tmp/CascadiaCode.zip"
        print_info "Downloaded from GitHub"
    elif has_offline_file "CascadiaCode.zip"; then
        font_zip="$OFFLINE_DIR/CascadiaCode.zip"
        print_info "Using offline bundle"
    else
        print_error "Cannot download font and no offline bundle found."
        print_info "https://www.nerdfonts.com/font-downloads"
    fi

    if [ -n "$font_zip" ]; then
        unzip -o "$font_zip" -d "$FONT_DIR/CascadiaCode" >/dev/null 2>&1
        [ "$font_zip" = "/tmp/CascadiaCode.zip" ] && rm -f /tmp/CascadiaCode.zip
        fc-cache -fv >/dev/null 2>&1
        print_success "CaskaydiaCove Nerd Font installed!"
    fi

    cd "$SCRIPT_DIR"
    echo ""
fi

# ============================================
# Step 6: Setup Shell Integration (if starship selected)
# ============================================
if [ "$INSTALL_STARSHIP" = true ]; then
    echo -e "${PURPLE}═══ Step 7: Shell Integration (Starship) ═══${NC}"
    echo ""

    SHELL_NAME=$(basename "$SHELL")
    print_info "Detected shell: $SHELL_NAME"
    echo ""

    setup_starship() {
        local shell_config="$1"
        local init_line='eval "$(starship init '"$SHELL_NAME"')"'

        if [ ! -f "$shell_config" ]; then
            touch "$shell_config"
        fi

        if grep -q "starship init" "$shell_config"; then
            print_info "Starship already configured in $shell_config"
            return
        fi

        echo "" >> "$shell_config"
        echo "# Starship prompt (added by daopctn_gui installer)" >> "$shell_config"
        echo "$init_line" >> "$shell_config"
        print_success "Added starship to $shell_config"
    }

    if command_exists starship; then
        read -p "Configure starship for your shell? (y/n): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            case "$SHELL_NAME" in
                bash)
                    setup_starship "$HOME/.bashrc"
                    ;;
                zsh)
                    setup_starship "$HOME/.zshrc"
                    ;;
                fish)
                    print_info "For fish shell, add this to your config.fish:"
                    print_info "  starship init fish | source"
                    ;;
                *)
                    print_warning "Unknown shell: $SHELL_NAME"
                    print_info "Please configure starship manually"
                    ;;
            esac
        fi
    fi

    echo ""
fi

# ============================================
# Step 7: Neovim Setup (if nvim selected)
# ============================================
if [ "$INSTALL_NVIM" = true ]; then
    echo -e "${PURPLE}═══ Step 8: Neovim Plugin Installation ═══${NC}"
    echo ""

    print_info "Neovim plugins will be installed automatically on first launch."
    print_warning "NOTE: This config does NOT include:"
    print_warning "  - Git file view (fugitive, diffview, etc.)"
    echo ""

    if ! command_exists "npm"; then
        print_warning "npm is still not installed!"
        print_warning "Mason.nvim needs npm to install LSP servers (pyright, ts_ls, bashls, jsonls, yamlls)."
        print_info "Install npm with: sudo apt install npm"
        print_info "Or use nvm: https://github.com/nvm-sh/nvm"
        echo ""
    fi

    if has_offline_file "nvim-plugins.tar.gz" && [ -d "$NVIM_DATA/lazy" ]; then
        print_success "Plugins were restored from offline bundle. No need to download."
    else
        read -p "Would you like to open Neovim now to install plugins? (y/n): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Opening Neovim... Plugins will install automatically."
            print_info "After installation completes, type :q to exit"
            sleep 2
            nvim +Lazy
            print_success "Neovim setup complete!"
        else
            print_info "Plugins will install automatically the first time you run: nvim"
        fi
    fi

    echo ""
fi

# ============================================
# Done
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║                Installation Complete!                  ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════${NC}"
echo ""

print_success "Configuration installed successfully!"
echo ""
print_info "Next Steps:"
echo ""

SHELL_NAME=$(basename "$SHELL")
echo "  1. Restart your terminal or run: source ~/.${SHELL_NAME}rc"
[ "$INSTALL_GHOSTTY" = true ]  && echo "  2. Launch ghostty terminal for the full experience"
[ "$INSTALL_NEOFETCH" = true ] && echo "  3. Run 'neofetch' to see your system info"
[ "$INSTALL_BTOP" = true ]     && echo "  4. Run 'btop' to monitor system resources"
[ "$INSTALL_CAVA" = true ]     && echo "  5. Play music and run 'cava' for audio visualization"
echo ""

if [ "$BACKUP_CREATED" = true ]; then
    print_info "Your old configs are backed up at:"
    echo "  $BACKUP_DIR"
    echo ""
fi

print_info "For customization help, see: $SCRIPT_DIR/README.md"
echo ""

echo -e "${PURPLE}Enjoy your Manga Mono terminal!${NC}"
echo ""
