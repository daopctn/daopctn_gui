#!/bin/bash

# daopctn_gui Installation Script
# Automated setup for Dracula-themed terminal environment
# Designed for Ubuntu and similar Debian-based Linux distributions

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

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
INSTALL_ALL=false
INTERACTIVE=true

# ============================================
# Usage / Help
# ============================================
show_usage() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║        daopctn_gui Installation Script               ║"
    echo "║        Dracula Theme Terminal Setup                  ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all          Install everything"
    echo "  --nvim         Install Neovim config"
    echo "  --ghostty      Install Ghostty config"
    echo "  --btop         Install btop config"
    echo "  --cava         Install cava config"
    echo "  --neofetch     Install neofetch config"
    echo "  --starship     Install Starship prompt config"
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

    if [[ $INSTALL_METHOD == "1" ]]; then
        ln -sf "$src" "$dest"
        print_success "Symlinked $name"
    else
        cp -r "$src" "$dest"
        print_success "Copied $name"
    fi
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
    local url="https://github.com/neovim/neovim/releases/download/v${version}/nvim-linux-${arch}.tar.gz"

    print_info "Installing Neovim v${version} from GitHub releases..."
    curl -fLo /tmp/nvim.tar.gz "$url"
    mkdir -p "$HOME/.local"
    tar -xf /tmp/nvim.tar.gz -C "$HOME/.local" --strip-components=1
    rm -f /tmp/nvim.tar.gz

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
echo "║        Dracula Theme Terminal Setup                  ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_info "Installation directory: $SCRIPT_DIR"
echo ""

# ============================================
# Interactive selection menu (if no flags given)
# ============================================
if [ "$INTERACTIVE" = true ]; then
    echo -e "${PURPLE}═══ Select Components to Install ═══${NC}"
    echo ""
    echo "For each component, press y to install or n to skip:"
    echo ""

    ask_install() {
        local name="$1"
        local desc="$2"
        read -p "  Install ${name} (${desc})? (y/n): " -n 1 -r
        echo ""
        [[ $REPLY =~ ^[Yy]$ ]]
    }

    ask_install "nvim"     "Neovim editor config"                   && INSTALL_NVIM=true
    ask_install "ghostty"  "Ghostty terminal config"                && INSTALL_GHOSTTY=true
    ask_install "btop"     "btop system monitor config"             && INSTALL_BTOP=true
    ask_install "cava"     "cava audio visualizer config"           && INSTALL_CAVA=true
    ask_install "neofetch" "neofetch system info config"            && INSTALL_NEOFETCH=true
    ask_install "starship" "Starship prompt config"                 && INSTALL_STARSHIP=true
    ask_install "fonts"    "CaskaydiaCove Nerd Font"                && INSTALL_FONTS=true

    echo ""

    # Check if anything was selected
    if [ "$INSTALL_NVIM" = false ] && [ "$INSTALL_GHOSTTY" = false ] && \
       [ "$INSTALL_BTOP" = false ] && [ "$INSTALL_CAVA" = false ] && \
       [ "$INSTALL_NEOFETCH" = false ] && [ "$INSTALL_STARSHIP" = false ] && \
       [ "$INSTALL_FONTS" = false ]; then
        print_error "Nothing selected. Exiting."
        exit 0
    fi
fi

# Show what will be installed
echo -e "${PURPLE}═══ Installation Summary ═══${NC}"
echo ""
[ "$INSTALL_NVIM" = true ]     && echo -e "  ${GREEN}[✓]${NC} Neovim"
[ "$INSTALL_GHOSTTY" = true ]  && echo -e "  ${GREEN}[✓]${NC} Ghostty"
[ "$INSTALL_BTOP" = true ]     && echo -e "  ${GREEN}[✓]${NC} btop"
[ "$INSTALL_CAVA" = true ]     && echo -e "  ${GREEN}[✓]${NC} cava"
[ "$INSTALL_NEOFETCH" = true ] && echo -e "  ${GREEN}[✓]${NC} neofetch"
[ "$INSTALL_STARSHIP" = true ] && echo -e "  ${GREEN}[✓]${NC} Starship"
[ "$INSTALL_FONTS" = true ]    && echo -e "  ${GREEN}[✓]${NC} Nerd Fonts"
echo ""

# ============================================
# Step 1: Check Dependencies (only for selected components)
# ============================================
echo -e "${PURPLE}═══ Step 1: Checking Dependencies ═══${NC}"
echo ""

MISSING_DEPS=()

# Always need git and curl
for dep in "git" "curl"; do
    if command_exists "$dep"; then
        print_success "$dep is installed"
    else
        print_warning "$dep is NOT installed"
        MISSING_DEPS+=("$dep")
    fi
