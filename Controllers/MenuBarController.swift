//
//  MenuBarController.swift
//  HexPal
//
//  Manages the menu bar icon and dropdown menu for HEXPal.
//  Handles menu item clicks and application state.
//

import Cocoa

/// Manages the menu bar icon and dropdown menu for HEXPal.
///
/// This controller is responsible for:
/// - Creating and managing the menu bar status item
/// - Building the menu bar menu
/// - Handling menu item actions
/// - Managing the menu bar icon appearance
///
/// ## Usage
/// ```swift
/// let menuBarController = MenuBarController()
/// menuBarController.setupMenuBar()
/// ```
///
/// - Note: Must inherit from NSObject for @objc selectors to work with menu items
class MenuBarController: NSObject {
    
    // MARK: - Properties
    
    /// The status item displayed in the menu bar
    private var statusItem: NSStatusItem?
    
    /// The menu displayed when clicking the menu bar icon
    private let menu = NSMenu()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Activates the color picker.
    func activateColorPicker() {
        pickColorClicked(nil)
    }
    
    /// Sets up the menu bar icon and menu.
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else { return }
        
        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "HEXPal") {
                button.image = image
                button.image?.isTemplate = true
            } else {
                button.title = "HEX"
            }
        }
        
        buildMenu()
        statusItem.menu = menu
    }
    
    // MARK: - Private Methods
    
    private func buildMenu() {
        menu.removeAllItems()
        
        // Pick Color - show current hotkey in menu item
        let hotkeyString = formatCurrentHotkey()
        let pickColorTitle = hotkeyString.isEmpty ? "Pick Color" : "Pick Color  \(hotkeyString)"
        let pickColorItem = NSMenuItem(title: pickColorTitle, action: #selector(pickColorClicked(_:)), keyEquivalent: "")
        pickColorItem.target = self
        menu.addItem(pickColorItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Preferences
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(preferencesClicked), keyEquivalent: ",")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // About
        let aboutItem = NSMenuItem(title: "About HEXPal", action: #selector(aboutClicked), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit HEXPal", action: #selector(quitClicked), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
    }
    
    // MARK: - Menu Actions
    
    @objc private func pickColorClicked(_ sender: Any?) {
        NSColorSampler().show { [weak self] selectedColor in
            DispatchQueue.main.async {
                guard let color = selectedColor else { return }
                
                let hexString = self?.colorToHex(color) ?? "#000000"
                
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(hexString, forType: .string)
                
                self?.showClipboardNotification(hex: hexString)
            }
        }
    }
    
    private func colorToHex(_ color: NSColor) -> String {
        guard let rgbColor = color.usingColorSpace(.sRGB) else { return "#000000" }
        let red = Int(rgbColor.redComponent * 255)
        let green = Int(rgbColor.greenComponent * 255)
        let blue = Int(rgbColor.blueComponent * 255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    private func showClipboardNotification(hex: String) {
        let notification = ClipboardNotificationView(hex: hex)
        notification.show()
    }
    
    /// Formats the current hotkey for display in the menu.
    ///
    /// - Returns: A string like "⌘⇧P" or empty string if no hotkey
    private func formatCurrentHotkey() -> String {
        let keyCode = PreferencesWindowController.savedKeyCode()
        let modifiers = PreferencesWindowController.savedModifiers()
        
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
            50: "`", 51: "⌫", 53: "⎋"
        ]
        return keyMap[keyCode] ?? "?"
    }
    
    @objc private func preferencesClicked() {
        PreferencesWindowController.shared.showWindow()
    }
    
    @objc private func aboutClicked() {
        // Get app version info from bundle
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        let copyright = Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? "© 2025 HEXPal"
        
        // Activate the app to ensure alert appears in front
        NSApp.activate(ignoringOtherApps: true)
        
        // Create About dialog
        let alert = NSAlert()
        alert.messageText = "HEXPal"
        alert.informativeText = """
        Version \(version) (Build \(build))
        
        \(copyright)
        
        A free, open-source macOS menu bar application for picking colors and getting HEX codes.
        
        GitHub: https://github.com/jamcreativeconsulting/HexPal
        
        Licensed under the MIT License.
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Visit GitHub")
        
        // Run modal - works with LSUIElement apps when app is activated
        let response = alert.runModal()
        
        // Second button (Visit GitHub)
        if response == .alertSecondButtonReturn {
            if let url = URL(string: "https://github.com/jamcreativeconsulting/HexPal") {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    @objc private func quitClicked() {
        NSApplication.shared.terminate(nil)
    }
}
