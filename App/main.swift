//
//  main.swift
//  HexPal
//
//  Explicit entry point for HEXPal application.
//  This ensures the AppDelegate is properly initialized.
//

import Cocoa

// Explicit entry point
@MainActor
func main() {
    NSLog("🚀🚀🚀 main.swift: Starting application")
    print("🚀🚀🚀 main.swift: Starting application")
    fflush(stdout)
    
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    
    NSLog("🚀🚀🚀 main.swift: Delegate set, running app")
    print("🚀🚀🚀 main.swift: Delegate set, running app")
    fflush(stdout)
    
    app.run()
}

main()
