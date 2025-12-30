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
class MenuBarController {
    
    // MARK: - Properties
    
    /// The status item displayed in the menu bar
    private var statusItem: NSStatusItem?
    
    /// The menu displayed when clicking the menu bar icon
    private let menu = NSMenu()
    
    // MARK: - Initialization
    
    init() {
        // Initialization handled by setupMenuBar()
    }
    
    // MARK: - Public Methods
    
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
            action: #selector(pickColorClicked),
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
        // This method can be used for custom behavior if needed
    }
    
    /// Handles "Pick Color" menu item click.
    ///
    /// Activates the color picker overlay.
    /// This will be implemented in Phase 2 of development.
    @objc private func pickColorClicked() {
        // TODO: Implement color picker activation
        // This will be implemented in Phase 2: Screen Capture & Color Picking
    }
    
    /// Handles "Preferences" menu item click.
    ///
    /// Opens the preferences window.
    /// This will be implemented in Phase 4 of development.
    @objc private func preferencesClicked() {
        // TODO: Implement preferences window
        // This will be implemented in Phase 4: Global Hotkey Integration
    }
    
    /// Handles "About" menu item click.
    ///
    /// Shows the about dialog with version and license information.
    @objc private func aboutClicked() {
        // TODO: Implement about dialog
        // This will be implemented in Phase 5: Polish & Testing
    }
    
    /// Handles "Quit" menu item click.
    ///
    /// Terminates the application.
    @objc private func quitClicked() {
        NSApplication.shared.terminate(nil)
    }
}
