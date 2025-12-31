# HEXPal v1.0 Release Checklist

**Target Release Date:** TBD  
**Status:** Pre-Release

---

## Pre-Release Requirements

### Code Quality
- [ ] All tests passing
- [ ] No linter errors
- [ ] All files under 400-line limit
- [ ] Code follows Swift API Design Guidelines
- [ ] All public APIs documented
- [ ] No debug logging in production code
- [ ] No TODO comments in production code

### Functionality
- [ ] Core color picking workflow works
- [ ] Hotkey activation works reliably
- [ ] Recent Colors feature works
- [ ] Preferences window functional
- [ ] Launch at login works
- [ ] All error handling tested
- [ ] Permissions handled gracefully

### Performance
- [ ] Activation time < 100ms ✅
- [ ] Total workflow < 2 seconds ✅
- [ ] Memory usage < 50MB ✅
- [ ] CPU usage < 1% idle, < 5% active ✅

### Testing
- [ ] Comprehensive testing completed (see TESTING_CHECKLIST.md)
- [ ] Tested on macOS 10.15+
- [ ] Tested with multiple displays
- [ ] Tested with different color profiles
- [ ] All error scenarios tested
- [ ] No critical bugs remaining

---

## Documentation

### User Documentation
- [ ] README.md updated and accurate
- [ ] Installation instructions clear
- [ ] Usage instructions clear
- [ ] Troubleshooting section (if needed)
- [ ] Screenshots/GIFs (optional but recommended)

### Developer Documentation
- [ ] CONTRIBUTING.md up to date
- [ ] CODE_OF_CONDUCT.md in place
- [ ] Architecture documented (if needed)
- [ ] API documentation complete
- [ ] Code comments comprehensive

### Release Notes
- [ ] Release notes prepared
- [ ] Features listed
- [ ] Known limitations documented
- [ ] Credits/acknowledgments (if any)

---

## Version Information

### Version Number
- [ ] Update `CFBundleShortVersionString` in Info.plist → `1.0`
- [ ] Update `CFBundleVersion` in Info.plist → `1` (or increment)
- [ ] Update version in README.md
- [ ] Update version in About dialog (if hardcoded)

### Build Configuration
- [x] Release build configuration set
- [ ] Code signing configured (if distributing)
- [x] Deployment target set correctly (macOS 10.15+)
- [x] Menu bar icon configured (using SF Symbol "eyedropper")
- [ ] Custom app icon (optional - see APP_ICON_GUIDE.md)

---

## Git & Version Control

### Pre-Release
- [ ] All changes committed
- [ ] All changes pushed to main branch
- [ ] No uncommitted changes
- [ ] Git status clean

### Release Tagging
- [ ] Create annotated tag: `git tag -a v1.0 -m "Release v1.0"`
- [ ] Push tag: `git push origin v1.0`
- [ ] Verify tag on GitHub

### Release Branch (Optional)
- [ ] Create release branch: `git checkout -b release/v1.0`
- [ ] Final testing on release branch
- [ ] Merge to main when ready

---

## Distribution Preparation

### Code Signing (if distributing outside App Store)
- [ ] Apple Developer account set up
- [ ] Code signing certificate configured
- [ ] Provisioning profile configured
- [ ] App signed correctly

### Notarization (if distributing outside App Store)
- [ ] App notarized by Apple
- [ ] Notarization successful
- [ ] Stapled to app bundle

### Archive & Build
- [ ] Archive created in Xcode
- [ ] Release build successful
- [ ] App bundle verified
- [ ] Size reasonable (< 10MB expected)

### Distribution Format
- [ ] **Option A: Direct Download**
  - [ ] DMG created (if using)
  - [ ] DMG signed
  - [ ] ZIP archive created (alternative)
  - [ ] Release notes included
  
- [ ] **Option B: GitHub Releases**
  - [ ] Release created on GitHub
  - [ ] Release notes added
  - [ ] App bundle attached
  - [ ] Checksums provided (optional but recommended)

- [ ] **Option C: Mac App Store** (Future)
  - [ ] App Store Connect account set up
  - [ ] App metadata prepared
  - [ ] Screenshots prepared
  - [ ] App submitted for review

---

## Post-Release

### Communication
- [ ] Release announcement (if applicable)
- [ ] Update project website (if applicable)
- [ ] Social media posts (if applicable)
- [ ] Community notification (if applicable)

### Monitoring
- [ ] Monitor for crash reports
- [ ] Monitor for user feedback
- [ ] Monitor GitHub issues
- [ ] Prepare hotfix if critical issues found

### Follow-Up
- [ ] Plan v1.1 features based on feedback
- [ ] Document lessons learned
- [ ] Update roadmap

---

## Release Notes Template

```markdown
# HEXPal v1.0 Release Notes

## 🎉 First Release!

HEXPal is now available! A free, open-source macOS menu bar application for quickly picking colors and getting HEX codes.

## ✨ Features

### Core Functionality
- **Color Picking**: Pick any color from your screen with Apple's native color picker
- **HEX Codes**: Automatically copy HEX codes to clipboard
- **Global Hotkey**: Activate from anywhere with ⌘⇧P (customizable)
- **Recent Colors**: Quick access to last 10 picked colors
- **Multi-Monitor Support**: Works seamlessly across all displays

### User Experience
- **Modern Notifications**: Clean, non-intrusive clipboard confirmations
- **Welcome Screen**: First-launch onboarding
- **Preferences**: Customize hotkey and launch at login
- **Error Handling**: Clear, user-friendly error messages

## 🚀 Getting Started

1. Download HEXPal from [GitHub Releases](https://github.com/jamcreativeconsulting/HexPal/releases)
2. Open the app
3. Grant Screen Recording permission when prompted
4. Press ⌘⇧P or click the menu bar icon to pick colors!

## 📋 Requirements

- macOS 10.15 (Catalina) or later
- Screen Recording permission (for color picking)
- Accessibility permission (for global hotkeys, optional)

## 🐛 Known Limitations

- Launch at login requires manual setup on macOS < 13
- Some hotkey combinations may conflict with system shortcuts

## 🙏 Credits

Built with ❤️ by the HEXPal contributors.

## 📄 License

MIT License - See LICENSE file for details.

## 🔗 Links

- [GitHub Repository](https://github.com/jamcreativeconsulting/HexPal)
- [Issue Tracker](https://github.com/jamcreativeconsulting/HexPal/issues)
- [Contributing Guide](CONTRIBUTING.md)
```

---

## Quick Release Commands

```bash
# Update version in Info.plist (manually or via script)
# Then:

# Tag release
git tag -a v1.0 -m "Release v1.0 - First stable release"
git push origin v1.0

# Create GitHub release (via web UI or GitHub CLI)
gh release create v1.0 \
  --title "HEXPal v1.0" \
  --notes-file RELEASE_NOTES.md \
  HexPal.app.zip
```

---

**Release Status:** 🟡 Ready for Testing → 🟢 Ready for Release
