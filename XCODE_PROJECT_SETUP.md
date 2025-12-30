# Xcode Project Setup Instructions

This guide will help you create the Xcode project for HEXPal and integrate it with the existing file structure.

## Prerequisites

- macOS 11.0 (Big Sur) or later
- Xcode 14.0 or later
- Swift 5.7 or later

## Step-by-Step Setup

### 1. Create New Xcode Project

1. Open Xcode
2. Select **File → New → Project...**
3. Choose **macOS** tab
4. Select **App** template
5. Click **Next**

### 2. Configure Project Options

- **Product Name:** `HexPal`
- **Team:** Select your Apple Developer team (or None for now)
- **Organization Identifier:** `co.jamcreative` (or your preferred identifier)
- **Bundle Identifier:** Will be auto-generated (e.g., `co.jamcreative.HexPal`)
- **Language:** Swift
- **Interface:** Storyboard (we'll use AppKit programmatically)
- **Use Core Data:** No
- **Include Tests:** Yes

6. Click **Next**
7. **Save Location:** Navigate to `/Users/jordan/Desktop/Business/JAMCreativeConsulting/Products/HEXPal`
8. **Important:** Uncheck "Create Git repository" (we already have one)
9. Click **Create**

### 3. Configure Project Settings

#### 3.1 General Settings

1. Select the **HexPal** project in the navigator
2. Select the **HexPal** target
3. Go to **General** tab:
   - **Deployment Target:** macOS 11.0
   - **App Category:** Utilities

#### 3.2 Info.plist Configuration

1. Go to **Info** tab
2. Verify these keys exist (they should be in the existing `Info.plist`):
   - `LSUIElement` = `YES` (Menu bar only, no dock icon)
   - `NSScreenCaptureUsageDescription` = "HEXPal needs screen recording permission to capture pixel colors from your screen."
   - `NSHighResolutionCapable` = `YES`

#### 3.3 Build Settings

1. Go to **Build Settings** tab
2. Search for "Swift Language Version"
3. Set to **Swift 5** (or latest)
4. Search for "Code Signing"
5. Set **Code Signing Identity** to your team (or "Sign to Run Locally" for development)

### 4. Add Existing Files to Project

The directory structure and initial Swift files have already been created. Add them to the Xcode project:

1. **Right-click** on the project navigator
2. Select **Add Files to "HexPal"...**
3. Navigate to the project directory
4. Select these folders/files (at project root level):
   - `App/AppDelegate.swift`
   - `Controllers/MenuBarController.swift`
   - `Resources/Info.plist`
   - `Models/` (empty directory)
   - `Utilities/` (empty directory)
   - `Views/` (empty directory)
5. **Important:** Check "Copy items if needed" = **NO** (files are already in place)
6. Check "Create groups" (not folder references)
7. Click **Add**

### 5. Organize Project Structure

Create groups in Xcode to match our directory structure:

1. **Delete** the default `AppDelegate.swift` and `ViewController.swift` if Xcode created them
2. **Create groups** (right-click project → New Group):
   - `App`
   - `Controllers`
   - `Models`
   - `Utilities`
   - `Views`
   - `Resources`
3. **Move files** to appropriate groups:
   - `AppDelegate.swift` → `App` group
   - `MenuBarController.swift` → `Controllers` group
   - `Info.plist` → `Resources` group

### 6. Update Info.plist Location

1. Select the **HexPal** target
2. Go to **Build Settings**
3. Search for "Info.plist File"
4. Set to: `HexPal/Resources/Info.plist`

### 7. Configure AppDelegate Entry Point

1. Open `HexPal/App/AppDelegate.swift`
2. Verify it has `@main` attribute (it does)
3. Remove any default `AppDelegate.swift` Xcode created

### 8. Set Up Test Target

1. Select **HexPalTests** target
2. Go to **Build Settings**
3. Ensure **Test Host** is set correctly
4. The test target should automatically reference the main target

### 9. Build and Run

1. Select the **HexPal** scheme
2. Press `Cmd+B` to build
3. Fix any import or compilation errors
4. Press `Cmd+R` to run
5. You should see the HEXPal icon in the menu bar!

## Verification Checklist

- [ ] Project builds without errors
- [ ] App runs and shows menu bar icon
- [ ] Menu bar icon has eyedropper symbol
- [ ] Menu appears when clicking icon
- [ ] "Quit HEXPal" menu item works
- [ ] No dock icon appears (LSUIElement working)
- [ ] File structure matches planned organization
- [ ] SwiftLint configuration is in place

## Next Steps

After successful setup:

1. **Configure SwiftLint:**
   - Install SwiftLint: `brew install swiftlint`
   - The `.swiftlint.yml` file is already in place
   - Add SwiftLint build phase (optional)

2. **Continue Development:**
   - Phase 2: Screen Capture & Color Picking
   - Phase 3: HEX Conversion & Display
   - Phase 4: Global Hotkey Integration

## Troubleshooting

### Menu Bar Icon Not Appearing
- Check that `LSUIElement` is set to `YES` in Info.plist
- Verify `statusItem` is created in `MenuBarController.setupMenuBar()`
- Check console for errors

### Build Errors
- Ensure all files are added to the target
- Check that `@main` is only on `AppDelegate`
- Verify Swift version matches project settings

### Permission Requests
- Screen Recording permission will be requested automatically when we implement screen capture
- Accessibility permission will be requested when we implement global hotkeys

## File Structure Reference

This matches the structure defined in `docs/PLAN.md` (flat structure at project root):

```
HEXPal/                        # Project root directory
├── HEXPal.xcodeproj           # Xcode project (created by Xcode)
├── App/                       # Application entry point (at root level)
│   └── AppDelegate.swift
├── Controllers/               # View controllers and managers (at root level)
│   └── MenuBarController.swift
├── Models/                    # Data models (at root level, empty for now)
├── Utilities/                 # Helper classes and utilities (at root level, empty for now)
├── Views/                     # UI components (at root level, empty for now)
├── Resources/                 # Assets and configuration (at root level)
│   └── Info.plist
├── HEXPalTests/               # Unit tests (at root level)
└── [Other project files]
```

**Note:** This uses a flat structure at the project root level as specified in PLAN.md. When creating the Xcode project, you can organize files into groups (folders) within Xcode without needing nested physical directories.

---

**Note:** This setup creates the foundation for Phase 1. The menu bar will be functional, but color picking functionality will be added in subsequent phases.
