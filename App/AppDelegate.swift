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
    
    /// Hotkey manager for global keyboard shortcuts
    private var hotkeyManager: HotkeyManager?
    
    // MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Configure app to not show in dock (menu bar only)
        configureMenuBarOnlyMode()
        
        // Initialize menu bar controller
        menuBarController = MenuBarController()
        menuBarController?.setupMenuBar()
        
        // Initialize and register global hotkey
        setupGlobalHotkey()
        
        // Request necessary permissions
        requestPermissions()
        
        // Show welcome notification on first launch
        showWelcomeIfFirstLaunch()
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
    
    /// Sets up the global hotkey for activating the color picker.
    ///
    /// Registers a system-wide keyboard shortcut that works from any application.
    /// Loads the user's saved hotkey or falls back to default (Cmd+Shift+P).
    /// If Accessibility permission is not granted, shows a user-friendly error message
    /// but the app will continue to function via menu bar.
    private func setupGlobalHotkey() {
        hotkeyManager = HotkeyManager()
        
        // Check if Accessibility permission is granted
        guard let hotkeyManager = hotkeyManager else { return }
        
        if !hotkeyManager.hasAccessibilityPermission() {
            // Permission not granted - request it with user-friendly guidance
            hotkeyManager.requestAccessibilityPermission()
            
            // Show helpful error message after a brief delay (non-blocking)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ErrorHandler.showPermissionError(.accessibility)
            }
        }
        
        // Register saved hotkey (or default if none saved)
        registerCurrentHotkey()
        
        // Listen for hotkey changes from preferences
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hotkeyDidChange),
            name: .hotkeyDidChange,
            object: nil
        )
    }
    
    /// Registers the current hotkey (saved or default).
    private func registerCurrentHotkey() {
        let registered = hotkeyManager?.registerSavedHotkey { [weak self] in
            // Activate color picker when hotkey is pressed
            self?.menuBarController?.activateColorPicker()
        }
        
        if registered != true {
            // Hotkey registration failed - check why and inform user
            let hasPermission = hotkeyManager?.hasAccessibilityPermission() ?? false
            let reason = hasPermission ? "The hotkey may be in use by another app." : "Accessibility permission is required."
            
            // Only show error if permission is granted (otherwise we already showed permission error)
            if hasPermission {
                ErrorHandler.showError(.hotkeyRegistrationFailed, additionalInfo: reason)
            }
        }
    }
    
    /// Called when the hotkey is changed in preferences.
    @objc private func hotkeyDidChange() {
        registerCurrentHotkey()
    }
    
    /// Requests necessary system permissions for HEXPal functionality.
    private func requestPermissions() {
        // Screen Recording permission is requested automatically when attempting to capture
        // Accessibility permission is requested when registering global hotkeys
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
    }
}
