# Step-by-Step: Create Release Archive

The automated script hit Xcode build issues. Here's the manual approach that works reliably:

## Step 1: Clean Build Folder in Xcode

1. Open `HexPal.xcodeproj` in Xcode
2. **Product → Clean Build Folder** (Shift+Cmd+K)
3. Wait for cleanup to complete

## Step 2: Create Archive

1. **Product → Scheme → HexPal** (verify it's selected)
2. **Product → Destination → My Mac** (or Any Mac)
3. **Product → Archive**
4. Wait for archive to complete (2-5 minutes)
5. Organizer window will open automatically

## Step 3: Export App

1. In Organizer, select your archive
2. Click **Distribute App**
3. Choose **Copy App** (for local distribution)
4. Click **Next**
5. Choose **Export** (not Upload)
6. Select destination (e.g., Desktop)
7. Click **Export**
8. Wait for export to complete

## Step 4: Create ZIP and Checksums

After export completes, run these commands:

```bash
cd ~/Desktop  # or wherever you exported

# Create ZIP
zip -r HexPal-v1.0.zip HexPal.app

# Generate checksums
shasum -a 256 HexPal-v1.0.zip > checksums.txt
md5 HexPal-v1.0.zip >> checksums.txt

# View checksums
cat checksums.txt
```

## Step 5: Upload to GitHub Release

```bash
cd /path/to/HEXPal

# Upload ZIP
gh release upload v1.0 ~/Desktop/HexPal-v1.0.zip

# Upload checksums
gh release upload v1.0 ~/Desktop/checksums.txt
```

## Step 6: Verify Release

Visit: https://github.com/jamcreativeconsulting/HexPal/releases/tag/v1.0

You should see:
- ✅ Release notes
- ✅ HexPal-v1.0.zip download
- ✅ checksums.txt file

## Troubleshooting

### Archive fails with duplicate output errors

**Solution:** Clean build folder first:
1. Xcode → Product → Clean Build Folder
2. Close Xcode
3. Delete `~/Library/Developer/Xcode/DerivedData/HexPal-*`
4. Reopen Xcode and try again

### App won't open after download

Users need to:
1. Right-click HexPal.app → **Open**
2. Click **Open** in security dialog
3. Or: System Settings → Privacy & Security → Allow apps from anywhere

### Archive is too large

- Normal size: 2-5 MB for app, 1-3 MB compressed
- If larger, check for debug symbols (can be removed in Release build)

---

**Once complete, update RELEASE_CHECKLIST.md to mark archive tasks as done!**
