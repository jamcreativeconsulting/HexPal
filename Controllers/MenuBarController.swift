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
        // Initialization handled by setupMenuBar()
    }
    
    // MARK: - Public Methods
    
    /// Activates the color picker.
    ///
    /// This method can be called from anywhere (e.g., global hotkey) to activate
    /// the color picker. It performs the same action as clicking "Pick Color" in the menu.
    func activateColorPicker() {
        pickColorClicked(nil)
    }
    
    
    /// Sets up the menu bar icon and menu.
    ///
    /// Creates a status item in the menu bar and builds the menu structure.
    /// Should be called once during application startup.
    func setupMenuBar() {
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else {
            return
        }
        
        // Configure status item button
        if let button = statusItem.button {
            // Try to create the eyedropper image
            if let image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "HEXPal") {
                button.image = image
                button.image?.isTemplate = true // Supports dark mode
            } else {
                // Fallback to text if image creation fails
                button.title = "HEX"
            }
            
            button.action = #selector(statusItemClicked)
            button.target = self
        }
        
        // Build menu
        buildMenu()
        
        // Assign menu to status item
        statusItem.menu = menu
    }
    
    // MARK: - Private Methods
    
    /// Builds the menu bar dropdown menu.
    ///
    /// Creates menu items for:
    /// - Pick Color (activates color picker)
    /// - Preferences (opens preferences window)
    /// - About (shows about dialog)
    /// - Quit (exits application)
    private func buildMenu() {
        menu.removeAllItems()
        
        // Pick Color
        let pickColorItem = NSMenuItem(
            title: "Pick Color",
            action: #selector(pickColorClicked(_:)),
            keyEquivalent: ""
        )
        pickColorItem.target = self
        menu.addItem(pickColorItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Preferences
        let preferencesItem = NSMenuItem(
            title: "Preferences...",
            action: #selector(preferencesClicked),
            keyEquivalent: ","
        )
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // About
        let aboutItem = NSMenuItem(
            title: "About HEXPal",
            action: #selector(aboutClicked),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(
            title: "Quit HEXPal",
            action: #selector(quitClicked),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
    }
    
    // MARK: - Menu Actions
    
    /// Handles click on the menu bar status item.
    @objc private func statusItemClicked() {
        // Menu is shown automatically when assigned to statusItem.menu
    }
    
    /// Handles "Pick Color" menu item click.
    ///
    /// Uses Apple's native NSColorSampler for reliable color picking.
    /// The selected color is converted to HEX format and copied to the clipboard.
    ///
    /// - Parameter sender: The menu item that triggered this action (unused)
    @objc private func pickColorClicked(_ sender: Any?) {
        // Use Apple's native color sampler (macOS 10.15+)
        NSColorSampler().show { [weak self] selectedColor in
            DispatchQueue.main.async {
                guard let color = selectedColor else {
                    return
                }
                
                // Convert to HEX and copy to clipboard
                let hexString = self?.colorToHex(color) ?? "#000000"
                
                // Copy to clipboard
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(hexString, forType: .string)
                
                // Show modern, non-intrusive notification
                self?.showClipboardNotification(hex: hexString)
            }
        }
    }
    
    /// Converts NSColor to HEX string representation.
    ///
    /// - Parameter color: The color to convert to HEX format
    /// - Returns: A HEX string in the format "#RRGGBB"
    private func colorToHex(_ color: NSColor) -> String {
        guard let rgbColor = color.usingColorSpace(.sRGB) else {
            return "#000000"
        }
        
        let red = Int(rgbColor.redComponent * 255)
        let green = Int(rgbColor.greenComponent * 255)
        let blue = Int(rgbColor.blueComponent * 255)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    /// Shows a modern, non-intrusive notification that the color was copied.
    ///
    /// - Parameter hex: The HEX code that was copied to the clipboard
    private func showClipboardNotification(hex: String) {
        let notification = ClipboardNotificationView(hex: hex)
        notification.show()
    }
    
    /// Handles "Preferences" menu item click.
    @objc private func preferencesClicked() {
        // TODO: Implement preferences window
    }
    
    /// Handles "About" menu item click.
    @objc private func aboutClicked() {
        // TODO: Implement about dialog
    }
    
    /// Handles "Quit" menu item click.
    @objc private func quitClicked() {
        NSApplication.shared.terminate(nil)
    }
}
