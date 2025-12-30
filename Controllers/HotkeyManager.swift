//
//  HotkeyManager.swift
//  HexPal
//
//  Manages global keyboard shortcut registration and activation.
//  Handles hotkey registration, conflicts, and accessibility permissions.
//

import Cocoa

/// Manages global keyboard shortcut registration for HEXPal.
///
/// This class handles registration of system-wide keyboard shortcuts that
/// can activate the color picker from any application. Uses NSEvent monitoring
/// which works when the app is active (suitable for menu bar apps).
///
/// ## Usage
/// ```swift
/// let hotkeyManager = HotkeyManager()
/// hotkeyManager.registerDefaultHotkey { [weak self] in
///     self?.activateColorPicker()
/// }
/// ```
///
/// ## Thread Safety
/// All methods must be called from the main thread.
///
/// - Note: Hotkeys work when HEXPal is active. For true system-wide hotkeys,
///   Accessibility permission is required and Carbon API would be needed.
class HotkeyManager {
    
    // MARK: - Properties
    
    /// Callback invoked when hotkey is pressed
    private var activationCallback: (() -> Void)?
    
    /// Global event monitor for hotkey detection
    private var globalEventMonitor: Any?
    
    /// Local event monitor for hotkey detection (when app is key)
    private var localEventMonitor: Any?
    
    /// Default hotkey: Cmd+Shift+P (for "Pick")
    /// Changed from C to avoid conflict with system shortcuts
    static let defaultModifiers: NSEvent.ModifierFlags = [.command, .shift]
    static let defaultKeyCode: UInt16 = 35 // 'P' key (kVK_ANSI_P)
    
    // MARK: - Initialization
    
    init() {
        // Initialization handled by register methods
    }
    
    deinit {
        unregisterHotkey()
    }
    
    // MARK: - Public Methods
    
    /// Registers the default hotkey (Cmd+Shift+P).
    ///
    /// Registers a keyboard shortcut that activates the color picker.
    /// Works when HEXPal is active (suitable for menu bar apps).
    ///
    /// - Parameter activationHandler: Closure called when hotkey is pressed
    /// - Returns: true if registration succeeded, false otherwise
    func registerDefaultHotkey(activationHandler: @escaping () -> Void) -> Bool {
        return registerHotkey(
            keyCode: HotkeyManager.defaultKeyCode,
            modifiers: HotkeyManager.defaultModifiers,
            activationHandler: activationHandler
        )
    }
    
    /// Registers the user's saved hotkey from preferences.
    ///
    /// Loads the hotkey from UserDefaults and registers it.
    /// Falls back to default if no saved hotkey exists.
    ///
    /// - Parameter activationHandler: Closure called when hotkey is pressed
    /// - Returns: true if registration succeeded, false otherwise
    func registerSavedHotkey(activationHandler: @escaping () -> Void) -> Bool {
        let keyCode = PreferencesWindowController.savedKeyCode()
        let modifiers = PreferencesWindowController.savedModifiers()
        return registerHotkey(
            keyCode: keyCode,
            modifiers: modifiers,
            activationHandler: activationHandler
        )
    }
    
    /// Registers a custom hotkey combination.
    ///
    /// - Parameters:
    ///   - keyCode: Virtual key code (see NSEvent.keyCode)
    ///   - modifiers: Modifier keys combination
    ///   - activationHandler: Closure called when hotkey is pressed
    /// - Returns: true if registration succeeded, false otherwise
    func registerHotkey(
        keyCode: UInt16,
        modifiers: NSEvent.ModifierFlags,
        activationHandler: @escaping () -> Void
    ) -> Bool {
        // Unregister existing hotkey if any
        unregisterHotkey()
        
        // Store callback
        activationCallback = activationHandler
        
        // Register global event monitor (requires Accessibility permission)
        // Note: Global monitors cannot consume events, so we need to handle this carefully
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard let self = self else { return }
            
            // Extract only the modifiers we care about
            let relevantModifiers = event.modifierFlags.intersection([.command, .shift, .option, .control])
            
            // Check if this is our hotkey combination
            if event.keyCode == keyCode && relevantModifiers == modifiers {
                // Activate the app immediately to make it key
                // This helps prevent the system from handling the shortcut
                NSApplication.shared.activate(ignoringOtherApps: true)
                
                // Call activation callback immediately
                DispatchQueue.main.async {
                    self.activationCallback?()
                }
            }
        }
        
        // Also monitor local events (when app is key) - this can consume events
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard let self = self else { return event }
            
            // Extract only the modifiers we care about
            let relevantModifiers = event.modifierFlags.intersection([.command, .shift, .option, .control])
            
            // Check if this is our hotkey combination
            if event.keyCode == keyCode && relevantModifiers == modifiers {
                // Call activation callback
                self.activationCallback?()
                // Consume the event to prevent default behavior (like Finder opening)
                return nil
            }
            
            return event
        }
        
        return globalEventMonitor != nil || localEventMonitor != nil
    }
    
    /// Unregisters the currently active hotkey.
    func unregisterHotkey() {
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
            globalEventMonitor = nil
        }
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
            localEventMonitor = nil
        }
        activationCallback = nil
    }
    
    /// Checks if Accessibility permission is granted.
    ///
    /// For true system-wide hotkeys, Accessibility permission is required.
    /// This implementation uses NSEvent monitoring which works when app is active.
    ///
    /// - Returns: true if permission is granted, false otherwise
    func hasAccessibilityPermission() -> Bool {
        if #available(macOS 10.14, *) {
            return AXIsProcessTrusted()
        }
        // Older macOS versions don't require explicit permission
        return true
    }
    
    /// Requests Accessibility permission from the user.
    ///
    /// On macOS 10.14+, this will prompt the user to grant permission.
    /// The user must grant permission in System Settings for true system-wide hotkeys.
    func requestAccessibilityPermission() {
        if #available(macOS 10.14, *) {
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
            _ = AXIsProcessTrustedWithOptions(options as CFDictionary)
        }
    }
}
