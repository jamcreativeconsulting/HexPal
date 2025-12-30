# HEXPal

**Pick any color. Get HEX. Instantly. Free forever.**

HEXPal is a free, open-source macOS menu bar application for quickly picking colors from anywhere on screen and getting HEX codes. Built with Swift and AppKit, optimized for speed and simplicity.

## ✨ Features

- **⚡ Lightning Fast** - Get HEX codes in under 2 seconds
- **🌐 System-Wide** - Pick colors from any app, window, or image
- **⌨️ Global Hotkey** - Activate instantly with `Cmd+Shift+C`
- **🎯 Precise** - Magnifying glass with pixel grid for accurate selection
- **📋 Auto-Copy** - HEX code automatically copied to clipboard
- **🆓 Free & Open Source** - No paywalls, no subscriptions, forever

## 🚀 Quick Start

### Installation

1. **Download** the latest release from [Releases](https://github.com/jamcreativeconsulting/HEXPal/releases)
2. **Open** the downloaded `.dmg` file
3. **Drag** HEXPal to your Applications folder
4. **Launch** HEXPal from Applications
5. **Grant Permissions** when prompted:
   - Screen Recording (required for color picking)
   - Accessibility (required for global hotkey)

### First Use

1. Press `Cmd+Shift+C` (or click the menu bar icon → "Pick Color")
2. Move your cursor over any color on screen
3. Click to select the color
4. HEX code is automatically copied to your clipboard!

## 📖 Usage

### Basic Workflow

1. **Activate** - Press `Cmd+Shift+C` or click menu bar icon
2. **Select** - Move cursor and click on any pixel
3. **Copy** - HEX code is automatically copied to clipboard
4. **Paste** - Use `Cmd+V` wherever you need the color code

### Menu Bar Options

- **Pick Color** - Activate the color picker
- **Preferences** - Customize hotkey and settings
- **About** - Version and license information
- **Quit** - Exit HEXPal

## 🛠️ Development

### Prerequisites

- macOS 11.0 (Big Sur) or later
- Xcode 14.0 or later
- Swift 5.7 or later

### Building from Source

1. **Clone** the repository:
   ```bash
   git clone https://github.com/jamcreativeconsulting/HEXPal.git
   cd HEXPal
   ```

2. **Open** the project in Xcode:
   ```bash
   open HEXPal.xcodeproj
   ```

3. **Build** the project:
   - Select the HEXPal scheme
   - Press `Cmd+B` to build
   - Press `Cmd+R` to run

### Project Structure

```
HEXPal/
├── App/                    # Application entry point
├── Controllers/            # View controllers and managers
├── Models/                 # Data models
├── Utilities/              # Helper classes and utilities
├── Views/                  # UI components
├── Resources/              # Assets and configuration
├── HEXPalTests/            # Unit tests
└── docs/                   # Documentation
```

### Code Standards

- **File Size Limit:** Maximum 400 lines per Swift file
- **Documentation:** All public APIs must have doc comments
- **Style:** Follow Swift API Design Guidelines
- **Architecture:** MVC pattern with separation of concerns

See [`docs/CODING_STYLE.md`](docs/CODING_STYLE.md) for detailed coding standards.

## 🤝 Contributing

We welcome contributions! Whether it's bug fixes, new features, or documentation improvements, your help makes HEXPal better for everyone.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Make** your changes following our [coding standards](docs/CODING_STYLE.md)
4. **Test** your changes thoroughly
5. **Commit** with clear messages (`git commit -m 'feat: Add amazing feature'`)
6. **Push** to your branch (`git push origin feature/amazing-feature`)
7. **Open** a Pull Request

### Contribution Guidelines

- Read our [Contributing Guide](CONTRIBUTING.md) for detailed guidelines
- Follow our [Code of Conduct](CODE_OF_CONDUCT.md)
- Check existing issues before creating new ones
- Write tests for new features
- Update documentation as needed
- Keep file sizes under 400 lines

### Reporting Issues

Found a bug? Have a feature request? Please [open an issue](https://github.com/jamcreativeconsulting/HEXPal/issues) with:
- Clear description of the problem or feature
- Steps to reproduce (for bugs)
- Expected vs. actual behavior
- macOS version and system information

## 📚 Documentation

- **[Development Plan](docs/PLAN.md)** - Complete development roadmap
- **[Coding Standards](docs/CODING_STYLE.md)** - Code style and architecture guidelines
- **[Project Summary](docs/PROJECT_SUMMARY.md)** - Project overview and context
- **[Pre-Setup Considerations](docs/PRE_SETUP_CONSIDERATIONS.md)** - Setup checklist
- **[Competitive Analysis](docs/COMPETITIVE_ANALYSIS.md)** - Market research

## 🎯 Performance Targets

- **Activation:** < 100ms from hotkey to picker ready
- **Total Workflow:** < 2 seconds from activation to HEX in clipboard
- **Memory:** < 50MB RAM usage
- **CPU:** < 1% idle, < 5% when active

## 🔒 Privacy & Security

- **No Data Collection** - HEXPal runs entirely locally
- **No Network Requests** - All processing happens on your Mac
- **No Analytics** - We don't track your usage
- **Open Source** - Review the code yourself

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Swift and AppKit
- Inspired by the need for a fast, free color picker
- Thanks to all contributors who make HEXPal better

## 📧 Support

- **Issues:** [GitHub Issues](https://github.com/jamcreativeconsulting/HEXPal/issues)
- **Discussions:** [GitHub Discussions](https://github.com/jamcreativeconsulting/HEXPal/discussions)
- **Email:** jordan@jamcreative.co
- **GitHub:** [@jbeur](https://github.com/jbeur)

---

**Made with ❤️ for developers and designers who need HEX codes fast.**
