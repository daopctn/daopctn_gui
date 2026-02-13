# install.sh Features

## ✅ What the Installer Does Automatically

### 1. **Checks if Apps Are Installed** ✓
The script checks for these applications:
- ✅ git
- ✅ curl
- ✅ nvim (Neovim)
- ✅ btop
- ✅ cava
- ✅ neofetch
- ✅ starship
- ✅ ghostty (optional)

For each app, it shows:
- `[✓]` - If installed
- `[WARNING]` - If NOT installed

---

### 2. **Automatically Detects Package Manager** ✓
Supports multiple Linux distributions:
- **Ubuntu/Debian** → Uses `apt`
- **Fedora/RHEL** → Uses `dnf`
- **Arch/Manjaro** → Uses `pacman`

---

### 3. **Offers to Install Missing Apps** ✓
If any apps are missing, the script:
1. Lists what's missing
2. Asks: "Would you like to install missing dependencies? (y/n)"
3. If you say **yes**:
   - Runs `sudo apt install -y neovim btop cava neofetch` (or equivalent)
   - Installs Starship using official installer
   - Downloads and installs Nerd Fonts

**You don't need to install anything manually!**

---

### 4. **Backs Up Your Existing Configs** ✓
Before making any changes:
- Creates timestamped backup: `~/.config-backup-20260213-142530/`
- Moves your old configs there safely
- Shows you where backups are saved

---

### 5. **Installs Configuration Files** ✓
Asks you to choose:
- **Option 1: Symlinks** (recommended) - Links to repo files
- **Option 2: Copy** - Makes independent copies

Then automatically creates all symlinks/copies for:
- nvim
- ghostty
- btop
- cava
- neofetch
- starship.toml

---

### 6. **Downloads and Installs Fonts** ✓
Automatically:
- Downloads CaskaydiaCove Nerd Font from GitHub
- Extracts to `~/.local/share/fonts/`
- Refreshes font cache with `fc-cache`
- ~100MB download

No manual font installation needed!

---

### 7. **Configures Your Shell** ✓
Detects your shell (bash/zsh) and:
- Adds `eval "$(starship init bash)"` to `.bashrc`
- Or adds to `.zshrc` for zsh
- Checks if already configured (won't duplicate)

---

### 8. **Sets Up Neovim Plugins** ✓
Offers to:
- Launch Neovim immediately
- Let lazy.nvim download all plugins
- Install language servers
- Set up everything automatically

Or skip and do it later (first `nvim` launch will install)

---

## 📊 Installation Process Flow

```
./install.sh
    │
    ├─→ [1] Check if apps installed
    │   ├─ git ✓
    │   ├─ curl ✓
    │   ├─ nvim ✗ NOT INSTALLED
    │   ├─ btop ✗ NOT INSTALLED
    │   ├─ cava ✓
    │   └─ starship ✗ NOT INSTALLED
    │
    ├─→ [2] Detect package manager (apt/dnf/pacman)
    │   └─ Found: apt
    │
    ├─→ [3] Ask: Install missing? (y/n)
    │   └─ User: y
    │
    ├─→ [4] Install packages
    │   ├─ sudo apt install neovim btop
    │   └─ curl https://starship.rs/install.sh | sh
    │
    ├─→ [5] Backup existing configs
    │   └─ Moved to ~/.config-backup-20260213/
    │
    ├─→ [6] Ask: Symlinks or Copy? (1/2)
    │   └─ User: 1 (symlinks)
    │
    ├─→ [7] Create symlinks
    │   ├─ ~/.config/nvim → daopctn_gui/nvim
    │   ├─ ~/.config/ghostty → daopctn_gui/ghostty
    │   └─ ... (all configs)
    │
    ├─→ [8] Ask: Install fonts? (y/n)
    │   └─ Downloads CaskaydiaCove Nerd Font
    │
    ├─→ [9] Ask: Configure shell? (y/n)
    │   └─ Adds starship to .bashrc
    │
    ├─→ [10] Ask: Setup Neovim now? (y/n)
    │   └─ Launches nvim, installs plugins
    │
    └─→ [DONE] ✅ Installation Complete!
```

---

## 🎯 What You Need to Do

**Literally just 3 things:**

1. Run the script:
   ```bash
   ./install.sh
   ```

2. Answer some questions:
   - Install missing apps? → `y`
   - Symlinks or copy? → `1`
   - Install fonts? → `y`
   - Configure shell? → `y`
   - Setup Neovim? → `y`

3. Restart your terminal

**That's it!** Everything else is automatic.

---

## 🚫 What the Script Does NOT Install

- **Ghostty** - Not in most package repos yet, must install manually
  - Script detects it as optional
  - You can use any other terminal (kitty, alacritty, gnome-terminal)

---

## 💡 Zero-Knowledge Installation

**Even if you know nothing about Linux**, you can use this:

1. You don't need to know package managers (script detects it)
2. You don't need to know where configs go (script puts them there)
3. You don't need to download fonts manually (script does it)
4. You don't need to edit shell configs (script adds starship)
5. You don't need to understand Neovim plugins (lazy.nvim handles it)

**It just works!** ✨

---

## 🛡️ Safety Features

- ✅ **Backups created** before any changes
- ✅ **Asks permission** before installing anything
- ✅ **Won't overwrite** without backing up
- ✅ **Checks dependencies** before proceeding
- ✅ **Colored output** shows what's happening
- ✅ **Error handling** - Exits safely if something fails

---

## 📝 Example Output

```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║        daopctn_gui Installation Script               ║
║        Dracula Theme Terminal Setup                  ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

[INFO] Installation directory: /home/user/My projects/daopctn_gui

═══ Step 1: Checking Dependencies ═══

[✓] git is installed
[✓] curl is installed
[WARNING] nvim is NOT installed
[✓] btop is installed
[✓] cava is installed
[✓] neofetch is installed
[WARNING] starship is NOT installed
[WARNING] ghostty is NOT installed (optional)

═══ Step 2: Installing Missing Dependencies ═══

[INFO] Missing dependencies: nvim starship
Would you like to install missing dependencies? (y/n): y

[INFO] Using package manager: apt
[INFO] Installing: neovim
... (installation output)
[✓] Packages installed successfully
[INFO] Installing starship...
[✓] Starship installed

═══ Step 3: Installation Method ═══

Choose installation method:
  1) Symlinks (Recommended)
  2) Copy
Enter choice (1 or 2): 1

... (continues through all steps)

╔═══════════════════════════════════════════════════════╗
║                                                       ║
║                Installation Complete! 🎉              ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

[✓] Configuration installed successfully!
```

---

**Bottom Line**: The script does **EVERYTHING** - checks, downloads, installs, configures. You just answer prompts!
