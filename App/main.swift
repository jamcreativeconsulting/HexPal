//
//  main.swift
//  HexPal
//
//  Explicit entry point for HEXPal application.
//  Sets up NSApplication and AppDelegate to ensure proper initialization.
//

import Cocoa

// Explicit entry point - app startup runs on main thread
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
