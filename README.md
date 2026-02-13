# daopctn_gui - Personal Configuration Collection

A unified collection of personal GUI and terminal configurations with a consistent **Dracula theme** aesthetic. This setup provides a beautiful, cohesive development environment focused on terminal-based workflows.

## 🚀 Quick Start (TL;DR)

```bash
cd daopctn_gui
./install.sh
```

That's it! The installer handles everything. **Setup time: ~5 minutes** ⭐

---

## 🎯 Is This Easy to Set Up?

**YES!** This configuration is designed to be **beginner-friendly**:

| Method | Difficulty | Time | Why? |
|--------|-----------|------|------|
| **Automated (install.sh)** | ⭐ Easy | 5 min | Script does everything for you |
| **Manual Setup** | ⭐⭐ Medium | 15-20 min | Follow step-by-step commands |

**What makes it easy:**
- ✅ **One-command installer** - Automated script handles all complexity
- ✅ **Auto-downloads plugins** - Neovim fetches everything on first run
- ✅ **Auto-installs dependencies** - Script detects and offers to install missing packages
- ✅ **Auto-backups** - Your old configs are saved before changes
- ✅ **No manual compilation** - All apps available via package manager
- ✅ **Clear documentation** - Step-by-step instructions for everything

**Potential challenges:**
- ⚠️ Ghostty might need manual installation (not in all package repos yet)
- ⚠️ First Neovim launch takes 2-3 minutes (downloading plugins)
- ⚠️ Fonts require ~100MB download (automated by installer)

**Bottom line**: If you can run `./install.sh`, you can set this up successfully.

---

## 🎨 What This Config Is All About

This configuration collection is designed for developers who prefer a **modern, terminal-centric workflow** with consistent theming across all tools. The setup emphasizes:

- **Visual Consistency**: Dracula color scheme throughout all applications
- **Terminal Power**: Advanced terminal features with split panes and custom keybindings
- **Minimal & Efficient**: Lightweight configs without bloat
- **Vim Philosophy**: Keyboard-driven navigation where possible
- **Beautiful Aesthetics**: Custom cursors, gradients, and visual effects

## 📁 Contents

### 👻 Ghostty Terminal (`ghostty/`)

**What it does**: Your primary terminal emulator with modern GPU-accelerated rendering.

**Key Features**:
- **Theme**: Dracula color scheme
- **Font**: CaskaydiaCove Nerd Font (11pt) for icon support
- **Custom Background**: Stretches a custom wallpaper at 1% opacity for subtle texture
- **Fullscreen by default**: Launches maximized for immersive experience
- **Custom Cursor**: Purple blinking cursor with GLSL shader for smooth smear effect
- **Terminator-style Splits**: Industry-standard keybindings for terminal multiplexing
  - `Ctrl+Shift+O` - Split horizontally
  - `Ctrl+Shift+E` - Split vertically
  - `Ctrl+Shift+Arrow` - Navigate between splits
  - `Alt+Arrow` - Resize splits
  - `Ctrl+Shift+X` - Toggle zoom on current pane

**Why this config**: Ghostty is modern, fast, and supports advanced features like custom shaders. This config makes it behave like Terminator (familiar to many Linux users) while adding aesthetic improvements.

### ✏️ Neovim (`nvim/`)

**What it does**: A minimal, fast Neovim setup for code editing.

**Key Features**:
- **Plugin Manager**: lazy.nvim for fast startup
- **Theme**: Dracula (dracula.lua)
- **UI Enhancements**:
  - Alpha (alpha.lua) - Beautiful start screen
  - Lualine (lualine.lua) - Statusline with git/mode info
  - Neo-tree (neo-tree.lua) - File explorer sidebar
  - Indent Blankline - Visual indent guides
  - Noice (noice.lua) - Enhanced UI for messages/cmdline
- **Editor Features**:
  - Telescope (telescope.lua) - Fuzzy finder for files/text
  - Treesitter (treesitter.lua) - Better syntax highlighting
  - LSP Config (lsp-config.lua) - Language server support
  - None-ls (none-ls.lua) - Formatting and linting
  - Smear Cursor (smear_cursor.lua) - Smooth cursor animation
- **Settings**:
  - 2-space indentation
  - Line numbers (no relative numbers)
  - Space as leader key
  - Auto-read file changes

**⚠️ Important Notes**:
- **NO auto-complete included**: This config does NOT include completion engines like nvim-cmp. You'll need to add this separately if desired.
- **NO git file view included**: No git diff viewer or git blame plugins. Basic git integration through lualine statusline only.
- **Minimal setup**: Focused on essential editing features without overwhelming beginners.

**Why this config**: Clean, fast Neovim setup that gets out of your way. Uses modern Lua configuration instead of VimScript. Great starting point to build upon.

### 📊 Btop (`btop/`)

**What it does**: A beautiful system resource monitor (CPU, memory, network, processes).

