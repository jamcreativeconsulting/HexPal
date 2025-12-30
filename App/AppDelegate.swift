//
//  AppDelegate.swift
//  HexPal
//
//  Application delegate for HEXPal menu bar application.
//  Handles application lifecycle and initial setup.
//

import Cocoa

// #region agent log - File-based logging that bypasses console
/// Writes debug log directly to file for reliable debugging
func debugLog(_ message: String, file: String = #file, line: Int = #line) {
    let logPath = "/Users/jordan/Desktop/Business/JAMCreativeConsulting/Products/HEXPal/.cursor/debug.log"
    let timestamp = ISO8601DateFormatter().string(from: Date())
    let fileName = (file as NSString).lastPathComponent
    let entry = "{\"timestamp\":\"\(timestamp)\",\"location\":\"\(fileName):\(line)\",\"message\":\"\(message)\"}\n"
    
    // Append to log file
    if let data = entry.data(using: .utf8) {
        if FileManager.default.fileExists(atPath: logPath) {
            if let fileHandle = FileHandle(forWritingAtPath: logPath) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            FileManager.default.createFile(atPath: logPath, contents: data, attributes: nil)
        }
    }
    
    // Also print to console
    print("[\(fileName):\(line)] \(message)")
    fflush(stdout)
}
// #endregion

/// Main application delegate for HEXPal.
///
/// Manages application lifecycle events and initializes the menu bar interface.
/// Configures the app to run as a menu bar-only application (no dock icon).
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    /// Menu bar controller that manages the menu bar icon and menu
    private var menuBarController: MenuBarController?
    
    // MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        debugLog("🚀 AppDelegate: applicationDidFinishLaunching started")
        
        // Configure app to not show in dock (menu bar only)
        configureMenuBarOnlyMode()
        
        debugLog("🔧 AppDelegate: Creating MenuBarController")
        
        // Initialize menu bar controller
        menuBarController = MenuBarController()
        
        debugLog("🔧 AppDelegate: Calling setupMenuBar")
        menuBarController?.setupMenuBar()
        
        debugLog("🔧 AppDelegate: Calling requestPermissions")
        // Request necessary permissions
        requestPermissions()
        
        debugLog("✅ AppDelegate: applicationDidFinishLaunching complete")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Cleanup if needed
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - Private Methods
    
    /// Configures the app to run as a menu bar-only application.
    ///
    /// Sets LSUIElement to true to hide the dock icon.
    /// This ensures HEXPal appears only in the menu bar.
    private func configureMenuBarOnlyMode() {
        // LSUIElement is configured in Info.plist
        // This method is here for documentation and potential runtime configuration
    }
    
    /// Requests necessary system permissions for HEXPal functionality.
    ///
    /// Requests:
    /// - Screen Recording: Required for capturing screen content to pick colors
    /// - Accessibility: Required for global hotkey registration (on macOS 10.14+)
    ///
    /// - Note: Permission requests are handled by the system automatically.
    ///   This method can be used to check permission status and guide users.
    private func requestPermissions() {
        // Screen Recording permission is requested automatically when attempting to capture
        // Accessibility permission is requested automatically when registering global hotkeys
        
        // TODO: Add permission status checking and user guidance
        // This will be implemented in Phase 1 of development
    }
}
