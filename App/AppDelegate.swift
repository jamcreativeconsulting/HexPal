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
    
    /// Sets up the global hotkey (Cmd+Shift+C) for activating the color picker.
    ///
    /// Registers a system-wide keyboard shortcut that works from any application.
    /// If Accessibility permission is not granted, the hotkey will not be registered
    /// but the app will continue to function via menu bar.
    private func setupGlobalHotkey() {
        hotkeyManager = HotkeyManager()
        
        // Check if Accessibility permission is granted
        guard let hotkeyManager = hotkeyManager else { return }
        
        if !hotkeyManager.hasAccessibilityPermission() {
            // Permission not granted - request it
            // Note: User must grant permission in System Settings
            hotkeyManager.requestAccessibilityPermission()
        }
        
        // Register default hotkey (Cmd+Shift+C)
        let registered = hotkeyManager.registerDefaultHotkey { [weak self] in
            // Activate color picker when hotkey is pressed
            self?.menuBarController?.activateColorPicker()
        }
        
        if !registered {
            // Hotkey registration failed - likely due to missing permission or conflict
            // App will still work via menu bar
        }
    }
    
    /// Requests necessary system permissions for HEXPal functionality.
    private func requestPermissions() {
        // Screen Recording permission is requested automatically when attempting to capture
        // Accessibility permission is requested when registering global hotkeys
    }
}