**Key Features**:
- **Theme**: Dracula
- **Vim Keybindings**: Navigate with h/j/k/l
- **Braille Graphs**: Highest resolution graphs for detailed monitoring
- **Transparent Background**: Blends with terminal background
- **Rounded Corners**: Modern aesthetic

**Why this config**: Btop is like `htop` but prettier. Perfect for monitoring system resources while matching your terminal aesthetic.

### 🎵 Cava (`cava/`)

**What it does**: Audio visualizer that shows sound frequency spectrum in your terminal.

**Key Features**:
- **Dracula Gradient**: 6-color gradient (cyan → purple → pink → orange → yellow → green)
- **Responsive**: Real-time audio visualization

**Why this config**: Add visual flair when playing music. Great for screenshots and rice setups.

### 🖼️ Neofetch (`neofetch/`)

**What it does**: Displays system information with ASCII art logo.

**Key Features**:
- Custom ASCII art support
- Shows: OS, kernel, uptime, packages, shell, DE/WM, CPU, GPU, memory
- Great for showing off your setup

**Why this config**: Standard neofetch with custom ASCII art capability. Perfect for posting your setup online or just showing system info.

### ⭐ Starship Prompt (`starship.toml`)

**What it does**: Cross-shell prompt that shows contextual information.

**Key Features**:
- **Dracula Powerline Style**: Segmented colored blocks
- **Git Integration**: Branch name, status indicators (modified/staged/ahead/behind)
- **Language Detection**: Auto-detects and shows versions for:
  - Node.js, Python, Rust, Go, C, Java, Kotlin, Haskell, PHP
- **Environment Info**: Shows conda/virtualenv when active
- **Time Display**: Current time (12-hour format)
- **Command Duration**: Shows how long commands took to run
- **Smart Icons**: OS-specific icons, Nerd Font symbols

**Why this config**: Provides instant context about your environment without cluttering the prompt. Looks beautiful and is highly functional.

## 🎨 Theme: Dracula

All configurations use the **Dracula** color scheme for consistency:

| Color   | Hex       | Usage                          |
|---------|-----------|--------------------------------|
| Purple  | `#bd93f9` | Cursors, prompts, accents      |
| Cyan    | `#8be9fd` | Directories, variables         |
| Pink    | `#ff79c6` | Git info, keywords             |
| Green   | `#50fa7b` | Success, strings               |
| Yellow  | `#f1fa8c` | Warnings, functions            |
| Orange  | `#ffb86c` | Numbers, constants             |
| Red     | `#ff5555` | Errors, deletions              |
| Comment | `#6272a4` | Comments, secondary info       |

## 📦 Installation

### ⚡ Quick Install (Recommended)

**Easy, automated setup** - Just run the installer:

```bash
cd daopctn_gui
./install.sh
```

The installer will:
- ✅ Check for missing dependencies
- ✅ Offer to install them automatically
- ✅ Backup your existing configs
- ✅ Let you choose: symlinks (recommended) or copy
- ✅ Install Nerd Fonts automatically
- ✅ Configure starship in your shell
- ✅ Set up Neovim plugins

**Difficulty**: ⭐ Easy (5 minutes)

---

### 🔧 Manual Installation

If you prefer manual setup or the installer doesn't work:

#### Prerequisites

Install required applications:

```bash
# Ubuntu/Debian
sudo apt install neovim btop cava neofetch git curl

# For Starship
curl -sS https://starship.rs/install.sh | sh

# For Ghostty (check official site for latest)
# https://ghostty.org

# Required Fonts (Nerd Fonts)
# Download from: https://www.nerdfonts.com/
# - CaskaydiaCove Nerd Font
```

#### Option 1: Symlink (Recommended)

Symlinks allow you to edit configs in the project folder and changes apply immediately:

```bash
# Backup existing configs
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.config/ghostty ~/.config/ghostty.backup 2>/dev/null
mv ~/.config/btop ~/.config/btop.backup 2>/dev/null
mv ~/.config/cava ~/.config/cava.backup 2>/dev/null
mv ~/.config/neofetch ~/.config/neofetch.backup 2>/dev/null
mv ~/.config/starship.toml ~/.config/starship.toml.backup 2>/dev/null

# Create symlinks
ln -s "$HOME/My projects/daopctn_gui/nvim" ~/.config/nvim
ln -s "$HOME/My projects/daopctn_gui/ghostty" ~/.config/ghostty
ln -s "$HOME/My projects/daopctn_gui/btop" ~/.config/btop
ln -s "$HOME/My projects/daopctn_gui/cava" ~/.config/cava
ln -s "$HOME/My projects/daopctn_gui/neofetch" ~/.config/neofetch
ln -s "$HOME/My projects/daopctn_gui/starship.toml" ~/.config/starship.toml
```

#### Option 2: Direct Copy

Copy configurations to their standard locations:

