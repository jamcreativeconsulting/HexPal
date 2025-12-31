//
//  PreferencesWindowController.swift
//  HexPal
//
//  Manages the preferences window for HEXPal settings.
//  Provides hotkey customization and other user preferences.
//

import Cocoa

/// Manages the preferences window for HEXPal.
///
/// This controller handles:
/// - Displaying the preferences window
/// - Hotkey customization
/// - Saving/loading user preferences
///
/// ## Usage
/// ```swift
/// let prefsController = PreferencesWindowController.shared
/// prefsController.showWindow()
/// ```
class PreferencesWindowController: NSObject, NSWindowDelegate {
    
    // MARK: - Singleton
    
    /// Shared instance for preferences window
    static let shared = PreferencesWindowController()
    
    // MARK: - Properties
    
    /// The preferences window
    private var window: NSWindow?
    
    /// Current hotkey display field
    private var hotkeyField: NSTextField?
    
    /// Recording state
    private var isRecordingHotkey = false
    
    /// Local event monitor for hotkey recording
    private var eventMonitor: Any?
    
    /// Record button reference
    private var recordButton: NSButton?
    
    /// Launch at login checkbox reference
    private var launchAtLoginCheckbox: NSButton?
    
    // MARK: - UserDefaults Keys
    
    private static let hotkeyKeyCodeKey = "HotkeyKeyCode"
    private static let hotkeyModifiersKey = "HotkeyModifiers"
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Shows the preferences window.
    ///
    /// Ensures the window appears in front of all other windows by activating
    /// the app first, then bringing the window to the front.
    func showWindow() {
        if window == nil {
            createWindow()
        }
        
        // Sync launch at login checkbox state
        launchAtLoginCheckbox?.state = LaunchAtLoginManager.shared.isEnabled ? .on : .off
        
        // Activate app first to ensure window can appear in front
        NSApp.activate(ignoringOtherApps: true)
        
        // Bring window to front regardless of other windows
        window?.orderFrontRegardless()
        window?.makeKey()
        window?.center()
    }
    
    /// Gets the saved hotkey key code, or default if not set.
    static func savedKeyCode() -> UInt16 {
        let saved = UserDefaults.standard.integer(forKey: hotkeyKeyCodeKey)
        return saved == 0 ? HotkeyManager.defaultKeyCode : UInt16(saved)
    }
    
    /// Gets the saved hotkey modifiers, or default if not set.
    static func savedModifiers() -> NSEvent.ModifierFlags {
        let saved = UserDefaults.standard.integer(forKey: hotkeyModifiersKey)
        if saved == 0 {
            return HotkeyManager.defaultModifiers
        }
        return NSEvent.ModifierFlags(rawValue: UInt(saved))
    }
    
    /// Saves a hotkey combination to UserDefaults.
    static func saveHotkey(keyCode: UInt16, modifiers: NSEvent.ModifierFlags) {
        UserDefaults.standard.set(Int(keyCode), forKey: hotkeyKeyCodeKey)
        UserDefaults.standard.set(Int(modifiers.rawValue), forKey: hotkeyModifiersKey)
    }
    
    // MARK: - Private Methods
    
