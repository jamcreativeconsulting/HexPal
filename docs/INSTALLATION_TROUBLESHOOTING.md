# HEXPal Installation Troubleshooting

## macOS Security Alert: "HexPal" Not Opened

If you see **"Apple could not verify 'HexPal' is free of malware"**, this is macOS Gatekeeper. Since HEXPal is currently distributed unsigned (open-source), macOS requires an extra step on first launch.

### Solution: Bypass Gatekeeper (First Launch Only)

**Method 1: Right-Click Open (Recommended)**

1. **Right-click** (or Control+click) on `HexPal.app`
2. Select **Open** from the context menu
3. Click **Open** in the security dialog
4. The app will launch and be added to your security exceptions

**Method 2: System Settings**

1. Open **System Settings** → **Privacy & Security**
2. Scroll to the **Security** section
3. Click **Open Anyway** next to the HexPal message
4. Confirm by clicking **Open**

**Method 3: Command Line (Advanced)**

```bash
xattr -d com.apple.quarantine /path/to/HexPal.app
```

### Why This Happens

HEXPal v1.0 is distributed **unsigned** because:
- Code signing requires an **Apple Developer account** ($99/year)
- For open-source projects, unsigned distribution is common

### Future: Code Signing & Notarization

For future releases:
- ✅ Sign with Apple Developer ID
- ✅ Notarize with Apple
- ✅ Eliminate Gatekeeper warnings

### Security Note

HEXPal is **open-source** — review all code at:
https://github.com/jamcreativeconsulting/HexPal

The app:
- ✅ Runs entirely locally (no network requests)
- ✅ Doesn't collect or transmit any data
- ✅ Requires zero privacy permissions for color picking
- ✅ Source code is publicly available for review

---

## Other Common Issues

### App Won't Launch After Installation

1. **Check Menu Bar**: Look for the HEXPal eyedropper icon in your menu bar
2. **Restart**: Quit and relaunch the app
3. **Check Console**: Open Console.app and filter for "HexPal" to see error messages

### Hotkey Doesn't Work

1. **Check Hotkey Conflicts**:
   - Open Preferences in HEXPal and try a different hotkey
2. **Use Menu Bar**: Click the menu bar icon → "Pick Color" as an alternative

### Color Picker Doesn't Activate

1. **Click the menu bar icon** → "Pick Color" — this always works
2. **Check macOS Version**: Requires macOS 11.5 or later
3. **Restart App**: Quit and relaunch HEXPal

### Menu Bar Icon Missing

1. **Check hidden icons**: Click the arrow to show hidden menu bar items
2. **Restart App**: Quit and relaunch HEXPal

---

## Development Console Messages (Harmless)

When running from Xcode:

- **"layoutSubtreeIfNeeded on a view which is already being laid out"** — Layout timing quirk with `NSVisualEffectView`. Safe to ignore.
- **"Interrupted 0x… _connection … _server 0x0"** — Internal XPC message from the system color sampler or debugger. Safe to ignore.

---

## Getting Help

1. **Check GitHub Issues**: https://github.com/jamcreativeconsulting/HexPal/issues
2. **Create an Issue** with: macOS version, steps to reproduce, error messages
3. **Email Support**: jordan@jamcreative.co

---

## Verification: Is HEXPal Safe?

### Check the Source Code

```bash
git clone https://github.com/jamcreativeconsulting/HexPal.git
cd HexPal
# Inspect Swift files in App/, Controllers/, Utilities/, etc.
```

### What HEXPal Does

HEXPal is a simple menu bar utility that:
- ✅ Uses Apple's native `NSColorSampler` API for color picking (zero permissions)
- ✅ Copies HEX codes to clipboard
- ✅ Stores recent colors locally (UserDefaults)
- ✅ No network access, no data collection, no analytics
