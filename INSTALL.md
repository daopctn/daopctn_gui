# Installation Guide

## ⚡ Quick Install (Easiest)

**For most users - just run this:**

```bash
cd daopctn_gui
./install.sh
```

The installer will guide you through everything interactively.

---

## 📋 What the Installer Does

1. **Checks dependencies** - Detects what's missing
2. **Installs packages** - Offers to install nvim, btop, cava, neofetch, starship
3. **Backs up configs** - Saves your old configs safely
4. **Installs configs** - Your choice: symlinks or copy
5. **Downloads fonts** - Installs CaskaydiaCove Nerd Font
6. **Configures shell** - Adds starship to .bashrc/.zshrc
7. **Sets up Neovim** - Offers to install plugins immediately

**Time**: ~5 minutes
**Difficulty**: ⭐ Easy

---

## 🔍 System Requirements

- **OS**: Linux (Ubuntu, Debian, Fedora, Arch, etc.)
- **Disk Space**: ~200MB (including fonts and Neovim plugins)
- **Internet**: Required for downloading packages and plugins
- **Terminal**: Any terminal (Ghostty recommended)

---

## 🛠️ Manual Installation

<details>
<summary>Click to expand manual installation steps</summary>

### Step 1: Install Dependencies

```bash
# Ubuntu/Debian
sudo apt install neovim btop cava neofetch git curl unzip

# Fedora
sudo dnf install neovim btop cava neofetch git curl unzip

# Arch
sudo pacman -S neovim btop cava neofetch git curl unzip

# Install Starship (all distros)
curl -sS https://starship.rs/install.sh | sh
```

### Step 2: Backup Existing Configs

```bash
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.config/ghostty ~/.config/ghostty.backup 2>/dev/null
mv ~/.config/btop ~/.config/btop.backup 2>/dev/null
mv ~/.config/cava ~/.config/cava.backup 2>/dev/null
mv ~/.config/neofetch ~/.config/neofetch.backup 2>/dev/null
mv ~/.config/starship.toml ~/.config/starship.toml.backup 2>/dev/null
```

### Step 3: Install Configs (Choose One)

**Option A: Symlinks (Recommended)**
```bash
cd daopctn_gui
ln -s "$(pwd)/nvim" ~/.config/nvim
ln -s "$(pwd)/ghostty" ~/.config/ghostty
ln -s "$(pwd)/btop" ~/.config/btop
ln -s "$(pwd)/cava" ~/.config/cava
ln -s "$(pwd)/neofetch" ~/.config/neofetch
ln -s "$(pwd)/starship.toml" ~/.config/starship.toml
```

**Option B: Copy**
```bash
cd daopctn_gui
cp -r nvim ghostty btop cava neofetch starship.toml ~/.config/
```

### Step 4: Install Fonts

```bash
mkdir -p ~/.local/share/fonts
cd /tmp
curl -fLo CascadiaCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip
unzip -o CascadiaCode.zip -d ~/.local/share/fonts/CascadiaCode
rm CascadiaCode.zip
fc-cache -fv
```

### Step 5: Configure Shell

**For Bash:**
```bash
echo 'eval "$(starship init bash)"' >> ~/.bashrc
source ~/.bashrc
```

**For Zsh:**
```bash
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### Step 6: Install Neovim Plugins

```bash
nvim
# Wait for plugins to install (2-3 minutes)
# Then type :q to quit
```

**Time**: ~15-20 minutes
**Difficulty**: ⭐⭐ Medium

</details>

---

## ✅ Verify Installation

After installation, test each component:

```bash
# Test Neovim
nvim --version

# Test Starship (should see colorful prompt)
exec $SHELL

# Test system monitor
btop

# Test system info
neofetch

# Test audio visualizer (play music first)
cava
```

---

## 🐛 Troubleshooting

### Icons/symbols not showing?
**Problem**: Squares or missing characters
**Solution**: Install Nerd Fonts and configure your terminal to use them

```bash
# Check if font is installed
fc-list | grep -i cascadia

# If empty, run the font installation step again
```

### Neovim plugins not loading?
**Problem**: Neovim looks plain, no colors/features
**Solution**: Run `:Lazy sync` inside Neovim

```bash
nvim
:Lazy sync
# Wait for download to complete
:q
```

### Starship prompt not showing?
**Problem**: Terminal prompt unchanged
**Solution**: Source your shell config or restart terminal

```bash
# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc

# Or just restart your terminal
```

### Command not found: ghostty?
**Problem**: Ghostty not installed
**Solution**: Install manually from https://ghostty.org or use another terminal

```bash
# For now, you can use any terminal (kitty, alacritty, gnome-terminal)
# The configs will work in any terminal, just without Ghostty-specific features
```

### Permission denied: ./install.sh?
**Problem**: Script not executable
**Solution**: Make it executable

```bash
chmod +x install.sh
./install.sh
```

---

## 🔄 Updating

If you used **symlinks** (recommended):
```bash
cd daopctn_gui
git pull  # If using git
# Changes apply immediately!
```

If you used **copy**:
```bash
cd daopctn_gui
git pull  # If using git
cp -r nvim ghostty btop cava neofetch starship.toml ~/.config/
```

---

## 🗑️ Uninstallation

To remove these configs:

```bash
# Remove installed configs
rm -rf ~/.config/nvim ~/.config/ghostty ~/.config/btop ~/.config/cava ~/.config/neofetch
rm ~/.config/starship.toml

# Restore backups (if you have them)
mv ~/.config/nvim.backup ~/.config/nvim
# ... (repeat for other configs)

# Remove starship init from shell config (manual edit required)
# Remove this line from ~/.bashrc or ~/.zshrc:
#   eval "$(starship init bash)"
```

---

## 📚 Additional Resources

- **README.md** - Full documentation, customization guide
- **Neovim Help** - Type `:help` inside Neovim
- **Starship Docs** - https://starship.rs/config/
- **Ghostty Docs** - https://ghostty.org/docs

---

**Need help?** Check the main README.md or open an issue.
