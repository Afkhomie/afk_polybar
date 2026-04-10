# AFK Polybar

A modern and minimal polybar configuration with a beautiful Catppuccin Mocha theme. Features real-time system monitoring, music player controls, power management, and a sleek pill-style UI design.

## 📸 Features

- **System Monitoring**: Real-time CPU, RAM, disk, network speed, and temperature display
- **Music Controls**: Integrated music player with previous, play/pause, and next controls (playerctl support)
- **Power Menu**: Quick access power options (shutdown, restart, logout, sleep) via rofi
- **Tray Integration**: System tray support with toggle functionality
- **Active Window Display**: Shows currently focused window in the center
- **Beautiful Theme**: Catppuccin Mocha color scheme with pill-style design elements
- **Responsive Layout**: Optimized for 1366x768 resolution (adaptable)

## 🎨 Color Scheme

Built with **Catppuccin Mocha** palette featuring:
- Lavender accents for UI elements
- Teal for network indicators
- Red for CPU usage
- Peach for temperature
- Pink for music player
- Green for time/clock

## 📦 Components

### Main Modules

| Module | Function | Colors |
|--------|----------|--------|
| **Power Button** | Quick access power menu | Red/Pill-1 |
| **Music Player** | Track info & controls | Pink/Pill-2 |
| **Windows** | Active window name | Text |
| **Network** | Upload/download speed | Teal/Pill-2 |
| **Disk** | Storage usage | Mauve/Pill-2 |
| **CPU** | CPU usage percentage | Red/Pill-2 |
| **Temperature** | CPU temperature | Peach/Pill-2 |
| **RAM** | Memory usage | Mauve/Pill-2 |
| **Clock** | Time display | Green/Pill-3 |
| **Tray** | System tray | Base |

### Scripts

Located in `scripts/` directory:

- **Music**: `music.sh`, `music-toggle-icon.sh`, `music-prev-icon.sh`, `music-next-icon.sh`, `music-pill-l.sh`, `music-pill-r.sh`
- **System Info**: `cpu-usage.sh`, `cpu-temp.sh`, `cpu-detail.sh`, `ram-usage.sh`, `ram-detail.sh`, `disk-usage.sh`, `disk-detail.sh`, `network-speed.sh`, `net-detail.sh`, `battery.sh`
- **UI Elements**: `tray-arrow.sh`, `tray-toggle.sh`, `windows.sh`
- **Power Management**: `power-menu.sh`
- **Utilities**: `temp-detail.sh`

## 🔧 Installation

1. Clone or download this repository to `~/.config/polybar/`

```bash
git clone <repository-url> ~/.config/polybar/afk_polybar
```

2. Install dependencies:
   - `polybar` - The status bar itself
   - `playerctl` - For music player controls
   - `rofi` - For the power menu UI
   - `Font Awesome 6` - Icon font
   - `JetBrains Mono` - Main font

3. Update script paths in `config.ini` if needed (default: `~/.config/polybar/scripts/`)

4. Launch polybar:

```bash
polybar main
```

## 🎵 Dependencies

- **polybar**: Status bar framework
- **playerctl**: Media player controller (for music controls)
- **rofi**: Application launcher & menu utility
- **Font Awesome 6 Free**: Icon fonts
- **JetBrains Mono**: Monospace font
- **System utilities**: `top`, `playerctl`, standard Linux tools

## 🖱️ Controls

- **Power Button**: Left-click for power menu
- **Music Controls**: Click next/previous/play-pause to control music
- **System Info**: Right-click for detailed information windows
- **Tray**: Click arrow icon to toggle system tray visibility

## 🎯 Customization

### Colors

Edit the `[colors]` section in `config.ini` to customize the color scheme. All module colors reference these base colors.

### Fonts

Modify the `font-*` settings in the `[bar/main]` section to use different fonts.

### Resolution & Sizing

Adjust `width` and `height` in `[bar/main]` for different screen resolutions. The config is optimized for 1366x768.

### Update Intervals

Each module has an `interval` parameter controlling update frequency (in seconds). Lower values mean more frequent updates but higher CPU usage.

## 📝 Configuration

The main configuration is in `config.ini` which defines:
- Bar dimensions and positioning
- Module layout (left, center, right)
- Module styling and spacing
- Fonts and colors
- Click actions and scripts

## 🚀 Performance Tips

- Increase update intervals for heavy scripts (e.g., CPU detail)
- Disable modules you don't need
- Reduce font sizes if bar is crowded
- Use `interval = 0` for static modules

## 📄 License

Feel free to use, modify, and distribute. Catppuccin color scheme is used under its terms.

## 🤝 Contributing

Feel free to fork, modify, and submit improvements!

---

**Theme**: Catppuccin Mocha  
**Status Bar**: Polybar  
**DE Compatible**: Any (X11 required)
