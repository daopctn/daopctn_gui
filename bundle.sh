#!/bin/bash

# bundle.sh — Create offline archives for daopctn_gui
# Run this ONCE on a machine with internet and a working nvim setup.
# The offline/ directory can then be used by install.sh when there's no internet.

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OFFLINE_DIR="$SCRIPT_DIR/offline"
NVIM_DATA="$HOME/.local/share/nvim"

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================
# Banner
# ============================================
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║        daopctn_gui Offline Bundle Creator            ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================
# Prerequisites check
# ============================================
echo -e "${PURPLE}═══ Checking Prerequisites ═══${NC}"
echo ""

MISSING=false

if ! command -v git &>/dev/null; then
    print_error "git is required"
    MISSING=true
fi

if ! command -v curl &>/dev/null; then
    print_error "curl is required"
    MISSING=true
fi

if [ "$MISSING" = true ]; then
    exit 1
fi

print_success "All prerequisites met"
echo ""

# ============================================
# Prepare offline directory
# ============================================
mkdir -p "$OFFLINE_DIR"
ARCH=$(uname -m)

# ============================================
# 1. Bundle nvim plugins (from installed lazy directory)
# ============================================
echo -e "${PURPLE}═══ 1/6: Bundling Neovim Plugins ═══${NC}"
echo ""

if [ -d "$NVIM_DATA/lazy" ]; then
    print_info "Bundling installed plugins from $NVIM_DATA/lazy/..."
    tar -czf "$OFFLINE_DIR/nvim-plugins.tar.gz" -C "$NVIM_DATA" lazy/
    PLUGIN_SIZE=$(du -sh "$OFFLINE_DIR/nvim-plugins.tar.gz" | cut -f1)
    print_success "Plugins bundled ($PLUGIN_SIZE)"
else
    print_error "No installed plugins found at $NVIM_DATA/lazy/"
    print_error "Please run nvim first to install plugins, then re-run this script."
    exit 1
fi

echo ""

# ============================================
# 2. Bundle mason LSP servers
# ============================================
echo -e "${PURPLE}═══ 2/6: Bundling Mason LSP Servers ═══${NC}"
echo ""

MASON_DIR="$NVIM_DATA/mason"

if [ -d "$MASON_DIR" ]; then
    print_info "Bundling mason packages from $MASON_DIR/..."
    tar -czf "$OFFLINE_DIR/mason-packages.tar.gz" -C "$NVIM_DATA" mason/
    MASON_SIZE=$(du -sh "$OFFLINE_DIR/mason-packages.tar.gz" | cut -f1)
    print_success "Mason packages bundled ($MASON_SIZE)"
else
    print_warning "No mason directory found at $MASON_DIR"
    print_warning "Mason LSP servers will not be available offline."
    print_warning "To include them: open nvim, wait for mason to install servers, then re-run this script."
fi

echo ""

# ============================================
# 3. Bundle treesitter parsers
# ============================================
echo -e "${PURPLE}═══ 3/6: Bundling Treesitter Parsers ═══${NC}"
echo ""

TS_PARSER_DIR="$NVIM_DATA/lazy/nvim-treesitter/parser"

if [ -d "$TS_PARSER_DIR" ]; then
    PARSER_COUNT=$(find "$TS_PARSER_DIR" -name "*.so" | wc -l)
    print_info "Found $PARSER_COUNT compiled parsers"
    tar -czf "$OFFLINE_DIR/treesitter-parsers.tar.gz" -C "$TS_PARSER_DIR" .
    TS_SIZE=$(du -sh "$OFFLINE_DIR/treesitter-parsers.tar.gz" | cut -f1)
    print_success "Treesitter parsers bundled ($TS_SIZE)"
else
    print_warning "No treesitter parsers found at $TS_PARSER_DIR"
    print_warning "To include them: open nvim, wait for treesitter to compile parsers, then re-run this script."
fi

echo ""

# ============================================
# 4. Download Neovim binary
# ============================================
echo -e "${PURPLE}═══ 4/6: Downloading Neovim Binary ═══${NC}"
echo ""

NVIM_VERSION="0.11.6"
NVIM_FILE="nvim-linux-${ARCH}.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${NVIM_FILE}"

print_info "Downloading Neovim v${NVIM_VERSION} for ${ARCH}..."

if curl -fLo "$OFFLINE_DIR/$NVIM_FILE" "$NVIM_URL"; then
    NVIM_SIZE=$(du -sh "$OFFLINE_DIR/$NVIM_FILE" | cut -f1)
    print_success "Neovim binary downloaded ($NVIM_SIZE)"
else
    print_error "Failed to download Neovim binary"
fi

echo ""

# ============================================
# 5. Download Starship binary
# ============================================
echo -e "${PURPLE}═══ 5/6: Downloading Starship ═══${NC}"
echo ""

# Map arch names
STARSHIP_ARCH="$ARCH"
if [ "$ARCH" = "x86_64" ]; then
    STARSHIP_ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    STARSHIP_ARCH="aarch64"
fi

STARSHIP_URL="https://github.com/starship/starship/releases/latest/download/starship-${STARSHIP_ARCH}-unknown-linux-musl.tar.gz"

print_info "Downloading Starship for ${STARSHIP_ARCH}..."

if curl -fLo "$OFFLINE_DIR/starship.tar.gz" "$STARSHIP_URL"; then
    STARSHIP_SIZE=$(du -sh "$OFFLINE_DIR/starship.tar.gz" | cut -f1)
    print_success "Starship downloaded ($STARSHIP_SIZE)"
else
    print_error "Failed to download Starship"
fi

echo ""

# ============================================
# 6. Download Nerd Fonts
# ============================================
echo -e "${PURPLE}═══ 6/6: Downloading Nerd Fonts ═══${NC}"
echo ""

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"

print_info "Downloading CaskaydiaCove Nerd Font..."

if curl -fLo "$OFFLINE_DIR/CascadiaCode.zip" "$FONT_URL"; then
    FONT_SIZE=$(du -sh "$OFFLINE_DIR/CascadiaCode.zip" | cut -f1)
    print_success "Nerd Font downloaded ($FONT_SIZE)"
else
    print_error "Failed to download Nerd Font"
fi

echo ""

# ============================================
# Summary
# ============================================
echo -e "${PURPLE}═══════════════════════════════════════════════════════╗"
echo "║              Bundle Complete!                         ║"
echo "╚═══════════════════════════════════════════════════════${NC}"
echo ""

print_info "Offline bundle contents:"
echo ""

TOTAL_SIZE=$(du -sh "$OFFLINE_DIR" | cut -f1)

for f in "$OFFLINE_DIR"/*; do
    if [ -f "$f" ]; then
        fname=$(basename "$f")
        fsize=$(du -sh "$f" | cut -f1)
        echo -e "  ${GREEN}✓${NC} $fname ($fsize)"
    fi
done

echo ""
print_info "Total bundle size: $TOTAL_SIZE"
print_info "Architecture: $ARCH"
echo ""
print_success "The offline/ directory is ready."
print_info "install.sh will automatically use these files when internet is unavailable."
echo ""
