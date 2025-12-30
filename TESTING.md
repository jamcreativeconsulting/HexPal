# Testing HEXPal

## Running the Application

### Method 1: Run in Xcode (Recommended for Development)

1. **Select the HexPal scheme** (top toolbar, next to the play button)
   - Should show "HexPal > My Mac"

2. **Press `Cmd+R`** (or click the Play button)
   - Xcode will build and launch the app

3. **What to expect:**
   - ✅ App launches silently (no dock icon - menu bar only)
   - ✅ Look for the HEXPal icon in your **menu bar** (top right of screen)
   - ✅ Click the menu bar icon to see the menu
   - ✅ Menu should show: "Pick Color", "Preferences", "About HEXPal", "Quit HEXPal"

4. **To stop the app:**
   - Click menu bar icon → "Quit HEXPal"
   - OR: In Xcode, click the Stop button (square icon)

### Method 2: Run Built App Directly

1. **Build the app** (`Cmd+B` in Xcode)
2. **Find the built app:**
   - Right-click on "HexPal.app" in Products folder (Project Navigator)
   - Select "Show in Finder"
   - Or navigate to: `~/Library/Developer/Xcode/DerivedData/HexPal-*/Build/Products/Debug/HexPal.app`
3. **Double-click** `HexPal.app` to launch
4. **First launch:** macOS may ask for permissions (Screen Recording, Accessibility)

## Running Unit Tests

### Run All Tests

1. **Select the HexPal scheme** (top toolbar)
2. **Press `Cmd+U`** (or Product → Test)
   - Xcode will build and run all tests
   - Results appear in Test Navigator (left sidebar, test icon)

### Run Individual Tests

1. **Open Test Navigator** (`Cmd+6`)
2. **Click the play button** next to:
   - A specific test method
   - A test class
   - The entire test suite

### View Test Results

- **Test Navigator** (`Cmd+6`): Shows all tests with pass/fail status
- **Report Navigator** (`Cmd+9`): Shows detailed test reports
- **Console**: Shows test output and any print statements

## Current Test Coverage

### HexPalTests Target

**HexPalTests.swift:**
- `testExample()` - Basic test to verify framework works
- `testExamplePerformance()` - Performance test template

**TestHelpers.swift:**
- Color testing utilities (when implemented)
- Performance assertion helpers

## What's Currently Implemented

### ✅ Working Features

1. **Menu Bar App**
   - Menu bar icon appears
   - Menu with basic items
   - Menu bar only (no dock icon) - `LSUIElement = YES`

2. **Menu Items**
   - Pick Color (stubbed - not yet implemented)
   - Preferences (stubbed)
   - About HEXPal (stubbed)
   - Quit HEXPal (works)

### ⚠️ Not Yet Implemented

- Color picking functionality
- Screen capture
- HEX code conversion
- Clipboard integration
- Global hotkeys
- Preferences window

## Testing Checklist

### Basic Functionality

- [ ] App launches without errors
- [ ] Menu bar icon appears
- [ ] Menu opens when clicking icon
- [ ] "Quit HEXPal" works
- [ ] No dock icon appears (menu bar only)

### Permissions (Future)

When color picking is implemented:
- [ ] Screen Recording permission requested
- [ ] Permission denial handled gracefully
- [ ] Accessibility permission (for hotkeys)

### Performance (Future)

When features are implemented:
- [ ] Activation time < 100ms
- [ ] Total workflow < 2 seconds
- [ ] Memory usage < 50MB

## Debugging Tips

### View Console Output

1. **In Xcode:** View → Debug Area → Show Debug Area (`Cmd+Shift+Y`)
2. **Console.app:** Open Console.app to see system logs
   - Filter by "HexPal" to see app-specific logs

### Check Menu Bar Icon

- Look in the **top-right corner** of your screen
- Menu bar icons appear between the time and Spotlight icon
- If you don't see it, check if it's hidden (click and hold the menu bar separator)

### Common Issues

**App doesn't appear:**
- Check Console.app for errors
- Verify `LSUIElement = YES` in Info.plist
- Check that menu bar icon is being created in `MenuBarController`

**Menu doesn't work:**
- Check Xcode console for errors
- Verify `MenuBarController.setupMenuBar()` is called in `AppDelegate`

**Tests fail:**
- Check that HexPalTests target is selected
- Verify XCTest framework is linked
- Check test target membership

## Next Steps

Once basic testing is confirmed:
1. Implement color picking functionality
2. Add screen capture
3. Implement HEX conversion
4. Add clipboard integration
5. Test end-to-end workflow
