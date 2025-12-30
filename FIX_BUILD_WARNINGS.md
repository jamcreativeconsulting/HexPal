# Fix Build Warnings

## Warnings Found

1. **"Building for macOS-11.5, but linking with dylib '@rpath/XCTest.framework...'"**
   - **Cause:** XCTest framework is incorrectly linked to the main HexPal target
   - **Fix:** Remove XCTest from HexPal target's Link Binary With Libraries

2. **"File 'HexPalTests.swift' is part of module 'HexPal'; ignoring import"**
   - **Cause:** HexPalTests.swift is included in the HexPal target (should only be in HexPalTests target)
   - **Fix:** Remove HexPalTests folder/files from HexPal target membership

## Solution Steps

### Fix 1: Remove XCTest from HexPal Target

1. **Select the HexPal project** (blue icon at top)
2. **Select the HexPal target** (under TARGETS, NOT HexPalTests)
3. **Click "Build Phases" tab**
4. **Expand "Link Binary With Libraries"**
5. **Find "XCTest.framework"** in the list
6. **Select it** → Press `Delete` → Choose "Remove" (not "Delete File")
7. **Verify:** XCTest should only be in HexPalTests target, not HexPal target

### Fix 2: Remove HexPalTests from HexPal Target

1. **In Project Navigator**, expand the "." folder
2. **Find "HexPalTests" folder**
3. **Select the HexPalTests folder**
4. **Open File Inspector** (right sidebar, first tab) or press `Option+Cmd+1`
5. **Scroll to "Target Membership" section**
6. **Uncheck ✅ HexPal** (keep ✅ HexPalTests checked)
7. **Do the same for individual test files:**
   - Select `HexPalTests/HexPalTests.swift`
   - File Inspector → Target Membership → Uncheck HexPal
   - Select `HexPalTests/TestHelpers.swift` (if it exists)
   - File Inspector → Target Membership → Uncheck HexPal

### Alternative: Use Build Phases

If Target Membership isn't visible:

1. **Select HexPal target** (NOT HexPalTests)
2. **Build Phases tab**
3. **Expand "Compile Sources"**
4. **Find any HexPalTests files** (HexPalTests.swift, TestHelpers.swift)
5. **Select them** → Press `Delete` → Choose "Remove"
6. **Verify:** Only App/ and Controllers/ files should be in HexPal's Compile Sources

## Verification

After fixes:
- ✅ HexPal target: No XCTest framework linked
- ✅ HexPal target: No HexPalTests files in Compile Sources
- ✅ HexPalTests target: XCTest framework linked ✅
- ✅ HexPalTests target: HexPalTests files in Compile Sources ✅
- ✅ Build with no warnings (`Cmd+B`)

## Expected Configuration

**HexPal Target:**
- Compile Sources: `App/*.swift`, `Controllers/*.swift`, `Models/*.swift`, etc.
- Link Binary With Libraries: No XCTest

**HexPalTests Target:**
- Compile Sources: `HexPalTests/*.swift`
- Link Binary With Libraries: XCTest.framework ✅
- Dependencies: HexPal target ✅
