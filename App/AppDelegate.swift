//
//  AppDelegate.swift
//  HexPal
//
//  Application delegate for HEXPal menu bar application.
//  Handles application lifecycle and initial setup.
//

import Cocoa

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
        // Configure app to not show in dock (menu bar only)
        configureMenuBarOnlyMode()
        
        // Initialize menu bar controller
        menuBarController = MenuBarController()
        menuBarController?.setupMenuBar()
        
        // Request necessary permissions
        requestPermissions()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Cleanup if needed
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - Private Methods
    
    /// Configures the app to run as a menu bar-only application.
    private func configureMenuBarOnlyMode() {
        // LSUIElement is configured in Info.plist
    }
    
    /// Requests necessary system permissions for HEXPal functionality.
    private func requestPermissions() {
        // Permissions are requested automatically when needed
    }
}
