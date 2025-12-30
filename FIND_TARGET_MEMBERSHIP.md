# How to Find Target Membership in Xcode

## Method 1: File Inspector (Recommended)

1. **Select a file** in Project Navigator (left sidebar)
2. **Open File Inspector** using one of these methods:
   - Press `Option+Cmd+1` (shortcut)
   - **View** menu → **Inspectors** → **File Inspector**
   - Click the **first icon** in the right sidebar (document icon with lines)
3. **Scroll down** in the File Inspector panel
4. **Look for "Target Membership"** section
   - It may be collapsed - click the disclosure triangle to expand
   - You should see checkboxes for each target (HexPal, HexPalTests, etc.)

## Method 2: Get Info Dialog

1. **Select a file** in Project Navigator
2. **Right-click** → **Get Info** (or press `Cmd+I`)
3. **Look for "Target Membership"** in the info window
4. Uncheck the target(s) you want to exclude

## Method 3: Build Phases (Alternative)

If Target Membership isn't visible, use Build Phases:

1. **Select the HexPal project** (blue icon at top of Project Navigator)
2. **Select the HexPal target** (under TARGETS)
3. **Click "Build Phases" tab** (at the top)
4. **Expand "Copy Bundle Resources"**
5. **Find unwanted files** (README.md, LICENSE, etc.)
6. **Select them** → Press `Delete` → Choose "Remove" (not "Delete File")

## Visual Guide

### File Inspector Location:
```
Xcode Window Layout:
┌─────────────┬──────────────────┬──────────────┐
│             │                  │              │
│  Navigator  │   Editor Area    │  Inspector   │
│  (Left)     │    (Center)       │   (Right)    │
│             │                  │              │
│             │                  │ ┌──────────┐│
│             │                  │ │ File     ││ ← Click this tab
│             │                  │ │ Inspector││
│             │                  │ └──────────┘│
│             │                  │             │
│             │                  │ Target      │ ← Scroll down
│             │                  │ Membership  │   to find this
│             │                  │ ☐ HexPal    │
│             │                  │ ☐ Tests     │
└─────────────┴──────────────────┴──────────────┘
```

### Keyboard Shortcuts:
- `Option+Cmd+1` = File Inspector
- `Cmd+I` = Get Info
- `Cmd+0` = Toggle Navigator
- `Option+Cmd+0` = Toggle Inspector

## Troubleshooting

**If Target Membership doesn't appear:**
- Make sure you're viewing the **File Inspector** (not Attributes Inspector or Quick Help)
- Try selecting a **single file** first (not multiple files)
- The section might be collapsed - look for a disclosure triangle (▶)
- Some file types might not show Target Membership - try a `.swift` file first

**If you still can't find it:**
- Use **Method 3 (Build Phases)** instead - it's more reliable
- Or manually edit the project file (advanced, not recommended)
