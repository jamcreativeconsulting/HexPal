# HEXPal v1.0 Release Notes

**Release Date:** December 31, 2024  
**Version:** 1.0  
**Build:** 1

---

## 🎉 First Release!

HEXPal is now available! A free, open-source macOS menu bar application for quickly picking colors and getting HEX codes. Built with Swift and AppKit, optimized for speed and simplicity.

---

## ✨ Features

### Core Functionality

- **Color Picking**: Pick any color from your screen with Apple's native color picker
  - Works system-wide across all applications, windows, and images
  - Precise pixel-level color selection
  - Instant activation with global hotkey

- **HEX Codes**: Automatically copy HEX codes to clipboard
  - Format: `#RRGGBB` (e.g., `#FF5733`)
  - Ready to paste into your code or design tools
  - No manual copy step required

- **Global Hotkey**: Activate from anywhere with ⌘⇧P (customizable)
  - Works from any application
  - Customizable in Preferences
  - Non-conflicting default shortcut

- **Recent Colors**: Quick access to last 10 picked colors
  - Accessible from menu bar
  - Color swatches for visual identification
  - One-click copy to clipboard

- **Multi-Monitor Support**: Works seamlessly across all displays
  - Detects active screen automatically
  - Accurate color picking on any display
  - Supports different color profiles

### User Experience

- **Modern Notifications**: Clean, non-intrusive clipboard confirmations
  - Fade-in/fade-out animations
  - Click to re-copy functionality
  - Hover to pause auto-dismiss
  - "⌘V to paste" tooltip

- **Welcome Screen**: First-launch onboarding
  - Shows default hotkey on first run
  - Helps users get started quickly

- **Preferences**: Customize hotkey and launch at login
  - Visual hotkey picker
  - Launch at login option (macOS 13+)
  - Settings persist across launches

- **Error Handling**: Clear, user-friendly error messages
  - Permission guidance with links to System Settings
  - Graceful degradation when permissions not granted
  - Helpful troubleshooting information

---

## 🚀 Getting Started

1. **Download** HEXPal from [GitHub Releases](https://github.com/jamcreativeconsulting/HexPal/releases)
2. **Extract** `HexPal-v1.0.zip` and drag `HexPal.app` to Applications
3. **First Launch**: Right-click `HexPal.app` → **Open** → Click **Open** in security dialog
   - This bypasses macOS Gatekeeper (app is unsigned for open-source distribution)
   - See [Installation Troubleshooting](docs/INSTALLATION_TROUBLESHOOTING.md) for details
4. **Grant Permissions** when prompted:
   - Screen Recording (required for color picking)
   - Accessibility (required for global hotkeys, optional but recommended)
5. **Press ⌘⇧P** or click the menu bar icon to pick colors!

### Quick Workflow

1. **Activate** - Press ⌘⇧P or click menu bar icon
2. **Select** - Move cursor and click on any pixel
3. **Copy** - HEX code is automatically copied to clipboard
4. **Paste** - Use ⌘V wherever you need the color code

---

## 📋 Requirements

- **macOS**: 10.15 (Catalina) or later
- **Permissions**:
  - Screen Recording (required for color picking)
  - Accessibility (required for global hotkeys, optional)

---

## 🐛 Known Limitations

- **Launch at Login**: Requires manual setup on macOS < 13 (Ventura)
  - macOS 13+ users can enable in Preferences
  - Older macOS versions require manual System Preferences setup

- **Hotkey Conflicts**: Some hotkey combinations may conflict with system shortcuts
  - Default ⌘⇧P is non-conflicting
  - Customize in Preferences if conflicts occur

- **Color Accuracy**: Color results are converted to sRGB color space
  - May vary slightly based on display color profile
  - HEX codes are always in sRGB format

---

## 🔧 Technical Details

### Performance Targets (All Met ✅)

- **Activation**: < 100ms from hotkey to picker ready
- **Total Workflow**: < 2 seconds from activation to HEX in clipboard
- **Memory**: < 50MB RAM usage
- **CPU**: < 1% idle, < 5% when active

### Architecture

- **Language**: Swift
- **Framework**: AppKit (macOS native)
- **Graphics**: Core Graphics / Quartz
- **Color Picker**: NSColorSampler (Apple's native API)

---

## 🙏 Credits & Acknowledgments

Built with ❤️ by the HEXPal contributors.

### Technologies

- **Swift** - Modern, safe, and fast programming language
- **AppKit** - macOS native UI framework
- **Core Graphics** - Screen capture and color extraction
- **NSColorSampler** - Apple's native color picker API

### Inspiration

HEXPal was created to solve a simple problem: developers and designers need HEX codes quickly, without bloat or complexity. The speed-first philosophy ensures every feature serves the core workflow.

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Links

- **GitHub Repository**: [https://github.com/jamcreativeconsulting/HexPal](https://github.com/jamcreativeconsulting/HexPal)
- **Issue Tracker**: [https://github.com/jamcreativeconsulting/HexPal/issues](https://github.com/jamcreativeconsulting/HexPal/issues)
- **Contributing Guide**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Documentation**: [docs/](docs/)

---

## 📝 Release Information

**Version:** 1.0  
**Build:** 1  
**Release Date:** December 31, 2024  
**Minimum macOS:** 10.15 (Catalina)  
**Architecture:** Universal (Intel & Apple Silicon)

---

**Made with ❤️ for developers and designers who need HEX codes fast.**
