# HEXPal - Development Plan

## Executive Summary

**HEXPal** is a lightweight, free, and open-source macOS menu bar application that allows users to pick any pixel color from their screen and instantly get its HEX code. Built with a **speed-first philosophy**, HEXPal optimizes for the most common use case: getting HEX codes quickly while coding or designing.

**Core Value Proposition:** "Pick any color. Get HEX. Instantly. Free forever."

**Differentiation:** Fastest workflow, free & open source, developer-focused, system-wide access.

---

## Platform & Technology Decision

### ✅ Recommended: macOS Menu Bar Application

**Why Menu Bar App?**
- ✅ System-wide access - works across all applications, windows, and images
- ✅ Always accessible from menu bar - no need to switch apps
- ✅ Can use global keyboard shortcuts for instant activation
- ✅ Native macOS integration and performance
- ✅ Minimal UI footprint - stays out of the way

**Why NOT Chrome Extension?**
- ❌ Limited to browser content only
- ❌ Cannot access pixels outside the browser
- ❌ Cannot pick colors from desktop apps, images, or other windows

**Why NOT Cross-Platform (Electron)?**
- ❌ Heavier resource usage
- ❌ Less native feel
- ❌ More complex for a simple utility
- ❌ Conflicts with speed-first philosophy (< 2 second workflow harder to achieve)
- ❌ User is on macOS, so native is optimal

**Windows Support Strategy:**
- Start with macOS-only for faster MVP and better performance
- Evaluate Windows support after macOS version succeeds
- See `docs/PLATFORM_STRATEGY.md` for detailed analysis

### Technology Stack

**Language:** Swift  
**Framework:** AppKit (macOS native UI framework)  
**Graphics:** Core Graphics / Quartz (for screen capture and color extraction)  
**Development Environment:** Xcode  
**Distribution:** Direct download or Mac App Store

---

## Feature Requirements

### Core Features (MVP) - Speed-First Design
**Goal: Get HEX codes in under 2 seconds**

1. **Menu Bar Icon** - Always visible, minimal design
2. **Global Hotkey Activation** - Default: Cmd+Shift+C (quick, non-conflicting)
3. **Screen Color Picker** - Click anywhere on screen to select pixel
4. **HEX Code Display** - Show HEX code immediately (primary format)
5. **Automatic Clipboard Copy** - Copy HEX to clipboard instantly (no manual step)
6. **Visual Feedback** - Magnifying glass with pixel grid for precise selection
7. **Instant Activation** - < 100ms response time from hotkey to picker ready

### V1.1 Features - Developer Workflow
1. **Color History** - Last 10 picks accessible quickly
2. **Format Toggle** - Quick switch between HEX, RGB, HSL (HEX is default)
3. **Customizable Hotkey** - User-defined keyboard shortcut
4. **Copy Format Options** - With/without #, uppercase/lowercase

### V2.0 Features - Advanced (If Needed)
1. **Color Palette Management** - Save and organize colors
2. **Contrast Checker** - WCAG accessibility checking
3. **Export Options** - Copy as CSS variables, Swift UIColor, etc.
4. **Color Name Detection** - Show closest named color

### V2.1+ Features - AI-Enhanced (Future)
See `docs/PRE_SETUP_CONSIDERATIONS.md` for detailed AI enhancement ideas:
- Color name detection (local ML)
- Color palette suggestions
- Accessibility checker
- Color harmony detection
- Smart color matching
- Color blindness simulation

**Design Philosophy:** Do one thing exceptionally well (get HEX codes fast). Don't bloat with features users don't need. AI features must add clear value without slowing down core workflow.

---

## Technical Architecture

### Core Components

1. **MenuBarController**
   - Manages menu bar icon and dropdown menu
   - Handles menu item clicks and state

2. **ColorPickerController**
   - Manages screen capture and pixel selection
   - Handles mouse tracking and cursor overlay
   - Implements magnifying glass view

3. **ColorConverter**
   - Converts pixel color data to HEX format
   - Handles color space conversions
   - Format validation

4. **ClipboardManager**
   - Copies HEX code to clipboard
   - Manages clipboard state

5. **HotkeyManager**
   - Registers global keyboard shortcut
   - Handles hotkey activation
   - Manages accessibility permissions

6. **ColorHistoryManager** (Post-MVP)
   - Stores recent colors
   - Persists to UserDefaults
   - Manages color list UI

### Key macOS APIs

- **AppKit** - Menu bar, windows, UI components
- **Core Graphics** - Screen capture (`CGWindowListCreateImage`)
- **Quartz** - Pixel color extraction
- **Carbon/Cocoa** - Global hotkey registration
- **Accessibility** - Screen capture permissions

