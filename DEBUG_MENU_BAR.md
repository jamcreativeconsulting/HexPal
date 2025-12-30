# Debug Menu Bar Icon Not Appearing

## Quick Checks

### 1. Check Xcode Console Output

1. **In Xcode**, look at the **bottom panel** (Debug Area)
2. **Press `Cmd+Shift+Y`** to show/hide Debug Area if needed
3. **Look for:**
   - Any error messages
   - "Error: Failed to create status item" message
   - Any crash logs

### 2. Check if App is Actually Running

1. **Open Activity Monitor** (Applications → Utilities → Activity Monitor)
2. **Search for "HexPal"**
3. **Check if process exists:**
   - ✅ Process exists = App is running
   - ❌ No process = App crashed on launch

### 3. Check Menu Bar Icon Location

The icon appears in the **top-right corner** of your screen:
- Look between the **time/date** and **Spotlight icon**
- Menu bar icons can be hidden - try **clicking and holding** the menu bar separator
- Some icons appear in the **Control Center** area (macOS 11+)

### 4. Verify Code is Executing

Add debug prints to verify code runs:

**In AppDelegate.swift:**
```swift
func applicationDidFinishLaunching(_ aNotification: Notification) {
    print("✅ AppDelegate: applicationDidFinishLaunching called")
    configureMenuBarOnlyMode()
    
    print("✅ AppDelegate: Creating MenuBarController")
    menuBarController = MenuBarController()
    
    print("✅ AppDelegate: Calling setupMenuBar()")
    menuBarController?.setupMenuBar()
    
    print("✅ AppDelegate: Setup complete")
    requestPermissions()
}
```

**In MenuBarController.swift:**
```swift
func setupMenuBar() {
    print("✅ MenuBarController: setupMenuBar() called")
    
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    guard let statusItem = statusItem else {
        print("❌ ERROR: Failed to create status item")
        return
    }
    
    print("✅ MenuBarController: Status item created successfully")
    
    if let button = statusItem.button {
        print("✅ MenuBarController: Button exists")
        button.image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "HEXPal")
        button.image?.isTemplate = true
        print("✅ MenuBarController: Image set: \(button.image != nil)")
        button.action = #selector(statusItemClicked)
        button.target = self
    } else {
        print("❌ ERROR: Status item button is nil")
    }
    
    buildMenu()
    statusItem.menu = menu
    print("✅ MenuBarController: Menu assigned, setup complete")
}
```

### 5. Common Issues

**Issue: Icon not visible**
- **Cause:** Icon might be using wrong image or image is nil
- **Fix:** Check if `NSImage(systemSymbolName:)` returns nil
- **Alternative:** Use a custom image asset

**Issue: App crashes silently**
- **Cause:** Exception during menu bar setup
- **Fix:** Check console for crash logs
- **Check:** Verify Info.plist settings are correct

**Issue: Menu bar is full**
- **Cause:** Too many menu bar items
- **Fix:** Some icons get hidden - check Control Center area

**Issue: Permission issue**
- **Cause:** macOS blocking menu bar access
- **Fix:** Check System Preferences → Security & Privacy

### 6. Force Quit and Restart

If the app is stuck:
1. **Force Quit:** `Cmd+Option+Esc` → Select HexPal → Force Quit
2. **Or Terminal:** `killall HexPal`
3. **Rebuild and run again**

### 7. Test with Simple Icon

Try using a simple text-based icon first:

```swift
// In MenuBarController.swift, replace image setup:
if let button = statusItem.button {
    button.title = "HEX"  // Simple text instead of image
    button.action = #selector(statusItemClicked)
    button.target = self
}
```

If text appears, the issue is with the image. If text doesn't appear, the issue is with status item creation.

## Expected Console Output

When working correctly, you should see:
```
✅ AppDelegate: applicationDidFinishLaunching called
✅ AppDelegate: Creating MenuBarController
✅ AppDelegate: Calling setupMenuBar()
✅ MenuBarController: setupMenuBar() called
✅ MenuBarController: Status item created successfully
✅ MenuBarController: Button exists
✅ MenuBarController: Image set: true
✅ MenuBarController: Menu assigned, setup complete
✅ AppDelegate: Setup complete
```

## Next Steps

1. Add debug prints (see above)
2. Run app (`Cmd+R`)
3. Check console output
4. Report what you see
