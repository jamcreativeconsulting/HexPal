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
class MenuBarController: NSObject {
    
    // MARK: - Properties
    
    /// The status item displayed in the menu bar
    private var statusItem: NSStatusItem?
    
    /// The menu displayed when clicking the menu bar icon
    private let menu = NSMenu()
    
    /// Color picker controller - retained during color picking operation
    private var colorPickerController: ColorPickerController?
    
    // MARK: - Initialization
    
    override init() { super.init()
        // Initialization handled by setupMenuBar()
    }
    
    // MARK: - Public Methods
    
    /// Sets up the menu bar icon and menu.
    ///
    /// Creates a status item in the menu bar and builds the menu structure.
    /// Should be called once during application startup.
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
        menu.autoenablesItems = false; menu.removeAllItems()
        
        // Pick Color
        let pickColorItem = NSMenuItem(
            title: "Pick Color",
            action: #selector(pickColorClicked(_:)),
            keyEquivalent: ""
        )
        menu.addItem(pickColorItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Preferences
        let preferencesItem = NSMenuItem(
            title: "Preferences...",
            action: #selector(preferencesClicked(_:)),
            keyEquivalent: ","
        )
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // About
        let aboutItem = NSMenuItem(
            title: "About HEXPal",
            action: #selector(aboutClicked(_:)),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(
            title: "Quit HEXPal",
            action: #selector(quitClicked(_:)),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
    }
    
    // MARK: - Menu Actions
    
    /// Handles click on the menu bar status item.
    @objc private func statusItemClicked() {
        // Menu is shown automatically when assigned to statusItem.menu
        // This method can be used for custom behavior if needed
    }
    
    /// Handles "Pick Color" menu item click.
    ///
    /// Activates the color picker overlay.
    /// This will be implemented in Phase 2 of development.
    @objc func pickColorClicked(_ sender: Any?) {
        
        // Use Apple's native color sampler (macOS 10.15+)
        // This is simpler and more reliable than custom overlay
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
                
                // Show confirmation
                self?.showColorConfirmation(hex: hexString)
            }
        }
    }
    
    /// Converts NSColor to HEX string
    private func colorToHex(_ color: NSColor) -> String {
        // Convert to sRGB color space for accurate HEX representation
        guard let rgbColor = color.usingColorSpace(.sRGB) else {
            return "#000000"
        }
        
        let red = Int(rgbColor.redComponent * 255)
        let green = Int(rgbColor.greenComponent * 255)
        let blue = Int(rgbColor.blueComponent * 255)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    /// Shows a confirmation that the color was copied
    private func showColorConfirmation(hex: String) {
        
        let alert = NSAlert()
        alert.messageText = "Color Copied!"
        alert.informativeText = "\(hex) has been copied to your clipboard."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    /// Handles "Preferences" menu item click.
    ///
    /// Opens the preferences window.
    /// This will be implemented in Phase 4 of development.
    @objc func preferencesClicked(_ sender: Any?) {
        // TODO: Implement preferences window
        // This will be implemented in Phase 4: Global Hotkey Integration
    }
    
    /// Handles "About" menu item click.
    ///
    /// Shows the about dialog with version and license information.
    @objc func aboutClicked(_ sender: Any?) {
        // TODO: Implement about dialog
        // This will be implemented in Phase 5: Polish & Testing
    }
    
    /// Handles "Quit" menu item click.
    ///
    /// Terminates the application.
    @objc func quitClicked(_ sender: Any?) {
        NSApplication.shared.terminate(nil)
    }
}
