# Quick Xcode Project Creation Guide

This is a streamlined guide for creating the HEXPal Xcode project. For detailed instructions, see `XCODE_PROJECT_SETUP.md`.

## Quick Start (5 minutes)

### Step 1: Validate Setup
```bash
./create_xcode_project.sh
```

This will verify all files are in place before creating the project.

### Step 2: Create Project in Xcode

1. **Open Xcode** (Cmd+Space, type "Xcode")

2. **Create New Project:**
   - File → New → Project... (or Cmd+Shift+N)
   - Choose **macOS** tab
   - Select **App** template
   - Click **Next**

3. **Configure Project:**
   ```
   Product Name: HexPal
   Team: [Your team or None]
   Organization Identifier: co.jamcreative
   Bundle Identifier: co.jamcreative.HexPal (auto-generated)
   Language: Swift
   Interface: Storyboard (we'll use AppKit programmatically)
   Use Core Data: ❌ No
   Testing System: ✅ XCTest for Unit and UI Tests
   ```
   
   **Important:** Select "XCTest for Unit and UI Tests" (not "None" or "Swift Testing"). 
   We're using XCTest framework for our test suite (HexPalTests.swift).

4. **Save Location:**
   - Navigate to: `/Users/jordan/Desktop/Business/JAMCreativeConsulting/Products/HEXPal`
   - **Important:** Uncheck "Create Git repository" ✅
   - Click **Create**

### Step 3: Configure Project Settings

1. **Select HexPal project** in navigator (blue icon at top)

2. **Select HexPal target** (under TARGETS)

3. **General Tab:**
   - Deployment Target: **macOS 11.0**
   - App Category: **Utilities**

4. **Info Tab:**
   - Delete the default Info.plist entry (we have our own)
   - The existing `Resources/Info.plist` will be used

5. **Build Settings Tab:**
   - Search "Info.plist File" → Set to: `Resources/Info.plist`
   - Search "Swift Language Version" → Set to: **Swift 5**
   - Search "Code Signing" → Set to: **Sign to Run Locally** (for development)

### Step 4: Add Existing Files

1. **Delete default files** Xcode created:
   - Right-click `AppDelegate.swift` → Delete → Move to Trash
   - Right-click `ViewController.swift` → Delete → Move to Trash
   - Right-click `Main.storyboard` → Delete → Move to Trash (we use programmatic UI)

2. **Add existing files:**
   - Right-click project root → **Add Files to "HexPal"...**
   - Select these (at project root level):
     - `App/` folder
     - `Controllers/` folder
     - `Models/` folder
     - `Utilities/` folder
     - `Views/` folder
     - `Resources/` folder
   - **Options:**
     - ✅ Create groups (not folder references)
     - ❌ Copy items if needed (files already exist)
   - Click **Add**

3. **Add test files:**
   - Right-click `HexPalTests` group → **Add Files to "HexPal"...**
   - Select `HexPalTests/` folder
   - Same options as above
   - Click **Add**

### Step 5: Verify Structure

Your project navigator should look like:
```
HexPal (project)
├── HexPal (target)
│   ├── App
│   │   └── AppDelegate.swift
│   ├── Controllers
│   │   └── MenuBarController.swift
│   ├── Models (empty)
│   ├── Utilities (empty)
│   ├── Views (empty)
│   └── Resources
│       └── Info.plist
└── HexPalTests (target)
    ├── HexPalTests.swift
    └── TestHelpers.swift
```

### Step 6: Build and Run

1. **Select HexPal scheme** (top toolbar, next to stop button)

2. **Build:** Press `Cmd+B`
   - Should build successfully ✅
   - Fix any errors if they appear

3. **Run:** Press `Cmd+R`
   - App should launch
   - Look for HEXPal icon in menu bar (eyedropper symbol)
   - Click icon to see menu

### Step 7: Verify Menu Bar

- ✅ Menu bar icon appears (eyedropper symbol)
- ✅ Clicking icon shows menu
- ✅ "Quit HEXPal" menu item works
- ✅ No dock icon appears (LSUIElement working)

## Troubleshooting

### "Cannot find 'MenuBarController' in scope"
- Ensure `MenuBarController.swift` is added to the HexPal target
- Select file → File Inspector → Target Membership → ✅ HexPal

### "Multiple '@main' attributes"
- Ensure only `AppDelegate.swift` has `@main`
- Delete any default AppDelegate Xcode created

### Menu bar icon doesn't appear
- Check Console for errors (View → Debug Area → Activate Console)
- Verify `LSUIElement` is YES in Info.plist
- Ensure `MenuBarController.setupMenuBar()` is called

### Build errors
- Clean build folder: Product → Clean Build Folder (Cmd+Shift+K)
- Restart Xcode if needed
- Check all files are added to correct target

## Next Steps

After successful setup:

1. ✅ Project builds and runs
2. ✅ Menu bar icon appears
3. ✅ Ready for Phase 1 development

Continue with:
- Phase 2: Screen Capture & Color Picking
- Phase 3: HEX Conversion & Display
- Phase 4: Global Hotkey Integration

---

**Need help?** See `XCODE_PROJECT_SETUP.md` for detailed instructions.
