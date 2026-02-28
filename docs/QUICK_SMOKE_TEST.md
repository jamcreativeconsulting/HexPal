# HEXPal - Quick Smoke Test

**Date:** December 31, 2025  
**Tester:** [Your Name]  
**macOS Version:** [Your Version]

## Purpose
Quick validation of core functionality before comprehensive testing.

---

## ✅ Test 1: App Launch & Menu Bar

**Steps:**
1. Build and run the app in Xcode
2. Look for menu bar icon (should appear in top menu bar)

**Expected:**
- ✅ Menu bar icon visible
- ✅ Icon is recognizable
- ✅ No crashes on launch

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## ✅ Test 2: Core Color Picking Workflow

**Steps:**
1. Click menu bar icon → "Pick Color"
2. System color sampler loupe should appear
3. Move mouse over screen
4. Click to select a color
5. Check clipboard

**Expected:**
- ✅ Color picker appears immediately
- ✅ System loupe shows correctly
- ✅ Can pick color from screen
- ✅ HEX code copied to clipboard (format: #RRGGBB)
- ✅ Notification appears with HEX code and color swatch

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

**HEX Code Copied:** ____#BAC9BB________

---

## ✅ Test 3: Hotkey Activation

**Steps:**
1. Switch to a different app (e.g., Finder, Browser)
2. Press ⌘⇧P (Cmd+Shift+P)
3. Color picker should activate

**Expected:**
- ✅ Hotkey works from any app
- ✅ Color picker appears
- ✅ Can pick color normally

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## ✅ Test 4: Recent Colors

**Steps:**
1. Pick 2-3 different colors
2. Click menu bar icon
3. Check "Recent Colors" submenu

**Expected:**
- ✅ "Recent Colors" submenu appears
- ✅ Shows color swatches
- ✅ Most recent color appears first
- ✅ Can click to copy again
- ✅ Notification appears when copying from history

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## ✅ Test 5: Preferences Window

**Steps:**
1. Click menu bar icon → "Preferences..."
2. Preferences window should open

**Expected:**
- ✅ Window opens
- ✅ Window appears in front of other windows
- ✅ Current hotkey displays correctly
- ✅ "Launch at Login" checkbox visible
- ✅ Can close window

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## ✅ Test 6: Notification Interaction

**Steps:**
1. Pick a color (notification appears)
2. Click the notification
3. Hover over notification

**Expected:**
- ✅ Notification appears on correct screen (if multi-monitor)
- ✅ Click notification → re-copies HEX code
- ✅ "⌘V to paste" tooltip appears on click
- ✅ Hover pauses dismiss timer
- ✅ Auto-dismisses after ~2 seconds

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## ✅ Test 7: About Dialog

**Steps:**
1. Click menu bar icon → "About HEXPal"
2. About dialog should appear

**Expected:**
- ✅ Dialog appears
- ✅ Shows copyright "© 2025 HEXPal"
- ✅ Version information visible
- ✅ Can dismiss dialog

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## ✅ Test 8: Quit

**Steps:**
1. Click menu bar icon → "Quit HEXPal"
2. App should quit cleanly

**Expected:**
- ✅ App quits without errors
- ✅ No crash messages
- ✅ Clean exit

**Result:** [x] ✅ Pass | [ ] ❌ Fail | [ ] ⚠️ Issue: _______________

---

## 🐛 Issues Found

| # | Issue | Severity | Notes |
|---|-------|----------|-------|
|   |       |          |       |

---

## 📊 Summary

**Total Tests:** 8  
**Passed:** _8_ / 8  
**Failed:** _0_ / 8  
**Issues:** ___  

**Status:** [x] ✅ Ready for Comprehensive Testing | [ ] ❌ Critical Issues Found

---

## Next Steps

- ✅ **All Passed:** Proceed to comprehensive testing (`TESTING_CHECKLIST.md`)
- ❌ **Issues Found:** Fix critical issues first, then retest
- ⚠️ **Minor Issues:** Document and proceed with comprehensive testing

---

**Notes:**
_________________________________________________
_________________________________________________
_________________________________________________
