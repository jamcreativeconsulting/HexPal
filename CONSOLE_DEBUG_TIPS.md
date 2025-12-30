# Console Debug Tips - No Output Showing

## Issue: Console is Empty

If you're not seeing debug output in Xcode's console, try these steps:

## Step 1: Check Console View Mode

1. **Look at the bottom of the Debug Area** (where console is)
2. **Find the filter buttons** (usually show "All Output", "Debugger Output", etc.)
3. **Click "All Output"** (not just "Debugger Output")
4. **Make sure "Auto" is enabled** (should show "Auto" button)

## Step 2: Check Console Filter

1. **Look for a "Filter" text field** in the console area
2. **Clear any text** in the filter field
3. **Make sure it's not filtering out your prints**

## Step 3: Check Breakpoints

1. **Look at the left margin** of your code files
2. **Check for blue breakpoints** (filled circles)
3. **If you see breakpoints**, click them to disable
4. **Or:** Debug menu → Breakpoints → Deactivate Breakpoints

## Step 4: Use Terminal Instead

If Xcode console still doesn't work:

1. **Open Terminal.app**
2. **Run:**
   ```bash
   log stream --predicate 'process == "HexPal"' --level debug
   ```
3. **Then run your app** - output will appear in Terminal

## Step 5: Check Console.app

1. **Open Console.app** (Applications → Utilities → Console)
2. **In search box**, type: `HexPal`
3. **Run your app** - logs will appear here

## Step 6: Verify Debug Area is Visible

1. **Press `Cmd+Shift+Y`** to toggle Debug Area
2. **Or:** View menu → Debug Area → Show Debug Area
3. **Make sure console tab is selected** (not variables or breakpoints)

## Step 7: Check Output Settings

1. **Product menu → Scheme → Edit Scheme...**
2. **Select "Run"** on the left
3. **Select "Info" tab**
4. **Check "Console"** is set to "Use Terminal" or "Use Xcode Console"

## Step 8: Try NSLog Instead

If `print()` isn't working, try `NSLog()`:

```swift
NSLog("✅ AppDelegate: applicationDidFinishLaunching called")
```

NSLog always goes to Console.app and is more reliable.

## Quick Test

Add this at the very top of `applicationDidFinishLaunching`:

```swift
NSLog("🚀 TEST: App is launching!")
print("🚀 TEST: App is launching!")
```

Both should appear somewhere - if neither does, there's a deeper issue.

## Alternative: Use Alert Dialog

Temporarily add an alert to verify code is running:

```swift
func applicationDidFinishLaunching(_ aNotification: Notification) {
    let alert = NSAlert()
    alert.messageText = "App Launched"
    alert.informativeText = "applicationDidFinishLaunching was called"
    alert.runModal()
    // ... rest of code
}
```

If you see the alert, code is running but console isn't showing output.
