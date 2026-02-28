//
//  PreferencesWindowController.swift
//  HexPal
//
//  Manages the preferences window for HEXPal settings.
//  Provides hotkey customization via KeyboardShortcuts and launch-at-login.
//

import Cocoa
import KeyboardShortcuts

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
    
    
    /// Launch at login checkbox reference
    private var launchAtLoginCheckbox: NSButton?
    
    
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
    
    /// Returns the formatted hotkey string for display (e.g. "⌘⇧P").
    /// Must be called from main thread.
    static func formattedHotkeyForDisplay() -> String {
        MainActor.assumeIsolated {
            KeyboardShortcuts.getShortcut(for: .pickColor).map { "\($0)" } ?? ""
        }
    }
    
    // MARK: - Private Methods
    
    private func createWindow() {
        let windowRect = NSRect(x: 0, y: 0, width: 400, height: 300)
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
        let hotkeyLabel = NSTextField(labelWithString: "Pick Color Shortcut:")
        hotkeyLabel.font = NSFont.systemFont(ofSize: 13)
        hotkeyLabel.frame = NSRect(x: 20, y: 218, width: 150, height: 22)
        contentView.addSubview(hotkeyLabel)
        
        let recorder = KeyboardShortcuts.RecorderCocoa(for: .pickColor)
        recorder.frame = NSRect(x: 170, y: 214, width: 200, height: 28)
        contentView.addSubview(recorder)
        
        // Separator
        let separator = NSBox(frame: NSRect(x: 20, y: 75, width: 360, height: 1))
        separator.boxType = .separator
        contentView.addSubview(separator)
        
        // Launch at Login Section
        let launchTitleLabel = NSTextField(labelWithString: "Launch at Login")
        launchTitleLabel.font = NSFont.boldSystemFont(ofSize: 14)
        launchTitleLabel.frame = NSRect(x: 20, y: 45, width: 200, height: 24)
        contentView.addSubview(launchTitleLabel)
        
        let checkbox = NSButton(checkboxWithTitle: "Launch HEXPal automatically when you log in", target: self, action: #selector(launchAtLoginChanged))
        checkbox.frame = NSRect(x: 20, y: 15, width: 360, height: 24)
        checkbox.state = LaunchAtLoginManager.shared.isEnabled ? .on : .off
        launchAtLoginCheckbox = checkbox
        contentView.addSubview(checkbox)
        
        window?.contentView = contentView
    }
    
    @objc private func launchAtLoginChanged() {
        let enabled = launchAtLoginCheckbox?.state == .on
        LaunchAtLoginManager.shared.isEnabled = enabled
    }
    
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {}
}