---

## Development Phases

### Phase 1: Project Setup & Foundation (Day 1)

**Tasks:**
1. Create new Xcode project (macOS App)
2. Configure app for menu bar only (no dock icon)
3. Set up project structure and file organization
4. Configure Info.plist for necessary permissions:
   - Screen Recording permission
   - Accessibility permission (for global hotkeys)
5. Create basic menu bar icon and menu

**Deliverables:**
- Xcode project structure
- Menu bar icon visible
- Basic menu with "Pick Color" option

---

### Phase 2: Screen Capture & Color Picking (Day 2-3)

**Tasks:**
1. Implement screen capture functionality
   - Use `CGWindowListCreateImage` to capture screen
   - Handle multiple displays
2. Create color picker overlay
   - Full-screen overlay window
   - Mouse tracking
   - Cursor change to crosshair
3. Implement magnifying glass view
   - Zoom around cursor (e.g., 10x magnification)
   - Show pixel grid
   - Display current pixel color preview
4. Extract pixel color from captured image
   - Get color at cursor position
   - Handle color space conversion

**Deliverables:**
- Working screen color picker
- Magnifying glass overlay
- Accurate pixel color extraction

---

### Phase 3: HEX Conversion & Display (Day 3-4)

**Tasks:**
1. Implement color to HEX conversion
   - RGB to HEX conversion
   - Handle alpha channel (if needed)
   - Format validation
2. Create result display UI
   - Popover or notification window
   - Show HEX code prominently
   - Display color swatch
   - Copy button
3. Implement clipboard functionality
   - Copy HEX code to clipboard
   - Show copy confirmation

**Deliverables:**
- HEX code display
- Clipboard copy working
- Visual feedback on selection

---

### Phase 4: Global Hotkey Integration (Day 4-5)

**Tasks:**
1. Research and implement global hotkey library
   - Options: Carbon API, MASShortcut, or HotKey library
   - Register hotkey (default: Cmd+Shift+C)
2. Handle hotkey activation
   - Trigger color picker from anywhere
   - Handle conflicts with other apps
3. Add hotkey customization UI (optional)
   - Settings menu item
   - Hotkey picker interface

**Deliverables:**
- Global hotkey working
- Can activate from any app
- Hotkey customization (if time permits)

---

### Phase 5: Polish & Testing (Day 5-6)

**Tasks:**
1. UI/UX refinements
   - Menu bar icon design
   - Smooth animations
   - Visual feedback improvements
2. Error handling
   - Permission request handling
   - Error messages for users
   - Graceful degradation
3. Testing
   - Test on different macOS versions
   - Test with multiple displays
   - Test with different color profiles
   - Performance testing
4. Code cleanup
   - Comments and documentation
   - Code organization
   - Remove debug code

**Deliverables:**
- Polished, production-ready app
- Comprehensive error handling
- Tested across scenarios

---

### Phase 6: Distribution Preparation (Day 6-7)

**Tasks:**
1. App icon design
   - 16x16 menu bar icon
   - 512x512 app icon
   - Various sizes for App Store
2. Code signing
   - Apple Developer account setup
   - Code signing configuration
   - Notarization (if distributing outside App Store)
3. Build configuration
   - Release build settings
   - Archive creation
   - DMG creation (if direct distribution)
4. Documentation
   - README.md
   - User guide
   - Installation instructions

**Deliverables:**
- Signed and notarized app
- Distribution package
- Documentation

---

## File Structure

