# Granting Permissions for HEXPal (Xcode Development)

When running HEXPal from Xcode (not as an installed app), you still need to grant permissions. Here's how:

---

## Method 1: Grant Permission While App is Running (Easiest)

1. **Run the app from Xcode** (⌘R)
2. **The app will show an error dialog** asking for Accessibility permission
3. **Click "Open System Settings"** in the dialog
4. **System Settings will open** to Privacy & Security → Accessibility
5. **Look for "HexPal"** in the list (it should appear there)
6. **Toggle it ON**
7. **Restart HEXPal** (quit and run again from Xcode)

**Note:** The app name in System Settings will be "HexPal" (the product name).

---

## Method 2: Manual Permission Grant

If the dialog doesn't appear or you want to grant permission manually:

1. **Run the app from Xcode** (⌘R)
2. **Open System Settings** manually:
   - Apple menu → System Settings
   - Privacy & Security → Accessibility
3. **Look for "HexPal"** in the list
   - If it's not there, try scrolling down
   - Or look for the bundle identifier: `co.jamcreative.HexPal`
4. **Toggle it ON**
5. **Restart HEXPal** (quit and run again from Xcode)

---

## Method 3: Build and Install Proper App Bundle (For Testing)

If you want to test with a proper app bundle (like end users will have):

### Option A: Archive and Export

1. **In Xcode:**
   - Product → Archive
   - Wait for archive to complete
   - Click "Distribute App"
   - Choose "Copy App" (for local testing)
   - Choose destination folder (e.g., Desktop)
   - Click "Export"

2. **Install the app:**
   - Navigate to the exported folder
   - Drag `HexPal.app` to Applications folder (or anywhere)
   - Right-click → Open (first time only, to bypass Gatekeeper)
   - Click "Open" in the security dialog

3. **Grant permissions:**
   - System Settings → Privacy & Security → Accessibility
   - Find "HexPal" and toggle ON
   - System Settings → Privacy & Security → Screen Recording
   - Find "HexPal" and toggle ON

### Option B: Quick Build Script

Create a script to build and copy the app:

```bash
#!/bin/bash
# Build and copy HEXPal.app to Desktop

xcodebuild -project HexPal.xcodeproj \
  -scheme HexPal \
  -configuration Release \
  -derivedDataPath ./build \
  build

# Copy to Desktop
cp -r ./build/Build/Products/Release/HexPal.app ~/Desktop/

echo "HexPal.app copied to Desktop"
echo "Right-click → Open to launch (first time only)"
```

---

## Troubleshooting

### App Not Appearing in System Settings

**If "HexPal" doesn't appear in Accessibility list:**

1. **Make sure the app is running** (even briefly)
2. **Check the bundle identifier:**
   - Look for `co.jamcreative.HexPal` in System Settings
   - Sometimes it appears under a different name
3. **Try granting permission via Terminal:**
   ```bash
   # This will prompt for permission
   tccutil reset Accessibility co.jamcreative.HexPal
   ```
4. **Restart System Settings** and check again

### Permission Already Granted But Not Working

1. **Revoke and re-grant:**
   - System Settings → Privacy & Security → Accessibility
   - Toggle HexPal OFF
   - Toggle HexPal ON
   - Restart HEXPal

2. **Reset permissions completely:**
   ```bash
   tccutil reset Accessibility co.jamcreative.HexPal
   ```
   Then grant permission again

### Testing Permission Status

You can check if permission is granted:

```bash
# Check Accessibility permission
sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT * FROM access WHERE service='kTCCServiceAccessibility' AND client='co.jamcreative.HexPal';"
```

Or use the app's built-in check (it will show an error if not granted).

---

## What Permissions HEXPal Needs

1. **Screen Recording** (Required)
   - For picking colors from the screen
   - Requested automatically when you try to pick a color

2. **Accessibility** (Required for Global Hotkeys)
   - For system-wide keyboard shortcuts (⌘⇧P)
   - Requested on app launch
   - Without this, hotkey only works when app is in focus

---

## Quick Test After Granting Permission

1. **Grant Accessibility permission** (see methods above)
2. **Restart HEXPal** (quit and run again)
3. **Switch to another app** (Finder, Browser, etc.)
4. **Press ⌘⇧P**
5. **Color picker should activate** ✅

If it works, you're all set! If not, check the troubleshooting section above.

---

## For Production/Release

When distributing HEXPal to users:

1. **Code sign the app** (required for distribution)
2. **Notarize the app** (recommended for macOS Gatekeeper)
3. **Users will grant permissions** when they first run the app
4. **The app will prompt them** with clear instructions

See `RELEASE_CHECKLIST.md` for distribution details.
