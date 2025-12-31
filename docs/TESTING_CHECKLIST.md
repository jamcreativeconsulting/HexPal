# HEXPal - Comprehensive Testing Checklist

**Last Updated:** December 31, 2025  
**Status:** Ready for Testing

## Testing Philosophy

- **Test systematically** - Don't skip steps
- **Document issues** - Note any bugs or unexpected behavior
- **Test edge cases** - Don't just test happy paths
- **Verify performance** - Ensure speed targets are met
- **Test gracefully** - Verify error handling works

---

## Pre-Testing Setup

- [x] Clean build (⇧⌘K in Xcode)
- [ ] Latest code pulled from main branch
- [ ] All dependencies resolved
- [ ] No linter errors
- [ ] App builds successfully

---

## 1. Core Functionality Testing

### Color Picking Workflow
- [ ] **Menu Bar Activation**
  - [ ] Click menu bar icon → "Pick Color" works
  - [ ] Menu displays correctly with all items
  - [ ] Hotkey displayed correctly in menu (⌘⇧P)
  
- [ ] **Hotkey Activation**
  - [ ] Press ⌘⇧P from any app → Color picker activates
  - [ ] Hotkey works from Finder
  - [ ] Hotkey works from browser
  - [ ] Hotkey works from code editor
  - [ ] Hotkey works from other apps
  
- [ ] **Color Selection**
  - [ ] NSColorSampler appears when activated
  - [ ] Magnifying glass shows correctly
  - [ ] Can pick color from any screen location
  - [ ] Can pick color from browser content
  - [ ] Can pick color from desktop apps
  - [ ] Can pick color from images
  - [ ] Can cancel color picker (ESC or click outside)
  
