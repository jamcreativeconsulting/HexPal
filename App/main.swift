//
//  main.swift
//  HexPal
//
//  Explicit entry point for HEXPal application.
//  This ensures the AppDelegate is properly initialized.
//

import Cocoa

// Explicit entry point - app startup runs on main thread
NSLog("🚀🚀🚀 main.swift: Starting application")
print("🚀🚀🚀 main.swift: Starting application")
fflush(stdout)

let app = NSApplication.shared

// Create delegate synchronously on main thread
// App startup is guaranteed to be on main thread
NSLog("🚀🚀🚀 main.swift: Creating AppDelegate")
print("🚀🚀🚀 main.swift: Creating AppDelegate")
fflush(stdout)

let delegate = AppDelegate()
app.delegate = delegate

NSLog("🚀🚀🚀 main.swift: Delegate set, running app")
print("🚀🚀🚀 main.swift: Delegate set, running app")
fflush(stdout)

app.run()
