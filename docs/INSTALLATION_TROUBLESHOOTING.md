# HEXPal Installation Troubleshooting

## macOS Security Alert: "HexPal" Not Opened

If you see an alert saying **"Apple could not verify 'HexPal' is free of malware"**, this is macOS Gatekeeper protecting your system. Since HEXPal is currently distributed unsigned (as an open-source project), macOS requires an extra step to run it.

### Solution: Bypass Gatekeeper (First Launch Only)

**Method 1: Right-Click Open (Recommended)**

1. **Right-click** (or Control+click) on `HexPal.app`
2. Select **Open** from the context menu
3. Click **Open** in the security dialog that appears
4. The app will launch and be added to your security exceptions

**Method 2: System Settings**

1. Open **System Settings** → **Privacy & Security**
2. Scroll down to the **Security** section
3. You should see a message: *"HexPal was blocked from use because it is not from an identified developer"*
4. Click **Open Anyway**
5. Confirm by clicking **Open** in the dialog

**Method 3: Command Line (Advanced)**

```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine /path/to/HexPal.app

# Or remove all extended attributes
xattr -cr /path/to/HexPal.app
```

### Why This Happens

HEXPal v1.0 is distributed **unsigned** because:
- Code signing requires an **Apple Developer account** ($99/year)
- Notarization requires code signing
- For open-source projects, unsigned distribution is common
- Users can still run the app with the steps above

### Future: Code Signing & Notarization

For future releases, we plan to:
- ✅ Sign the app with an Apple Developer ID
- ✅ Notarize with Apple
- ✅ Eliminate Gatekeeper warnings
- ✅ Provide seamless installation experience

### Security Note

HEXPal is **open-source** - you can review all code at:
https://github.com/jamcreativeconsulting/HexPal

The app:
- ✅ Runs entirely locally (no network requests)
- ✅ Doesn't collect or transmit any data
- ✅ Only requests necessary permissions (Screen Recording, Accessibility)
- ✅ Source code is publicly available for review

---

## Other Common Issues

### App Won't Launch After Installation

1. **Check Permissions**: Make sure you granted Screen Recording permission
2. **Check Menu Bar**: Look for the HEXPal icon (eyedropper) in your menu bar
3. **Restart**: Quit and relaunch the app
4. **Check Console**: Open Console.app and filter for "HexPal" to see error messages

### Hotkey Doesn't Work

1. **Check Accessibility Permission**: 
   - System Settings → Privacy & Security → Accessibility
   - Make sure HEXPal is enabled
2. **Check Hotkey Conflicts**:
   - Open Preferences in HEXPal
   - Try changing the hotkey to something else
3. **Restart App**: Quit and relaunch HEXPal

### Color Picker Doesn't Work

1. **Check Screen Recording Permission**:
   - System Settings → Privacy & Security → Screen Recording
   - Make sure HEXPal is enabled
2. **Restart App**: Quit and relaunch HEXPal
3. **Check macOS Version**: Requires macOS 10.15 (Catalina) or later

### Menu Bar Icon Missing

1. **Check Menu Bar**: Look in the right side of your menu bar
2. **Check Hidden Icons**: Click the arrow to show hidden menu bar items
3. **Restart App**: Quit and relaunch HEXPal

---

## Getting Help

If you continue to experience issues:

1. **Check GitHub Issues**: https://github.com/jamcreativeconsulting/HexPal/issues
2. **Create an Issue**: Include:
   - macOS version
   - Steps to reproduce
   - Error messages (if any)
   - Console logs (if applicable)
3. **Email Support**: jordan@jamcreative.co

---

## Verification: Is HEXPal Safe?

Since HEXPal is unsigned, you may want to verify its safety:

### Check the Source Code

```bash
# Clone the repository
git clone https://github.com/jamcreativeconsulting/HexPal.git

# Review the code
cd HexPal
# Inspect the Swift files in App/, Controllers/, Utilities/, etc.
```

### Check File Integrity

After downloading `HexPal-v1.0.zip`:

```bash
# Verify SHA256 checksum
shasum -a 256 HexPal-v1.0.zip
# Should match: 8a0d452808974b2355d2c7ecdccef174af9845f3355a42c8010ea6fbb0f2de9c

# Verify MD5 checksum
md5 HexPal-v1.0.zip
# Should match: 6024860bf811e2eea528f04649e747ef
```

### What HEXPal Does

HEXPal is a simple menu bar utility that:
- ✅ Uses Apple's native `NSColorSampler` API for color picking
- ✅ Copies HEX codes to clipboard
- ✅ Stores recent colors locally (UserDefaults)
- ✅ No network access, no data collection, no analytics

All functionality is visible in the open-source code.
