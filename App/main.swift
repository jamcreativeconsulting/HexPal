//
//  main.swift
//  HexPal
//
//  Explicit entry point for HEXPal application.
//  This ensures the AppDelegate is properly initialized.
//

import Cocoa

// Explicit entry point
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
