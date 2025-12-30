# Fix Build Errors

## Issues Found

1. **Duplicate README.md files** being copied to app bundle:
   - `.cursor/rules/README.md`
   - Root `README.md`

2. **Info.plist** in Copy Bundle Resources (redundant - handled automatically)

## Solution: Exclude Files from Target

### Option 1: Exclude in Xcode (Recommended)

1. **In Xcode Project Navigator**, select the root "." folder
2. **Right-click** on files that shouldn't be in the app bundle:
   - `README.md`
   - `CONTRIBUTING.md`
   - `CODE_OF_CONDUCT.md`
   - `LICENSE`
   - `*.md` files (all documentation)
   - `.cursor/` folder
   - `.github/` folder
   - `docs/` folder
   - Any other non-code files

3. **For each file/folder:**
   - Right-click → **Get Info** (or press `Cmd+I`)
   - In **Target Membership** section
   - **Uncheck** ✅ HexPal (keep it unchecked)
   - Only code files should be checked

4. **For Info.plist specifically:**
   - Select `Resources/Info.plist`
   - Get Info (`Cmd+I`)
   - **Target Membership** → Uncheck ✅ HexPal
   - It's already handled via `INFOPLIST_FILE` build setting

### Option 2: Configure FileSystemSynchronizedRootGroup Exclusions

Unfortunately, `FileSystemSynchronizedRootGroup` doesn't support exclusions in the project file directly. You need to exclude files via Target Membership in Xcode.

## Files That Should Be Included

✅ **Include in HexPal target:**
- `App/*.swift`
- `Controllers/*.swift`
- `Models/*.swift`
- `Utilities/*.swift`
- `Views/*.swift`
- `Resources/Info.plist` (handled automatically, but can be in target)
- `Resources/Assets.xcassets` (if you have one)

❌ **Exclude from HexPal target:**
- All `*.md` files
- `.cursor/` folder
- `.github/` folder
- `docs/` folder
- `.gitignore`
- `.swiftlint.yml`
- Any documentation or config files

## Quick Fix Steps

### Method 1: Exclude Multiple Files at Once (Fastest)

1. **In Xcode Project Navigator**, expand the "." folder
2. **Select multiple files** using `Cmd+Click`:
   - All `*.md` files (README.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md, etc.)
   - LICENSE
   - `.cursor/` folder
   - `.github/` folder
   - `docs/` folder
   - `.gitignore`
   - `.swiftlint.yml`

3. **Right-click** on the selected files → **Get Info** (or press `Cmd+I`)
   - OR: Select files → **View** menu → **Inspectors** → **File Inspector**
   - OR: Select files → Press `Option+Cmd+1` (File Inspector shortcut)

4. **In the File Inspector panel** (right sidebar):
   - Look for **"Target Membership"** section (may need to scroll down)
   - If you don't see it, try:
     - Make sure File Inspector is open (first tab icon in right sidebar)
     - The section might be collapsed - look for a disclosure triangle
     - Try selecting just ONE file first to see the panel

5. **Uncheck ✅ HexPal** for all selected files

6. **Repeat for Info.plist**:
   - Select `Resources/Info.plist`
   - Get Info (`Cmd+I`)
   - Target Membership → Uncheck HexPal
   - (It's handled automatically via `INFOPLIST_FILE` build setting)

7. **Build again** (`Cmd+B`) - should succeed ✅

### Alternative: Exclude via Build Phases

If Target Membership isn't visible, you can exclude files via Build Phases:

1. **Select the HexPal target** (in the project navigator, click on "HexPal" project → select "HexPal" target)
2. **Go to "Build Phases" tab**
3. **Expand "Copy Bundle Resources"**
4. **Find and remove** any documentation files (README.md, LICENSE, etc.)
5. **Remove Info.plist** from Copy Bundle Resources (if present)
6. **Build again** (`Cmd+B`)

### Method 2: Use Script to Identify Files

Run the helper script:
```bash
./exclude_docs_from_target.sh
```

This will list all files that should be excluded.

## Verification

After excluding files:
- ✅ Build succeeds
- ✅ No duplicate README.md error
- ✅ No Info.plist warning
- ✅ Only code files in app bundle
