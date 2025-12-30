# Fix Xcode Project Structure

## Issue
Xcode created a nested structure (`HexPal/HexPal/`) when the project was created, but our PLAN.md specifies a **flat structure at the root level**.

## Current Situation
- ✅ We have flat structure at root: `App/`, `Controllers/`, `Resources/`, etc.
- ❌ Xcode created nested structure: `HexPal/HexPal/`, `HexPal/HexPal.xcodeproj/`
- ❌ We now have duplicate/conflicting structures

## Solution: Consolidate to Flat Structure

### Step 1: Move Xcode Project to Root
The `.xcodeproj` file should be at the project root (already done if you see it at root level).

### Step 2: Update Xcode Project References
1. Open `HexPal.xcodeproj` in Xcode
2. Remove references to `HexPal/HexPal/` directory:
   - Right-click `HexPal/HexPal` group → Delete → Remove Reference (don't delete files)
3. Ensure project references our flat structure:
   - `App/AppDelegate.swift` (not `HexPal/HexPal/AppDelegate.swift`)
   - `Controllers/MenuBarController.swift`
   - `Resources/Info.plist`
   - `HexPalTests/` (our test files, not `HexPal/HexPalTests/`)

### Step 3: Clean Up Nested Directory
After updating Xcode references, you can safely remove:
```bash
rm -rf HexPal/HexPal/
rm -rf HexPal/HexPalTests/  # If it exists and is different from root HexPalTests/
```

**Note:** Keep `HexPal/HexPal.xcodeproj/` if it's still there, but ideally the `.xcodeproj` should be at root level.

## Verification
After fixing:
- ✅ `.xcodeproj` is at project root
- ✅ No nested `HexPal/HexPal/` directory
- ✅ Xcode project references flat structure files
- ✅ Matches PLAN.md structure

## Why This Happened
Xcode's default template creates a nested structure (`ProductName/ProductName/`). We need to reorganize it to match our planned flat structure.
