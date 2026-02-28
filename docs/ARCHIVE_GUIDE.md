# Creating Release Archive for HEXPal v1.0

This guide walks you through creating a release archive and attaching it to the GitHub release.

---

## Option 1: Automated Script (Recommended)

We've created an automated script that handles everything:

```bash
./scripts/create_release_archive.sh
```

The script will:
1. Create an Xcode archive
2. Export the app bundle
3. Create a ZIP file
4. Generate checksums (SHA256 and MD5)
5. Optionally upload to GitHub release

**Note:** The script disables code signing for now (since we're distributing via GitHub). If you want code signing, you'll need to configure it in Xcode first.

---

## Option 2: Manual Xcode Archive

If you prefer to create the archive manually in Xcode:

### Step 1: Open Project in Xcode

```bash
open HexPal.xcodeproj
```

### Step 2: Select Release Scheme

1. In Xcode, select **Product → Scheme → HexPal**
2. Select **Product → Destination → My Mac**
3. Select **Product → Build Configuration → Release**

### Step 3: Create Archive

1. **Product → Archive**
2. Wait for the archive to complete (may take a few minutes)
3. The Organizer window will open automatically

### Step 4: Export App

1. In the Organizer, select your archive
2. Click **Distribute App**
3. Choose **Copy App** (for local testing/distribution)
4. Click **Next**
5. Choose **Export** (not Upload)
6. Select a destination folder (e.g., Desktop)
7. Click **Export**

### Step 5: Create ZIP Archive

```bash
cd ~/Desktop  # or wherever you exported
zip -r HexPal-v1.0.zip HexPal.app
```

### Step 6: Generate Checksums

```bash
# SHA256
shasum -a 256 HexPal-v1.0.zip

# MD5
md5 HexPal-v1.0.zip
```

### Step 7: Upload to GitHub Release

```bash
cd /path/to/HEXPal
gh release upload v1.0 ~/Desktop/HexPal-v1.0.zip
gh release upload v1.0 checksums.txt  # if you created a checksums file
```

---

## Option 3: Command Line Archive (Fastest)

You can also create the archive entirely from the command line:

```bash
# Build and archive
xcodebuild archive \
    -project HexPal.xcodeproj \
    -scheme HexPal \
    -configuration Release \
    -archivePath ./build/HexPal.xcarchive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

# Create ZIP
cd build/HexPal.xcarchive/Products/Applications
zip -r ../../../../HexPal-v1.0.zip HexPal.app
cd ../../../../

# Generate checksums
shasum -a 256 build/HexPal-v1.0.zip > build/checksums.txt
md5 build/HexPal-v1.0.zip >> build/checksums.txt

# Upload to GitHub
gh release upload v1.0 build/HexPal-v1.0.zip
gh release upload v1.0 build/checksums.txt
```

---

## Verifying the Archive

After creating the archive, verify it works:

1. **Extract the ZIP** (if needed)
2. **Right-click HexPal.app → Open** (first time only, to bypass Gatekeeper)
3. **Test the app** - make sure it launches and works correctly
4. **Verify color picker** - confirm NSColorSampler activates with no permission prompts

---

## File Sizes

Expected sizes:
- **App bundle**: ~2-5 MB
- **ZIP archive**: ~1-3 MB (compressed)
- **Archive (.xcarchive)**: ~10-20 MB (includes debug symbols)

---

## Troubleshooting

### Archive fails with code signing errors

If you get code signing errors, you can disable code signing temporarily:

1. In Xcode: **Project → Signing & Capabilities**
2. Uncheck **Automatically manage signing**
3. Or use the script which disables code signing

### App won't open after download

macOS Gatekeeper may block unsigned apps. Users need to:
1. Right-click the app → **Open**
2. Click **Open** in the security dialog
3. Or: System Settings → Privacy & Security → Allow apps from anywhere

### Archive is too large

- Check for debug symbols (can be removed)
- Verify no unnecessary assets are included
- Check Info.plist for correct settings

---

## Next Steps

After creating and uploading the archive:

1. ✅ Update release date in `RELEASE_NOTES.md`
2. ✅ Verify the GitHub release page shows the download
3. ✅ Test downloading and installing the app
4. ✅ Update `RELEASE_CHECKLIST.md` to mark tasks complete

---

## Code Signing (Optional - For Future)

For production releases, you may want to code sign:

1. **Apple Developer Account**: Required ($99/year)
2. **Configure in Xcode**: Project → Signing & Capabilities
3. **Notarization**: Required for distribution outside App Store
4. **Hardened Runtime**: Already enabled in project settings

For now, unsigned distribution via GitHub is fine for open-source projects.
