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
        removeLegacyHotkeyKeys()
        // LSUIElement in Info.plist provides menu-bar-only mode (no dock icon)

        // Initialize menu bar controller
        menuBarController = MenuBarController()
        menuBarController?.setupMenuBar()
        
        HotkeyManager.shared.start()
        
        // Show welcome notification on first launch
        showWelcomeIfFirstLaunch()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - Private Methods
    
    /// Removes legacy hotkey UserDefaults keys from pre–KeyboardShortcuts versions.
    private func removeLegacyHotkeyKeys() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "HotkeyKeyCode")
        defaults.removeObject(forKey: "HotkeyModifiers")
    }

    /// Shows the welcome notification on first launch.
    ///
    /// Uses UserDefaults to track whether the app has been launched before.
    /// Only shows the welcome notification once to introduce new users to the hotkey.
    private func showWelcomeIfFirstLaunch() {
        // Delay slightly to ensure menu bar is fully set up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            WelcomeNotificationView.showIfFirstLaunch()
        }
        
        // Show menu bar hint after welcome
        // Delay so it doesn't overlap the welcome notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let hotkey = PreferencesWindowController.formattedHotkeyForDisplay()
            MenuBarHintView.showIfFirstLaunch(hotkeyString: hotkey)
        }
    }
}