    private func createWindow() {
        // Create window - increased height for Launch at Login section
        let windowRect = NSRect(x: 0, y: 0, width: 400, height: 260)
        window = NSWindow(
            contentRect: windowRect,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window?.title = "HEXPal Preferences"
        window?.center()
        window?.delegate = self
        window?.isReleasedWhenClosed = false
        window?.level = .normal  // Ensure window appears at normal level (above background windows)
        window?.collectionBehavior = [.moveToActiveSpace]  // Move to active space when shown
        
        // Create content view
        let contentView = NSView(frame: windowRect)
        contentView.wantsLayer = true
        
        // Global Hotkey Section
        let hotkeyTitleLabel = NSTextField(labelWithString: "Global Hotkey")
        hotkeyTitleLabel.font = NSFont.boldSystemFont(ofSize: 14)
        hotkeyTitleLabel.frame = NSRect(x: 20, y: 210, width: 200, height: 24)
        contentView.addSubview(hotkeyTitleLabel)
        
        let hotkeyDescLabel = NSTextField(labelWithString: "Press the hotkey combination to activate the color picker from anywhere.")
        hotkeyDescLabel.font = NSFont.systemFont(ofSize: 12)
        hotkeyDescLabel.textColor = .secondaryLabelColor
        hotkeyDescLabel.frame = NSRect(x: 20, y: 180, width: 360, height: 30)
        hotkeyDescLabel.lineBreakMode = .byWordWrapping
        hotkeyDescLabel.maximumNumberOfLines = 2
        contentView.addSubview(hotkeyDescLabel)
        
        let currentLabel = NSTextField(labelWithString: "Current Hotkey:")
        currentLabel.font = NSFont.systemFont(ofSize: 13)
        currentLabel.frame = NSRect(x: 20, y: 140, width: 110, height: 24)
        contentView.addSubview(currentLabel)
        
        hotkeyField = NSTextField(labelWithString: formatHotkey(
            keyCode: PreferencesWindowController.savedKeyCode(),
            modifiers: PreferencesWindowController.savedModifiers()
        ))
        hotkeyField?.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .medium)
        hotkeyField?.frame = NSRect(x: 130, y: 140, width: 140, height: 24)
        hotkeyField?.alignment = .center
        hotkeyField?.backgroundColor = NSColor.controlBackgroundColor
        hotkeyField?.isBordered = true
        hotkeyField?.isEditable = false
        contentView.addSubview(hotkeyField!)
        
        recordButton = NSButton(title: "Record New Hotkey", target: self, action: #selector(recordButtonClicked))
        recordButton?.frame = NSRect(x: 20, y: 100, width: 150, height: 28)
        recordButton?.bezelStyle = .rounded
        contentView.addSubview(recordButton!)
        
        let resetButton = NSButton(title: "Reset to Default", target: self, action: #selector(resetButtonClicked))
        resetButton.frame = NSRect(x: 180, y: 100, width: 120, height: 28)
        resetButton.bezelStyle = .rounded
        contentView.addSubview(resetButton)
        
        // Separator
        let separator = NSBox(frame: NSRect(x: 20, y: 70, width: 360, height: 1))
        separator.boxType = .separator
        contentView.addSubview(separator)
        
        // Launch at Login Section
        let launchTitleLabel = NSTextField(labelWithString: "Launch at Login")
        launchTitleLabel.font = NSFont.boldSystemFont(ofSize: 14)
        launchTitleLabel.frame = NSRect(x: 20, y: 40, width: 200, height: 24)
        contentView.addSubview(launchTitleLabel)
        
        launchAtLoginCheckbox = NSButton(checkboxWithTitle: "Launch HEXPal automatically when you log in", target: self, action: #selector(launchAtLoginChanged))
        launchAtLoginCheckbox?.frame = NSRect(x: 20, y: 10, width: 360, height: 24)
        launchAtLoginCheckbox?.state = LaunchAtLoginManager.shared.isEnabled ? .on : .off
        contentView.addSubview(launchAtLoginCheckbox!)
        
        window?.contentView = contentView
    }
    
    @objc private func recordButtonClicked() {
        if isRecordingHotkey {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @objc private func resetButtonClicked() {
        // Reset to default hotkey
        PreferencesWindowController.saveHotkey(
            keyCode: HotkeyManager.defaultKeyCode,
            modifiers: HotkeyManager.defaultModifiers
        )
        
        hotkeyField?.stringValue = formatHotkey(
            keyCode: HotkeyManager.defaultKeyCode,
            modifiers: HotkeyManager.defaultModifiers
        )
        
        // Notify to re-register hotkey
        NotificationCenter.default.post(name: .hotkeyDidChange, object: nil)
    }
    
    @objc private func launchAtLoginChanged() {
        let enabled = launchAtLoginCheckbox?.state == .on
        LaunchAtLoginManager.shared.isEnabled = enabled
    }
    
    private func startRecording() {
        isRecordingHotkey = true
        recordButton?.title = "Press Keys..."
        hotkeyField?.stringValue = "Recording..."
        hotkeyField?.textColor = .systemRed
        
        // Monitor for key events
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            self?.handleKeyEvent(event)
            return nil // Consume the event
        }
    }
    
    private func stopRecording() {
        isRecordingHotkey = false
        recordButton?.title = "Record New Hotkey"
        hotkeyField?.textColor = .labelColor
        
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        // Require at least one modifier key
        let modifiers = event.modifierFlags.intersection([.command, .shift, .option, .control])
        
        guard !modifiers.isEmpty else {
            // Show error - need modifier keys
            hotkeyField?.stringValue = "Need modifier keys!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                if self?.isRecordingHotkey == true {
                    self?.hotkeyField?.stringValue = "Recording..."
                }
            }
            return
        }
        
        // Ignore if only modifier keys pressed (no main key)
        let keyCode = event.keyCode
        let modifierKeyCodes: Set<UInt16> = [54, 55, 56, 57, 58, 59, 60, 61, 62, 63] // Modifier key codes
        guard !modifierKeyCodes.contains(keyCode) else {
            return
        }
        
        // Save the new hotkey
        PreferencesWindowController.saveHotkey(keyCode: keyCode, modifiers: modifiers)
        
        // Update display
        hotkeyField?.stringValue = formatHotkey(keyCode: keyCode, modifiers: modifiers)
        
        // Stop recording
        stopRecording()
        
        // Notify to re-register hotkey
        NotificationCenter.default.post(name: .hotkeyDidChange, object: nil)
    }
    
    /// Formats a hotkey combination for display.
    private func formatHotkey(keyCode: UInt16, modifiers: NSEvent.ModifierFlags) -> String {
        var parts: [String] = []
        
        if modifiers.contains(.control) { parts.append("⌃") }
        if modifiers.contains(.option) { parts.append("⌥") }
        if modifiers.contains(.shift) { parts.append("⇧") }
        if modifiers.contains(.command) { parts.append("⌘") }
        
        parts.append(keyCodeToString(keyCode))
        
        return parts.joined()
    }
    
    /// Converts a key code to a string representation.
    private func keyCodeToString(_ keyCode: UInt16) -> String {
        let keyMap: [UInt16: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
            8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
            16: "Y", 17: "T", 18: "1", 19: "2", 20: "3", 21: "4", 22: "6",
            23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8", 29: "0",
            30: "]", 31: "O", 32: "U", 33: "[", 34: "I", 35: "P", 36: "↩",
            37: "L", 38: "J", 39: "'", 40: "K", 41: ";", 42: "\\", 43: ",",
            44: "/", 45: "N", 46: "M", 47: ".", 48: "⇥", 49: "Space",
            50: "`", 51: "⌫", 53: "⎋",
            // Function keys
            122: "F1", 120: "F2", 99: "F3", 118: "F4", 96: "F5", 97: "F6",
            98: "F7", 100: "F8", 101: "F9", 109: "F10", 103: "F11", 111: "F12",
            // Arrow keys
            123: "←", 124: "→", 125: "↓", 126: "↑"
        ]
        
        return keyMap[keyCode] ?? "Key\(keyCode)"
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        stopRecording()
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let hotkeyDidChange = Notification.Name("hotkeyDidChange")
}