done

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

    # npm is required by mason.nvim to install LSP servers
    # (pyright, ts_ls, bashls, jsonls, yamlls all need npm)
    if command_exists "npm"; then
        print_success "npm is installed (required by mason.nvim for LSP servers)"
    else
        print_warning "npm is NOT installed (required by mason.nvim for LSP servers)"
        MISSING_DEPS+=("npm")
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
    if command_exists "ghostty"; then
        print_success "ghostty is installed"
    else
        print_warning "ghostty is NOT installed — skipping Ghostty config"
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
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            print_success "Starship installed"
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
# Step 3: Choose Installation Method
# ============================================
echo -e "${PURPLE}═══ Step 3: Installation Method ═══${NC}"
echo ""
echo "Choose installation method:"
echo "  1) Symlinks (Recommended) - Changes to files in this repo will apply immediately"
echo "  2) Copy - Creates independent copies in ~/.config"
echo ""
read -p "Enter choice (1 or 2): " -n 1 -r INSTALL_METHOD
echo ""
echo ""

# ============================================
# Step 4: Backup Existing Configs (only selected)
# ============================================
echo -e "${PURPLE}═══ Step 4: Backing Up Existing Configs ═══${NC}"
echo ""

BACKUP_CREATED=false

if [ "$INSTALL_NVIM" = true ] && backup_config "nvim"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_GHOSTTY" = true ] && backup_config "ghostty"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_BTOP" = true ] && backup_config "btop"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_CAVA" = true ] && backup_config "cava"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_NEOFETCH" = true ] && backup_config "neofetch"; then BACKUP_CREATED=true; fi
if [ "$INSTALL_STARSHIP" = true ] && backup_config "starship.toml"; then BACKUP_CREATED=true; fi

if [ "$BACKUP_CREATED" = true ]; then
    print_success "Backups saved to: $BACKUP_DIR"
else
    print_info "No existing configs found to backup"
fi

echo ""

# ============================================
# Step 5: Install Selected Configs
# ============================================
echo -e "${PURPLE}═══ Step 5: Installing Configurations ═══${NC}"
echo ""

[ "$INSTALL_NVIM" = true ]     && install_config "nvim"
[ "$INSTALL_GHOSTTY" = true ]  && install_config "ghostty"
[ "$INSTALL_BTOP" = true ]     && install_config "btop"
[ "$INSTALL_CAVA" = true ]     && install_config "cava"
[ "$INSTALL_NEOFETCH" = true ] && install_config "neofetch"
[ "$INSTALL_STARSHIP" = true ] && install_config "starship.toml"

echo ""

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

    echo ""
fi

# ============================================
# Step 6: Install Nerd Fonts (if selected)
# ============================================
if [ "$INSTALL_FONTS" = true ]; then
    echo -e "${PURPLE}═══ Step 6: Nerd Fonts Setup ═══${NC}"
    echo ""

    FONT_DIR="$HOME/.local/share/fonts"

    print_info "Installing CaskaydiaCove Nerd Font..."

    mkdir -p "$FONT_DIR"
    cd /tmp

    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
    print_info "Downloading from: $FONT_URL"

    if curl -fLo CascadiaCode.zip "$FONT_URL"; then
        unzip -o CascadiaCode.zip -d "$FONT_DIR/CascadiaCode" >/dev/null 2>&1
        rm CascadiaCode.zip

        fc-cache -fv >/dev/null 2>&1
        print_success "CaskaydiaCove Nerd Font installed!"
    else
        print_error "Failed to download font. Please install manually from:"
        print_info "https://www.nerdfonts.com/font-downloads"
    fi

    cd "$SCRIPT_DIR"
    echo ""
fi

# ============================================
# Step 7: Setup Shell Integration (if starship selected)
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
# Step 8: Neovim Setup (if nvim selected)
# ============================================
if [ "$INSTALL_NVIM" = true ]; then
    echo -e "${PURPLE}═══ Step 8: Neovim Plugin Installation ═══${NC}"
    echo ""

    print_info "Neovim plugins will be installed automatically on first launch."
    print_warning "NOTE: This config does NOT include:"
    print_warning "  - Auto-completion (nvim-cmp)"
    print_warning "  - Git file view (fugitive, diffview, etc.)"
    echo ""

    if ! command_exists "npm"; then
        print_warning "npm is still not installed!"
        print_warning "Mason.nvim needs npm to install LSP servers (pyright, ts_ls, bashls, jsonls, yamlls)."
        print_info "Install npm with: sudo apt install npm"
        print_info "Or use nvm: https://github.com/nvm-sh/nvm"
        echo ""
    fi

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

echo -e "${PURPLE}Enjoy your new Dracula-themed terminal!${NC}"
echo ""
