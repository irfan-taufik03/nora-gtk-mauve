# Nora GTK Mauve

Nora GTK Mauve is a GTK theme featuring a Mauve/Nord-inspired color palette for Linux desktop environments (GNOME, XFCE, Cinnamon, etc.).

## 📦 What's Included

- **GNOME Shell** theme
- **GTK 2.0 / 3.0 / 4.0** support
- **Metacity** window borders
- **XFWM4** window manager theme (XFCE)
- **Cinnamon** desktop support
- Automated installation script (`install.sh`)

---

## 🚀 Installation

### Automated Installation (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/irfan-taufik03/nora-gtk-mauve.git
   cd nora-gtk-mauve
   ```

2. Make sure the script is executable and run it:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```
   *This will install the theme to `~/.themes` and `~/.local/share/themes` for the current user.*

#### System-Wide Installation (Optional)

To install system-wide for all users (`/usr/share/themes`):
```bash
sudo ./install.sh -s
```

#### Uninstall

To uninstall the theme:
```bash
./install.sh -r
```

---

### Manual Installation

Copy the `Nora-gtk-mauve` folder directly into your themes directory:

- **For current user:**
  ```bash
  cp -r Nora-gtk-mauve ~/.themes/
  ```
- **System-wide:**
  ```bash
  sudo cp -r Nora-gtk-mauve /usr/share/themes/
  ```

---

## 🎨 Applying the Theme

### GNOME

Using **GNOME Tweaks** (under *Appearance -> Themes*), or via command line:
```bash
gsettings set org.gnome.desktop.interface gtk-theme "Nora-gtk-mauve"
gsettings set org.gnome.desktop.wm.preferences theme "Nora-gtk-mauve"
```

### XFCE
Open **Settings -> Appearance** and select `Nora-gtk-mauve`, then open **Window Manager** and select `Nora-gtk-mauve`.

### Cinnamon
Open **Themes** settings and select `Nora-gtk-mauve` for Controls and Window borders.

---

## 📄 License

GPL-3.0 License. See [LICENSE](Nora-gtk-mauve/LICENSE) for details.
