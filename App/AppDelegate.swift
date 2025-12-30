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
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    /// Menu bar controller that manages the menu bar icon and menu
    private var menuBarController: MenuBarController?
    
    // MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("✅ AppDelegate: applicationDidFinishLaunching called")
        
        // Configure app to not show in dock (menu bar only)
        configureMenuBarOnlyMode()
        
        // Initialize menu bar controller
        print("✅ AppDelegate: Creating MenuBarController")
        menuBarController = MenuBarController()
        
        print("✅ AppDelegate: Calling setupMenuBar()")
        menuBarController?.setupMenuBar()
        
        print("✅ AppDelegate: Setup complete")
        
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