```
HEXPal/                          # Project root directory
├── HEXPal.xcodeproj             # Xcode project file
├── App/                          # Application entry point
│   ├── AppDelegate.swift
│   └── App.swift
├── Controllers/                  # View controllers and managers
│   ├── MenuBarController.swift
│   ├── ColorPickerController.swift
│   └── HotkeyManager.swift
├── Models/                       # Data models
│   ├── ColorModel.swift
│   └── ColorHistory.swift
├── Utilities/                    # Helper classes and utilities
│   ├── ColorConverter.swift
│   ├── ClipboardManager.swift
│   └── ScreenCapture.swift
├── Views/                        # UI components
│   ├── ColorPickerOverlay.swift
│   ├── MagnifyingGlassView.swift
│   └── ColorResultView.swift
├── Resources/                    # Assets and configuration
│   ├── Assets.xcassets/
│   └── Info.plist
├── HEXPalTests/                  # Unit tests
├── .cursor/                       # Cursor IDE configuration
│   └── rules/                     # Project Rules (MDC format)
│       ├── core-principles.mdc
│       ├── swift-code-standards.mdc
│       ├── file-size-limits.mdc
│       ├── documentation-standards.mdc
│       ├── performance-requirements.mdc
│       ├── macos-guidelines.mdc
│       ├── testing.mdc
│       ├── feature-development.mdc
│       ├── security-privacy.mdc
│       └── maintenance.mdc
├── docs/                         # Documentation directory
│   ├── PLAN.md
│   ├── COMPETITIVE_ANALYSIS.md
│   ├── PLATFORM_STRATEGY.md
│   ├── PRE_SETUP_CONSIDERATIONS.md
│   ├── CODING_STYLE.md
│   ├── MCP_STRATEGY.md
│   ├── MCP_QUICK_REFERENCE.md
│   └── RESEARCH_SUMMARY.md
├── .github/                      # GitHub configuration
│   └── workflows/
│       └── ci.yml                # CI/CD workflow
├── README.md                     # Main project README
├── LICENSE                       # MIT License
└── CONTRIBUTING.md               # Contributing guidelines
```

**Note:** This uses a flat structure at the project root level. When creating the Xcode project, you can organize files into groups (folders) within Xcode without needing nested physical directories. The important part is logical grouping (App/, Controllers/, Models/, etc.) for code organization and maintainability.

**Documentation:** All project documentation is organized in the `docs/` directory for easy access and maintenance.

---

## Key Implementation Details

### Screen Capture
```swift
// Pseudo-code for screen capture
func captureScreen() -> CGImage? {
    let displayID = CGMainDisplayID()
    return CGDisplayCreateImage(displayID)
}
```

### Color Extraction
```swift
// Pseudo-code for pixel color extraction
func getColorAt(point: CGPoint, from image: CGImage) -> NSColor {
    // Extract pixel data at point
    // Convert to NSColor
    // Return color
}
```

### Global Hotkey
- Use Carbon API or third-party library like `MASShortcut`
- Register hotkey on app launch
- Handle activation callback

### Permissions Required
- **Screen Recording**: Required for capturing screen content
- **Accessibility**: Required for global hotkey registration (on newer macOS)

---

## User Experience Flow (Speed-Optimized)

1. **Launch App** (One-time setup)
   - App appears in menu bar only (no dock icon)
   - Menu bar icon visible
   - Request permissions if needed (clear instructions)

2. **Activate Color Picker** (< 100ms)
   - User presses global hotkey (Cmd+Shift+C)
   - **OR** clicks menu bar icon → "Pick Color"
   - Instant activation, no delay

3. **Select Color** (< 1 second)
   - Full-screen overlay appears instantly
   - Cursor changes to crosshair
   - Magnifying glass follows cursor (10x zoom, pixel grid)
   - Real-time HEX preview as cursor moves
   - User clicks to select pixel

4. **Get HEX Code** (< 0.5 seconds)
   - HEX code displayed prominently in popover/notification
   - **Automatically copied to clipboard** (no manual copy needed)
   - Color swatch shown
   - Brief visual confirmation (subtle animation)

5. **Continue** (Zero friction)
   - User can immediately pick another color (overlay stays active)
   - Or press Escape to dismiss
   - HEX code already in clipboard, ready to paste

**Total Time: < 2 seconds from activation to HEX code in clipboard**

---

## Potential Challenges & Solutions

### Challenge 1: Screen Recording Permissions
**Issue:** macOS requires explicit user permission for screen recording  
**Solution:** 
- Request permission on first launch
- Show clear instructions if permission denied
- Provide settings link to System Preferences

### Challenge 2: Global Hotkey Conflicts
**Issue:** Hotkey might conflict with other apps  
**Solution:**
- Allow user to customize hotkey
- Check for conflicts and warn user
- Provide alternative activation methods

### Challenge 3: Multi-Display Support
**Issue:** Need to capture correct display  
**Solution:**
- Detect which display cursor is on
- Capture that specific display
- Handle coordinate conversion

### Challenge 4: Color Profile Accuracy
**Issue:** Colors may vary based on display color profile  
**Solution:**
- Use display's native color space
- Convert to sRGB for HEX representation
- Document color accuracy limitations

---

## Success Metrics

### Performance Metrics (Critical)
- ✅ **Activation time:** < 100ms from hotkey to picker ready
- ✅ **Total workflow:** < 2 seconds from activation to HEX in clipboard
- ✅ **Memory usage:** < 50MB RAM
- ✅ **CPU usage:** < 1% when idle, < 5% when active