- [ ] **HEX Code Output**
  - [ ] HEX code copied to clipboard automatically
  - [ ] HEX format is correct (#RRGGBB)
  - [ ] HEX code is accurate (matches selected color)
  - [ ] Notification appears with correct HEX code
  - [ ] Color swatch matches selected color
  - [ ] Checkmark appears in notification
  
- [ ] **Notification Interaction**
  - [ ] Notification appears on correct screen (multi-monitor)
  - [ ] Fade animation works smoothly
  - [ ] Click notification → re-copies HEX code
  - [ ] "⌘V to paste" tooltip appears on click
  - [ ] Hover pauses dismiss timer
  - [ ] Notification auto-dismisses after 2 seconds

---

## 2. Recent Colors Feature

- [ ] **Color History**
  - [ ] Picked colors appear in "Recent Colors" submenu
  - [ ] Color swatch icons display correctly
  - [ ] Up to 10 colors stored
  - [ ] Most recent color appears first
  - [ ] Duplicate colors moved to front (not duplicated)
  
- [ ] **Recent Colors Interaction**
  - [ ] Click recent color → copies to clipboard
  - [ ] Notification appears when copying from history
  - [ ] "Clear History" works correctly
  - [ ] History persists across app restarts
  - [ ] "No recent colors" shows when empty

---

## 3. Preferences Testing

- [ ] **Preferences Window**
  - [ ] Opens from menu → Preferences...
  - [ ] Window appears in front of other windows
  - [ ] Window displays correctly
  - [ ] Can close window
  
- [ ] **Hotkey Customization**
  - [ ] Current hotkey displays correctly
  - [ ] "Record New Hotkey" works
  - [ ] Can record new hotkey combination
  - [ ] New hotkey saves correctly
  - [ ] New hotkey works immediately
  - [ ] "Reset to Default" works
  - [ ] Reset restores ⌘⇧P
  - [ ] Hotkey updates in menu after change
  
- [ ] **Launch at Login**
  - [ ] Checkbox displays current state
  - [ ] Toggle works (enable/disable)
  - [ ] Preference persists across restarts
  - [ ] App launches at login when enabled (test after restart)
  - [ ] App doesn't launch when disabled

---

## 4. Permission Testing

### Screen Recording Permission
- [ ] **Permission Request**
  - [ ] Permission requested when needed
  - [ ] Clear instructions shown if denied
  - [ ] "Open System Settings" button works
  - [ ] App handles denial gracefully
  
- [ ] **Without Permission**
  - [ ] Error message appears when trying to pick color
  - [ ] Error message is clear and helpful
  - [ ] App doesn't crash
  - [ ] Can still use app (menu works)
  
- [ ] **With Permission**
  - [ ] Color picker works normally
  - [ ] No error messages
  - [ ] Smooth operation

### Accessibility Permission
- [ ] **Permission Request**
  - [ ] Permission requested on app launch (if needed)
  - [ ] Clear instructions shown
  - [ ] "Open System Settings" button works
  
- [ ] **Without Permission**
  - [ ] Hotkey doesn't work globally
  - [ ] Error message explains situation
  - [ ] App still works via menu bar
  - [ ] No crashes
  
- [ ] **With Permission**
  - [ ] Hotkey works from any app
  - [ ] No error messages
  - [ ] Smooth operation

---

## 5. Multi-Display Testing

- [ ] **Multiple Displays**
  - [ ] Pick color on primary display → notification on correct screen
  - [ ] Pick color on secondary display → notification on correct screen
  - [ ] Pick color on third display → notification on correct screen
  - [ ] Works with displays in different orientations
  - [ ] Works with displays at different resolutions
  
- [ ] **Display Configurations**
  - [ ] Mirrored displays
  - [ ] Extended desktop
  - [ ] Different DPI settings
  - [ ] Different color profiles per display

---

## 6. Color Profile Testing

- [ ] **Different Color Profiles**
  - [ ] sRGB display profile
  - [ ] P3 display profile
  - [ ] Custom color profiles
  - [ ] HEX codes accurate across profiles
  
- [ ] **Color Accuracy**
  - [ ] Picked color matches source pixel
  - [ ] HEX code matches expected value
  - [ ] Color swatch matches selected color

---

## 7. Performance Testing

- [ ] **Speed Targets**
  - [ ] Activation time < 100ms (hotkey to picker ready)
  - [ ] Total workflow < 2 seconds (activation to HEX in clipboard)
  - [ ] Notification appears quickly
  - [ ] Menu responds instantly
  
- [ ] **Resource Usage**
  - [ ] Memory usage < 50MB RAM (check Activity Monitor)
  - [ ] CPU usage < 1% when idle
  - [ ] CPU usage < 5% when active
  - [ ] No memory leaks (test over extended period)

---

## 8. Error Handling Testing

- [ ] **Permission Errors**
  - [ ] Screen Recording denied → clear error message
  - [ ] Accessibility denied → clear error message
  - [ ] Error messages are user-friendly
  - [ ] System Settings links work
  
- [ ] **Operation Errors**
  - [ ] Clipboard copy failure → error shown
  - [ ] Hotkey registration failure → error shown
  - [ ] Launch at login failure → error shown
  - [ ] All errors are recoverable (app doesn't crash)
  
- [ ] **Edge Cases**
  - [ ] No displays connected (shouldn't happen, but handle gracefully)
  - [ ] Invalid color data (shouldn't happen, but handle gracefully)
  - [ ] App launched without permissions (should request)

---

## 9. macOS Version Testing

Test on different macOS versions if available:

- [ ] **macOS 10.15 (Catalina)**
  - [ ] App launches correctly
  - [ ] All features work
  - [ ] Permissions work correctly
  
- [ ] **macOS 11 (Big Sur)**
  - [ ] App launches correctly
  - [ ] All features work
  - [ ] Permissions work correctly
  
- [ ] **macOS 12 (Monterey)**
  - [ ] App launches correctly
  - [ ] All features work
  - [ ] Permissions work correctly
  
- [ ] **macOS 13 (Ventura)**
  - [ ] App launches correctly
  - [ ] All features work
  - [ ] SMAppService works for launch at login
  
- [ ] **macOS 14 (Sonoma)**
  - [ ] App launches correctly
  - [ ] All features work
  - [ ] SMAppService works for launch at login
  
- [ ] **macOS 15 (Sequoia)**
  - [ ] App launches correctly
  - [ ] All features work
  - [ ] SMAppService works for launch at login

---

## 10. User Experience Testing

- [ ] **First Launch**
  - [ ] Welcome notification appears
  - [ ] Welcome notification shows correct hotkey
  - [ ] Welcome notification can be dismissed
  - [ ] Welcome notification doesn't appear again
  
- [ ] **Menu Bar**
  - [ ] Icon is visible and recognizable
  - [ ] Menu is intuitive
  - [ ] All menu items work
  - [ ] Menu items are properly enabled/disabled
  
- [ ] **About Dialog**
  - [ ] "About HEXPal" opens dialog
  - [ ] Copyright shows 2025
  - [ ] Version information correct
  - [ ] "Visit GitHub" button works
  
- [ ] **Quit**
  - [ ] "Quit HEXPal" works
  - [ ] App quits cleanly
  - [ ] No crashes on quit

---

## 11. Integration Testing

- [ ] **Clipboard Integration**
  - [ ] HEX code pastes correctly in text editors
  - [ ] HEX code pastes correctly in design tools
  - [ ] HEX code pastes correctly in code editors
  - [ ] Clipboard doesn't interfere with other apps
  
- [ ] **System Integration**
  - [ ] App doesn't interfere with other apps
  - [ ] Hotkey doesn't conflict with system shortcuts
  - [ ] App respects system dark mode
  - [ ] App respects system accessibility settings

---

## 12. Stress Testing

- [ ] **Rapid Color Picking**
  - [ ] Pick 20 colors rapidly → no crashes
  - [ ] Memory usage stays reasonable
  - [ ] Performance doesn't degrade
  
- [ ] **Extended Use**
  - [ ] Leave app running for 1+ hour
  - [ ] Memory usage stays stable
  - [ ] No memory leaks
  - [ ] Performance remains good
  
- [ ] **Multiple Activations**
  - [ ] Activate color picker 50+ times
  - [ ] No performance degradation
  - [ ] No crashes

---

## 13. Regression Testing

- [ ] **Previously Fixed Issues**
  - [ ] Menu bar icon appears (was fixed)
  - [ ] No "task name port right" errors (was fixed)
  - [ ] Notification doesn't crash (was fixed)
  - [ ] About dialog works (was fixed)
  - [ ] Preferences window appears in front (was fixed)

---

## Testing Results Template

For each test category, document:

```
**Category:** [Name]
**Date:** [Date]
**Tester:** [Name]
**macOS Version:** [Version]
**Results:**
- ✅ Passed: [List]
- ❌ Failed: [List with details]
- ⚠️ Issues Found: [List with details]
- 📝 Notes: [Any observations]
```

---

## Known Issues Log

| Issue | Description | Severity | Status | Notes |
|-------|-------------|----------|--------|-------|
| | | | | |

---

## Next Steps After Testing

1. **Fix Critical Issues** - Address any crashes or data loss bugs
2. **Fix High-Priority Issues** - Address usability issues
3. **Document Known Limitations** - Note any acceptable limitations
4. **Prepare Release Notes** - Document what's new in v1.0
5. **Tag Release** - Create v1.0 tag in Git
6. **Distribution** - Prepare for distribution (if applicable)

---

**Testing Priority:**
1. **Critical:** Core functionality, permissions, crashes
2. **High:** Performance, multi-display, error handling
3. **Medium:** Different macOS versions, edge cases
4. **Low:** Stress testing, extended use
