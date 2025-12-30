//
//  main.swift
//  HexPal
//
//  Explicit entry point for HEXPal application.
//  Sets up NSApplication and AppDelegate to ensure proper initialization.
//

import Cocoa

// Create delegate and keep strong reference
// NSApplication.delegate is WEAK, so we must retain the delegate ourselves
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Use withExtendedLifetime to prevent ARC from deallocating delegate
// during app.run() since NSApplication.delegate is a weak reference
withExtendedLifetime(delegate) {
    app.run()
}
