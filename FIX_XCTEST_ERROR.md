# Fix "No such module 'XCTest'" Error

## Problem

The HexPalTests target cannot find the XCTest framework, causing build errors.

## Solution: Link XCTest Framework

### Method 1: Add XCTest via Build Phases (Recommended)

1. **Select the HexPal project** (blue icon at top of Project Navigator)
2. **Select the HexPalTests target** (under TARGETS)
3. **Click "Build Phases" tab**
4. **Expand "Link Binary With Libraries"**
5. **Click the "+" button**
6. **Search for "XCTest"**
7. **Select "XCTest.framework"** (or just "XCTest" if shown)
8. **Click "Add"**
9. **Build again** (`Cmd+B`) - should succeed ✅

### Method 2: Verify Test Target Settings

1. **Select HexPalTests target**
2. **Go to "General" tab**
3. **Verify:**
   - **Host Application:** Should be "HexPal"
   - **Test Target:** Should be checked ✅
4. **Go to "Build Settings" tab**
5. **Search for "Framework Search Paths"**
6. **Verify it includes:**
   - `$(SDKROOT)/Developer/Library/Frameworks`
   - `$(inherited)`

### Method 3: Clean Build Folder

Sometimes Xcode's cache causes this issue:

1. **Product menu → Clean Build Folder** (or `Shift+Cmd+K`)
2. **Quit Xcode completely**
3. **Reopen Xcode**
4. **Build again** (`Cmd+B`)

## Verification

After fixing:
- ✅ HexPalTests target builds successfully
- ✅ `import XCTest` works without errors
- ✅ Tests can run (`Cmd+U`)

## Why This Happens

XCTest should be automatically linked for test targets, but sometimes:
- Xcode project template doesn't set it up correctly
- Build settings get misconfigured
- Xcode cache issues

## Additional Notes

- XCTest is part of the macOS SDK, so it should be available
- Test targets automatically get XCTest, but explicit linking ensures it works
- This is a common issue when creating test targets manually or migrating projects
