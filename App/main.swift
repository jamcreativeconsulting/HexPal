//
//  main.swift
//  HexPal
//
//  Explicit entry point for HEXPal application.
//  Sets up NSApplication and AppDelegate to ensure proper initialization.
//

import Cocoa

// Explicit entry point - app startup runs on main thread
NSLog("🔵 main.swift: Starting app initialization")
let app = NSApplication.shared
NSLog("🔵 main.swift: NSApplication.shared obtained")

let delegate = AppDelegate()
NSLog("🔵 main.swift: AppDelegate created")

app.delegate = delegate
NSLog("🔵 main.swift: Delegate assigned to app")

NSLog("🔵 main.swift: About to call app.run()")
app.run()
NSLog("🔵 main.swift: app.run() returned (should not reach here)")
