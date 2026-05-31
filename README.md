# daopctn_gui

Personal terminal and GUI configs for Ubuntu/Debian. **Manga Mono** theme — black ink, white page, grey screentone, one blue.

## Quick Start

```bash
cd daopctn_gui
./install.sh
```

## Theme: Manga Mono

Greyscale by default. One blue accent. Inspired by *Vagabond* and *Vinland Saga*.

| Token | Hex | Role |
|-------|-----|------|
| Canvas | `#0d1117` | background |
| Surface | `#161b22` | panels |
| Raised | `#1c2128` | elevated |
| Line | `#30363d` | borders |
| Tone | `#6e7681` | muted text |
| Soft | `#b9c1cb` | secondary text |
| Text | `#e8eaed` | primary |
| **Blue** | **`#4a9eff`** | **sole accent** |
| Brick | `#bf6a5e` | errors only |

## Contents

```
daopctn_gui/
├── btop/
│   ├── btop.conf
│   └── themes/manga-mono.theme
├── cava/config
├── ghostty/
│   ├── config
│   ├── shaders/cursor_smear.glsl
│   └── themes/manga-mono
├── gtk/gtk-3.0/gtk.css
├── neofetch/
│   ├── config.conf
│   └── custom_ascii.txt
├── nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/plugins/
├── terminator/
│   ├── config
│   └── manga-mono
├── assets/           # wallpapers
├── offline/          # offline installers
├── install.sh
└── starship.toml
```

## Apps

### Ghostty
- Theme: manga-mono
- Font: CaskaydiaCove Nerd Font 11pt
- Custom GLSL cursor smear shader
- Terminator-style splits: `Ctrl+Shift+O/E`, navigate `Ctrl+Shift+Arrow`, resize `Alt+Arrow`

### Neovim
- Plugin manager: lazy.nvim
- Theme: manga-mono (mini.base16)
- LSP, Treesitter, Telescope, Neo-tree, Lualine, Noice, completions

### Starship
- Manga Mono powerline palette (`manga-mono-light` on dark bg, `manga-mono-dark` on light bg)
- Git, language versions, conda, time, command duration

### Btop
- Theme: manga-mono

### Cava
- Manga mono greyscale-to-blue gradient

### GTK 3
- Colors only, Adwaita base shapes

### Terminator
- Manga mono colors

## Installation

### Automated

```bash
./install.sh
```

### Manual

```bash
# Dependencies
sudo apt install neovim btop cava neofetch git curl
curl -sS https://starship.rs/install.sh | sh
# Ghostty: https://ghostty.org

# Symlink configs
ln -s "$HOME/My projects/daopctn_gui/nvim"        ~/.config/nvim
ln -s "$HOME/My projects/daopctn_gui/ghostty"      ~/.config/ghostty
ln -s "$HOME/My projects/daopctn_gui/btop"         ~/.config/btop
ln -s "$HOME/My projects/daopctn_gui/cava"         ~/.config/cava
ln -s "$HOME/My projects/daopctn_gui/neofetch"     ~/.config/neofetch
ln -s "$HOME/My projects/daopctn_gui/starship.toml" ~/.config/starship.toml

# GTK theme
mkdir -p ~/.themes/manga-mono/gtk-3.0
cp gtk/gtk-3.0/gtk.css ~/.themes/manga-mono/gtk-3.0/gtk.css
gsettings set org.gnome.desktop.interface gtk-theme manga-mono

# Terminator
cp terminator/config ~/.config/terminator/config

# Shell prompt
echo 'eval "$(starship init bash)"' >> ~/.bashrc  # or .zshrc
```

On first Neovim launch, lazy.nvim auto-installs all plugins (~2-3 min).

## Troubleshooting

**Icons broken** → install CaskaydiaCove Nerd Font, set in terminal

**Ghostty background** → update path in `ghostty/config`

**Neovim plugins missing** → run `:Lazy sync`

**Starship not showing** → verify `eval "$(starship init bash)"` in shell rc

## License

MIT
