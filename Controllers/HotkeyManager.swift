//
//  HotkeyManager.swift
//  HexPal
//
//  Manages global keyboard shortcut registration and activation.
//  Handles hotkey registration, conflicts, and accessibility permissions.
//

import Cocoa
import Carbon

/// Manages global keyboard shortcut registration for HEXPal.
///
/// This class handles registration of system-wide keyboard shortcuts that
/// can activate the color picker from any application. It manages permission
/// requests, conflict detection, and hotkey lifecycle.
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
/// - Warning: Requires Accessibility permission on macOS 10.14+
class HotkeyManager {
    
    // MARK: - Types
    
    /// Represents a keyboard modifier combination
    struct Modifiers: OptionSet {
        let rawValue: UInt32
        
        static let command = Modifiers(rawValue: UInt32(NSEvent.ModifierFlags.command.rawValue))
        static let shift = Modifiers(rawValue: UInt32(NSEvent.ModifierFlags.shift.rawValue))
        static let option = Modifiers(rawValue: UInt32(NSEvent.ModifierFlags.option.rawValue))
        static let control = Modifiers(rawValue: UInt32(NSEvent.ModifierFlags.control.rawValue))
        
        /// Converts to Carbon modifier flags
        var carbonFlags: UInt32 {
            var flags: UInt32 = 0
            if contains(.command) { flags |= UInt32(cmdKey) }
            if contains(.shift) { flags |= UInt32(shiftKey) }
            if contains(.option) { flags |= UInt32(optionKey) }
            if contains(.control) { flags |= UInt32(controlKey) }
            return flags
        }
    }
    
    // MARK: - Properties
    
    /// Callback invoked when hotkey is pressed
    private var activationCallback: (() -> Void)?
    
    /// Currently registered hotkey reference
    private var hotKeyRef: EventHotKeyRef?
    
    /// Hotkey ID for Carbon API
    private let hotKeyID = EventHotKeyID(signature: FourCharCode(fromString: "HEXP"), id: 1)
    
    /// Default hotkey: Cmd+Shift+C
    static let defaultModifiers: Modifiers = [.command, .shift]
    static let defaultKeyCode: UInt32 = 8 // 'C' key
    
    // MARK: - Initialization
    
    init() {
        // Setup Carbon event handler
        setupCarbonEventHandler()
    }
    
    deinit {
        unregisterHotkey()
    }
    
    // MARK: - Public Methods
    
    /// Registers the default hotkey (Cmd+Shift+C).
    ///
    /// Registers a system-wide keyboard shortcut that activates the color picker
    /// from any application. Requires Accessibility permission on macOS 10.14+.
    ///
    /// - Parameter activationHandler: Closure called when hotkey is pressed
    /// - Returns: true if registration succeeded, false otherwise
    /// - Note: Returns false if Accessibility permission is not granted
    func registerDefaultHotkey(activationHandler: @escaping () -> Void) -> Bool {
        return registerHotkey(
            keyCode: HotkeyManager.defaultKeyCode,
            modifiers: HotkeyManager.defaultModifiers,
            activationHandler: activationHandler
        )
    }
    
    /// Registers a custom hotkey combination.
    ///
    /// - Parameters:
    ///   - keyCode: Virtual key code (see Carbon's kVK_* constants)
    ///   - modifiers: Modifier keys combination
    ///   - activationHandler: Closure called when hotkey is pressed
    /// - Returns: true if registration succeeded, false otherwise
    func registerHotkey(
        keyCode: UInt32,
        modifiers: Modifiers,
        activationHandler: @escaping () -> Void
    ) -> Bool {
        // Unregister existing hotkey if any
        unregisterHotkey()
        
        // Store callback
        activationCallback = activationHandler
        
        // Register hotkey with Carbon API
        var hotKeyRef: EventHotKeyRef?
        let status = RegisterEventHotKey(
            keyCode,
            modifiers.carbonFlags,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        
        guard status == noErr, let ref = hotKeyRef else {
            // Registration failed - likely due to missing Accessibility permission
            // or hotkey conflict
            return false
        }
        
        self.hotKeyRef = ref
        return true
    }
    
    /// Unregisters the currently active hotkey.
    func unregisterHotkey() {
        if let ref = hotKeyRef {
            UnregisterEventHotKey(ref)
            hotKeyRef = nil
        }
        activationCallback = nil
    }
    
    /// Checks if Accessibility permission is granted.
    ///
    /// Global hotkeys require Accessibility permission on macOS 10.14+.
    /// This method checks the current permission status.
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
    /// The user must grant permission in System Settings for global hotkeys to work.
    func requestAccessibilityPermission() {
        if #available(macOS 10.14, *) {
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
            _ = AXIsProcessTrustedWithOptions(options as CFDictionary)
        }
    }
    
    // MARK: - Private Methods
    
    /// Sets up the Carbon event handler for hotkey events.
    private func setupCarbonEventHandler() {
        var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        
        InstallApplicationEventHandler(
            { (nextHandler, theEvent, userData) -> OSStatus in
                guard let userData = userData else {
                    return OSStatus(eventNotHandledErr)
                }
                
                // Extract hotkey ID from event
                var hotKeyID = EventHotKeyID()
                let status = GetEventParameter(
                    theEvent,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                
                guard status == noErr else {
                    return OSStatus(eventNotHandledErr)
                }
                
                // Get HotkeyManager instance from userData
                let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                
                // Verify this is our hotkey
                if hotKeyID.signature == manager.hotKeyID.signature &&
                   hotKeyID.id == manager.hotKeyID.id {
                    // Call activation callback on main thread
                    DispatchQueue.main.async {
                        manager.activationCallback?()
                    }
                    return noErr
                }
                
                return OSStatus(eventNotHandledErr)
            },
            1,
            &eventSpec,
            Unmanaged.passUnretained(self).toOpaque(),
            nil
        )
    }
}

// MARK: - Helper Extensions

extension FourCharCode {
    /// Creates a FourCharCode from a 4-character string.
    ///
    /// - Parameter string: 4-character string (e.g., "HEXP")
    init(fromString string: String) {
        var code: UInt32 = 0
        let utf8 = string.utf8
        for (index, byte) in utf8.prefix(4).enumerated() {
            code |= UInt32(byte) << (8 * (3 - index))
        }
        self = code
    }
}
