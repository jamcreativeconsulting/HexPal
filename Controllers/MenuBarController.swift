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
/// - Building the menu bar menu with Recent Colors submenu
/// - Handling menu item actions
/// - Managing the menu bar icon appearance
///
/// - Note: Must inherit from NSObject for @objc selectors to work with menu items
class MenuBarController: NSObject {
    
    // MARK: - Properties
    
    /// The status item displayed in the menu bar
    private var statusItem: NSStatusItem?
    
    /// The menu displayed when clicking the menu bar icon
    private let menu = NSMenu()
    
    /// Reference to the Recent Colors submenu for dynamic updates
    private var recentColorsSubmenu: NSMenu?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(colorHistoryDidChange),
            name: ColorHistoryManager.historyDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        // Recent Colors submenu
        let recentColorsItem = NSMenuItem(title: "Recent Colors", action: nil, keyEquivalent: "")
        recentColorsSubmenu = NSMenu()
        recentColorsItem.submenu = recentColorsSubmenu
        menu.addItem(recentColorsItem)
        updateRecentColorsSubmenu()
        
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
    
    /// Updates the Recent Colors submenu with current history.
    private func updateRecentColorsSubmenu() {
        guard let submenu = recentColorsSubmenu else { return }
        submenu.removeAllItems()
        
        let history = ColorHistoryManager.shared
        
        if history.hasColors {
            for hex in history.recentColors {
                let item = createColorMenuItem(hex: hex)
                submenu.addItem(item)
            }
            
            submenu.addItem(NSMenuItem.separator())
            
            let clearItem = NSMenuItem(title: "Clear History", action: #selector(clearHistoryClicked), keyEquivalent: "")
            clearItem.target = self
            submenu.addItem(clearItem)
        } else {
            let emptyItem = NSMenuItem(title: "No recent colors", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            submenu.addItem(emptyItem)
        }
    }
    
    /// Creates a menu item for a color with a color swatch.
    private func createColorMenuItem(hex: String) -> NSMenuItem {
        let item = NSMenuItem(title: hex, action: #selector(recentColorClicked(_:)), keyEquivalent: "")
        item.target = self
        item.representedObject = hex
        
        let swatchSize = NSSize(width: 16, height: 16)
        let image = NSImage(size: swatchSize)
        image.lockFocus()
        hexToColor(hex).setFill()
        NSBezierPath(roundedRect: NSRect(origin: .zero, size: swatchSize), xRadius: 3, yRadius: 3).fill()
        NSColor.separatorColor.setStroke()
        NSBezierPath(roundedRect: NSRect(origin: .zero, size: swatchSize), xRadius: 3, yRadius: 3).stroke()
        image.unlockFocus()
        
        item.image = image
        return item
    }
    
    /// Converts a HEX string to NSColor.
    private func hexToColor(_ hex: String) -> NSColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized = String(hexSanitized.dropFirst()) }
        guard hexSanitized.count == 6 else { return NSColor.gray }
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return NSColor.gray }
        return NSColor(
            srgbRed: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    @objc private func colorHistoryDidChange() {
        updateRecentColorsSubmenu()
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
                
                ColorHistoryManager.shared.addColor(hexString)
                
                self?.showClipboardNotification(hex: hexString)
            }
        }
    }
    
    @objc private func recentColorClicked(_ sender: NSMenuItem) {
        guard let hex = sender.representedObject as? String else { return }
        ColorHistoryManager.shared.copyToClipboard(hex)
        showClipboardNotification(hex: hex)
    }
    
    @objc private func clearHistoryClicked() {
        ColorHistoryManager.shared.clearHistory()
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
            50: "\`", 51: "⌫", 53: "⎋"
        ]
        return keyMap[keyCode] ?? "?"
    }
    
    @objc private func preferencesClicked() {
        PreferencesWindowController.shared.showWindow()
    }
    
    @objc private func aboutClicked() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        let copyright = Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? "© 2025 HEXPal"
        
        NSApp.activate(ignoringOtherApps: true)
        
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
        
        let response = alert.runModal()
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