```bash
cp -r nvim ~/.config/
cp -r ghostty ~/.config/
cp -r btop ~/.config/
cp -r cava ~/.config/
cp -r neofetch ~/.config/
cp starship.toml ~/.config/
```

#### Starship Shell Integration

Add to your shell config:

```bash
# For bash (~/.bashrc)
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# For zsh (~/.zshrc)
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
```

#### Neovim Plugin Setup

On first launch, Neovim will automatically install all plugins:

```bash
nvim
# Wait for lazy.nvim to download and install plugins
# Then type :q to quit
```

**Difficulty**: ⭐⭐ Medium (15-20 minutes)

## 🔧 Customization

### Change Font Sizes
- **Ghostty**: Edit `ghostty/config`, change `font-size = 11`
- **Starship**: Font size controlled by your terminal

### Change Background Image (Ghostty)
Edit `ghostty/config`:
```
background-image = /path/to/your/image.jpg
background-image-opacity = 0.01  # Adjust opacity (0.0 - 1.0)
```

### Disable Neovim Plugins
Edit `nvim/lua/plugins/<plugin-name>.lua` and set `enabled = false`

### Add Auto-Complete to Neovim
Create `nvim/lua/plugins/nvim-cmp.lua` and add nvim-cmp configuration

### Add Git Diff View to Neovim
Install plugins like `diffview.nvim` or `gitsigns.nvim`

## 📝 File Structure

```
daopctn_gui/
├── install.sh             # 🚀 Automated installer script
├── README.md              # This file
├── nvim/                  # Neovim configuration
│   ├── init.lua          # Main config
│   ├── lazy-lock.json    # Plugin versions lock
│   └── lua/plugins/      # Individual plugin configs (11 files)
├── ghostty/              # Ghostty terminal
│   ├── config            # Main config
│   ├── shaders/          # GLSL shaders (cursor effects)
│   └── themes/           # Dracula theme
├── btop/                 # System monitor
│   └── btop.conf
├── cava/                 # Audio visualizer
│   └── config
├── neofetch/            # System info
│   ├── config.conf
│   └── custom_ascii.txt
└── starship.toml        # Shell prompt
```

## 📦 What's Included in This Repo

### ✅ Configuration Files Only (Lightweight)

This repository contains **ONLY configuration files**, not the actual applications or plugin code. This keeps the repo small (~168KB) and easy to share.

**Included:**
- ✅ All config files (.lua, .conf, .toml)
- ✅ Theme definitions (Dracula)
- ✅ Custom shaders (GLSL for Ghostty cursor)
- ✅ Plugin specifications (what to install)
- ✅ Lock files (plugin versions)

**NOT Included (will be downloaded automatically):**
- ❌ Neovim plugins source code (~50MB when installed)
- ❌ Application binaries (nvim, ghostty, btop, etc.)
- ❌ Nerd Fonts (~100MB per font)
- ❌ Language servers for LSP

### 🔄 How Neovim Plugins Work

**Important**: This repo does **NOT** include cloned themes/plugins for Neovim.

Instead, it includes:
1. **Plugin configs** (`lua/plugins/*.lua`) - Tell lazy.nvim WHAT to install
2. **Lock file** (`lazy-lock.json`) - Specifies exact plugin versions
3. **Init file** (`init.lua`) - Bootstraps lazy.nvim

**On first run:**
```bash
nvim
# lazy.nvim will automatically:
# 1. Clone itself (if not present)
# 2. Read your plugin configs
# 3. Download all plugins from GitHub
# 4. Install language servers
# 5. Set up everything
```

This happens automatically! The lock file ensures everyone gets the same plugin versions.

**After first run**, plugins are stored in:
- `~/.local/share/nvim/lazy/` - Plugin source code
- `~/.local/state/nvim/` - Plugin state/cache

## 🚀 What's Missing (Intentionally)

These are NOT included but can be added:
- **Neovim Auto-complete**: nvim-cmp, coc.nvim, etc.
- **Git Integration**: fugitive, gitsigns, diffview, lazygit
- **Terminal Multiplexers**: tmux, screen configs (Ghostty has built-in splits)
- **Shell Configs**: .bashrc, .zshrc (only starship prompt included)
- **IDE Features**: Debuggers, test runners (keep it minimal)

## 🐛 Troubleshooting

**Icons not showing?**
- Install a Nerd Font and configure your terminal to use it

**Ghostty background image not working?**
- Update the path in `ghostty/config` to point to your image

**Neovim plugins not loading?**
- Run `:Lazy sync` inside Neovim to install plugins

**Starship not appearing?**
- Make sure you added `eval "$(starship init bash)"` to your .bashrc/.zshrc

## 📄 License

These are personal configurations. Feel free to use, modify, and share.

---

**Created**: 2026-02-13
**Theme**: Dracula
**Philosophy**: Beautiful, minimal, terminal-centric
