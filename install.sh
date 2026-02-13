#!/bin/bash

# daopctn_gui Installation Script
# Automated setup for Dracula-themed terminal environment

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║        daopctn_gui Installation Script               ║"
echo "║        Dracula Theme Terminal Setup                  ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to print colored messages
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup existing config
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

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems."
    exit 1
fi

print_info "Installation directory: $SCRIPT_DIR"
echo ""

# ============================================
# Step 1: Check Dependencies
# ============================================
echo -e "${PURPLE}═══ Step 1: Checking Dependencies ═══${NC}"
echo ""

MISSING_DEPS=()

# Check each dependency
dependencies=("git" "curl" "nvim" "btop" "cava" "neofetch")
for dep in "${dependencies[@]}"; do
    if command_exists "$dep"; then
        print_success "$dep is installed"
    else
        print_warning "$dep is NOT installed"
        MISSING_DEPS+=("$dep")
    fi
done

# Check for starship
if command_exists "starship"; then
    print_success "starship is installed"
else
    print_warning "starship is NOT installed"
    MISSING_DEPS+=("starship")
fi

# Check for ghostty
if command_exists "ghostty"; then
    print_success "ghostty is installed"
else
    print_warning "ghostty is NOT installed (optional)"
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
        # Detect package manager
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
            print_error "Could not detect package manager. Please install dependencies manually."
            exit 1
        fi

        print_info "Using package manager: $PKG_MANAGER"

        # Install packages (except starship which needs special handling)
        INSTALL_PKGS=()
        for dep in "${MISSING_DEPS[@]}"; do
            if [ "$dep" != "starship" ]; then
                # Map neovim to correct package name
                if [ "$dep" = "nvim" ]; then
                    INSTALL_PKGS+=("neovim")
                else
                    INSTALL_PKGS+=("$dep")
                fi
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
    else
        print_warning "Skipping dependency installation. Some features may not work."
    fi
else
    print_success "All dependencies are already installed!"
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
# Step 4: Backup Existing Configs
# ============================================
echo -e "${PURPLE}═══ Step 4: Backing Up Existing Configs ═══${NC}"
echo ""

configs_to_backup=("nvim" "ghostty" "btop" "cava" "neofetch" "starship.toml")
BACKUP_CREATED=false

for config in "${configs_to_backup[@]}"; do
    if backup_config "$config"; then
        BACKUP_CREATED=true
    fi
done

if [ "$BACKUP_CREATED" = true ]; then
    print_success "Backups saved to: $BACKUP_DIR"
else
    print_info "No existing configs found to backup"
fi

echo ""

# ============================================
# Step 5: Install Configs
# ============================================
echo -e "${PURPLE}═══ Step 5: Installing Configurations ═══${NC}"
echo ""

install_config() {
    local src="$SCRIPT_DIR/$1"
    local dest="$CONFIG_DIR/$1"
    local name="$1"

    if [ ! -e "$src" ]; then
        print_warning "Source not found: $src (skipping)"
        return
    fi

    if [[ $INSTALL_METHOD == "1" ]]; then
        # Symlink method
        ln -sf "$src" "$dest"
        print_success "Symlinked $name"
    else
        # Copy method
        cp -r "$src" "$dest"
        print_success "Copied $name"
    fi
}

# Install each config
install_config "nvim"
install_config "ghostty"
install_config "btop"
install_config "cava"
install_config "neofetch"
install_config "starship.toml"

echo ""

# ============================================
# Step 6: Install Nerd Fonts
# ============================================
echo -e "${PURPLE}═══ Step 6: Nerd Fonts Setup ═══${NC}"
echo ""

FONT_DIR="$HOME/.local/share/fonts"

print_info "This config requires Nerd Fonts: CaskaydiaCove"
echo ""
read -p "Would you like to install CaskaydiaCove Nerd Font? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installing CaskaydiaCove Nerd Font..."

    mkdir -p "$FONT_DIR"
    cd /tmp

    # Download and install CaskaydiaCove
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
    print_info "Downloading from: $FONT_URL"

    if curl -fLo CascadiaCode.zip "$FONT_URL"; then
        unzip -o CascadiaCode.zip -d "$FONT_DIR/CascadiaCode" >/dev/null 2>&1
        rm CascadiaCode.zip

        # Refresh font cache
        fc-cache -fv >/dev/null 2>&1
        print_success "CaskaydiaCove Nerd Font installed!"
    else
        print_error "Failed to download font. Please install manually from:"
        print_info "https://www.nerdfonts.com/font-downloads"
    fi

    cd "$SCRIPT_DIR"
else
    print_warning "Skipping font installation."
    print_info "You can install fonts manually from: https://www.nerdfonts.com/"
fi

echo ""

# ============================================
# Step 7: Setup Shell Integration
# ============================================
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

    # Check if already configured
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

# ============================================
# Step 8: Neovim Setup
# ============================================
echo -e "${PURPLE}═══ Step 8: Neovim Plugin Installation ═══${NC}"
echo ""

print_info "Neovim plugins will be installed automatically on first launch."
print_warning "NOTE: This config does NOT include:"
print_warning "  - Auto-completion (nvim-cmp)"
print_warning "  - Git file view (fugitive, diffview, etc.)"
echo ""

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

# ============================================
# Step 9: Final Notes
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║                Installation Complete! 🎉              ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════${NC}"
echo ""

print_success "Configuration installed successfully!"
echo ""
print_info "Next Steps:"
echo ""
echo "  1. Restart your terminal or run: source ~/.${SHELL_NAME}rc"
echo "  2. Launch ghostty terminal for the full experience"
echo "  3. Run 'neofetch' to see your system info"
echo "  4. Run 'btop' to monitor system resources"
echo "  5. Play music and run 'cava' for audio visualization"
echo ""

if [ "$BACKUP_CREATED" = true ]; then
    print_info "Your old configs are backed up at:"
    echo "  $BACKUP_DIR"
fi

echo ""
print_info "For customization help, see: $SCRIPT_DIR/README.md"
echo ""

echo -e "${PURPLE}Enjoy your new Dracula-themed terminal! 🧛${NC}"
echo ""