### Quality Metrics
- ✅ Can pick color from any screen location (system-wide)
- ✅ HEX code accuracy: 100% match with source pixel
- ✅ Works across all applications
- ✅ Hotkey reliability: 99.9%+ success rate
- ✅ Crash rate: < 0.1%

### User Experience Metrics
- ✅ Zero configuration required (works out of box)
- ✅ Clear permission handling (no confusion)
- ✅ Visual feedback at every step
- ✅ No learning curve (intuitive)

### Differentiation Metrics
- ✅ Faster than ColorSnapper, Color Slurp, Pika
- ✅ Free (vs. $10-15 paid alternatives)
- ✅ Open source (transparency, community)
- ✅ Developer-focused workflow

---

## Timeline Estimate

**Total Development Time: 5-7 days**

- Phase 1: 1 day
- Phase 2: 2 days
- Phase 3: 1 day
- Phase 4: 1 day
- Phase 5: 1 day
- Phase 6: 1 day

**Note:** This assumes 4-6 hours of focused development per day. Actual time may vary based on experience level and feature scope.

---

## Differentiation Strategy

See `docs/COMPETITIVE_ANALYSIS.md` for detailed competitive research.

**Key Differentiators:**
1. **Speed-First:** Optimized for < 2 second workflow
2. **Free & Open Source:** No paywall, community-driven
3. **Developer-Focused:** HEX-first, code-ready output
4. **Reliable:** Rock-solid hotkey, no bugs
5. **Simple:** Zero configuration, smart defaults

**Positioning:** "The Fast & Free Alternative" to paid color pickers

---

## Next Steps

### ✅ Completed Planning Phase
1. ✅ Review competitive analysis
2. ✅ Define differentiation strategy
3. ✅ Update development plan with speed-first focus
4. ✅ Review pre-setup considerations
5. ✅ Create comprehensive project documentation
6. ✅ Set up project rules and standards

### ✅ Completed Pre-Setup Phase (Partial)
1. ✅ Set up GitHub repository (https://github.com/jamcreativeconsulting/HexPal)
2. ✅ Create open source foundation files:
   - ✅ LICENSE (MIT)
   - ✅ README.md
   - ✅ CONTRIBUTING.md
   - ✅ CODE_OF_CONDUCT.md
   - ✅ .gitignore
3. ✅ Initialize Git repository
4. ✅ Push code to GitHub

### ⏭️ Next Phase: Complete Pre-Setup & Project Initialization
**See:** `docs/PRE_SETUP_CONSIDERATIONS.md` for complete checklist

**Immediate Next Steps:**
1. Set up CI/CD workflow (.github/workflows/ci.yml)
2. Create GitHub issue templates (.github/ISSUE_TEMPLATE/)
3. Set up Xcode project with proper structure
4. Configure SwiftLint and code quality tools (.swiftlint.yml)
5. Configure code signing
6. Set up testing framework

**After Pre-Setup:**
8. Begin Phase 1 implementation (Project Setup & Foundation)
9. Iterate based on testing and feedback
10. Gather early user feedback for validation

**For New Chat Sessions:** See `docs/PROJECT_SUMMARY.md` for complete context and overview.

---

## References & Resources

### MCP (Model Context Protocol) Integration

**Primary MCP: Context7**
- **Purpose:** Up-to-date Swift and framework documentation
- **Library:** `/swiftlang/swift` - Swift language documentation
- **Usage:** Query for code examples, best practices, and patterns
- **Configuration:** See `MCP_STRATEGY.md` for setup details

**Secondary MCP: Sequential Thinking**
- **Purpose:** Complex problem-solving and architecture decisions
- **Usage:** Break down complex technical challenges

**See `docs/MCP_STRATEGY.md` for complete MCP strategy and configuration.**

### Documentation Resources

**Primary Sources:**
- [Apple AppKit Documentation](https://developer.apple.com/documentation/appkit)
- [Core Graphics Screen Capture](https://developer.apple.com/documentation/coregraphics/quartz_window_services)
- [Swift Language Documentation](https://docs.swift.org/) - Via Context7 MCP

**Code Libraries:**
- [MASShortcut](https://github.com/shpakovski/MASShortcut) - Global hotkey library
- [macOS Menu Bar App Tutorial](https://www.raywenderlich.com/)

**Apple Resources:**
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [WWDC Sessions](https://developer.apple.com/videos/) - Search for "menu bar" and "screen capture"

---

**Last Updated:** December 2024  
**Status:** Pre-Setup Phase - Open Source Foundation Complete ✅  
**Next Milestone:** Complete Pre-Setup (CI/CD, Issue Templates) → Xcode Project Setup
