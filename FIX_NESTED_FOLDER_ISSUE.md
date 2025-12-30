# Fix: Xcode Keeps Re-adding Nested HexPal Folder

## Problem
Xcode keeps recreating the nested `HexPal/HexPal/` folder structure even after you remove it.

## Root Cause
The Xcode project file (`project.pbxproj`) has hardcoded references to the nested structure. Simply removing the folder reference doesn't fix the underlying configuration.

## Solution: Edit Project File Directly

### Step 1: Close Xcode Completely
**Important:** Xcode must be completely closed before editing the project file.

### Step 2: Backup Project File
```bash
cd /Users/jordan/Desktop/Business/JAMCreativeConsulting/Products/HEXPal
cp HexPal.xcodeproj/project.pbxproj HexPal.xcodeproj/project.pbxproj.backup
```

### Step 3: Check Current Structure
```bash
# See what nested structure exists
ls -la HexPal/ 2>/dev/null
```

### Step 4: Remove Nested Directory (If It Exists)
```bash
# Remove the nested HexPal/HexPal structure
rm -rf HexPal/HexPal/
rm -rf HexPal/HexPalTests/  # Only if different from root HexPalTests
rm -rf HexPal/HexPalUITests/  # Only if different from root HexPalUITests
```

### Step 5: Alternative Solution - Recreate Project Properly

Since Xcode keeps recreating the nested structure, the cleanest solution is to:

1. **Export your current code** (it's already in the flat structure, so you're good)

2. **Delete the Xcode project** (we'll recreate it):
   ```bash
   rm -rf HexPal.xcodeproj
   ```

3. **Recreate project in Xcode with correct structure:**
   - Open Xcode
   - File → New → Project
   - macOS → App
   - **Important:** When saving, save it at the **project root level**
   - Product Name: `HexPal`
   - **Save Location:** `/Users/jordan/Desktop/Business/JAMCreativeConsulting/Products/HEXPal`
   - **Uncheck** "Create Git repository"
   - **Uncheck** "Add to workspace" if prompted

4. **Immediately after creation, before Xcode adds files:**
   - Close Xcode
   - Delete the nested `HexPal/HexPal/` folder Xcode just created
   - Delete `HexPal/HexPalTests/` if it was created nested

5. **Reopen Xcode and add your existing files:**
   - Right-click project → Add Files to "HexPal"...
   - Select: `App/`, `Controllers/`, `Models/`, `Utilities/`, `Views/`, `Resources/`
   - ✅ Create groups
   - ❌ Don't copy items
   - ✅ Add to target: HexPal

## Better Solution: Use XcodeGen (Optional)

If you want to avoid this issue entirely, we could set up `xcodegen` to generate the project file from a YAML configuration. This gives us full control over the structure.

Would you like me to:
1. Help you manually fix the project.pbxproj file?
2. Guide you through recreating the project properly?
3. Set up XcodeGen for automated project generation?

## Quick Fix: Prevent Auto-Creation

If you just want to stop Xcode from recreating it:

1. **In Xcode, go to Build Settings**
2. Search for "Info.plist File"
3. Make sure it's set to `Resources/Info.plist` (not `HexPal/HexPal/Info.plist`)
4. Search for "Product Name" - should be `HexPal` (not nested path)
5. **In the project navigator**, make sure no files reference `HexPal/HexPal/` paths

The issue is likely that Xcode's target configuration is set to use the nested path as the source root.
