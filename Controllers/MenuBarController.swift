//
//  MenuBarController.swift
//  HexPal
//
//  Manages the menu bar icon and dropdown menu for HEXPal.
//  Handles menu item clicks and application state.
//

import Cocoa
import KeyboardShortcuts

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
class MenuBarController: NSObject, NSMenuDelegate {
    
    // MARK: - Properties
    
    /// The status item displayed in the menu bar
    private var statusItem: NSStatusItem?
    
    /// The menu displayed when clicking the menu bar icon
    private let menu = NSMenu()
    
    /// Reference to the Recent Colors submenu for dynamic updates
    private var recentColorsSubmenu: NSMenu?

    /// Last picked color, used for "View contrast" panel
    private var lastPickedColor: PickedColor?

    /// Reference to View contrast menu item for enable/disable
    private var viewContrastItem: NSMenuItem?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(colorHistoryDidChange),
            name: ColorHistoryManager.historyDidChangeNotification,
            object: nil
        )
        
        // Wire the color-picked callback once at init time.
        // ColorPickerManager calls this on the main thread after a successful pick.
        ColorPickerManager.shared.onColorPicked = { [weak self] picked in
            guard let self = self else { return }
            self.lastPickedColor = picked
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            let value = picked.string(for: ColorFormat.preferred)
            pasteboard.setString(value, forType: .string)
            ColorHistoryManager.shared.addColor(picked.hex)
            self.showClipboardNotification(picked: picked)
            self.viewContrastItem?.isEnabled = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    /// Activates the color picker.
    ///
    /// Called by the hotkey handler and by menu-bar-level actions.
    /// Dismisses any first-run hint before presenting the system loupe.
    func activateColorPicker() {
        MenuBarHintView.dismissIfVisible()
        MenuBarHintView.markMenuBarHintShown()
        ColorPickerManager.shared.pickColor()
    }
    
    /// Sets up the menu bar icon and menu.
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else { return }
        
        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "HEXPal color picker") {
                button.image = image
                button.image?.isTemplate = true
            } else {
                button.title = "HEX"
            }
            button.setAccessibilityElement(true)
            button.setAccessibilityRole(.button)
            button.setAccessibilityLabel("HEXPal. Click to open menu and pick a color.")
            button.setAccessibilityHelp("Double-tap to open the HEXPal menu. Use the menu to pick a color or access preferences.")
        }
        
        buildMenu()
        menu.delegate = self
        statusItem.menu = menu
    }
    
    // MARK: - Private Methods
    
    private func buildMenu() {
        menu.removeAllItems()
        
        // Pick Color - shortcut syncs automatically with user's Preferences setting
        let pickColorItem = NSMenuItem(title: "Pick Color", action: #selector(pickColorClicked(_:)), keyEquivalent: "")
        pickColorItem.target = self
        pickColorItem.toolTip = "Opens the system color picker. Selected color is copied to clipboard as HEX."
        MainActor.assumeIsolated {
            pickColorItem.setShortcut(for: .pickColor)
        }
        menu.addItem(pickColorItem)

        let viewContrastItem = NSMenuItem(title: "View Contrast", action: #selector(viewContrastClicked), keyEquivalent: "")
        viewContrastItem.target = self
        viewContrastItem.toolTip = "Open contrast panel for last picked color. Shows WCAG/APCA results and accessible shade suggestions."
        viewContrastItem.isEnabled = lastPickedColor != nil
        self.viewContrastItem = viewContrastItem
        menu.addItem(viewContrastItem)
        
        // Recent Colors submenu
        let recentColorsItem = NSMenuItem(title: "Recent Colors", action: nil, keyEquivalent: "")
        recentColorsItem.toolTip = "Previously picked colors. Select one to copy its HEX code to the clipboard."
        recentColorsSubmenu = NSMenu()
        recentColorsItem.submenu = recentColorsSubmenu
        menu.addItem(recentColorsItem)
        
        updateRecentColorsSubmenu()
        
        menu.addItem(NSMenuItem.separator())
        
        // Preferences
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(preferencesClicked), keyEquivalent: ",")
        preferencesItem.target = self
        preferencesItem.toolTip = "Open preferences to change the pick color shortcut or launch at login."
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
        let hasShownRecentColorsHint = UserDefaults.standard.bool(forKey: FirstTimeHintKeys.hasShownRecentColorsHint)
        
        if history.hasColors {
            for hex in history.recentColors {
                let item = createColorMenuItem(hex: hex)
                submenu.addItem(item)
            }
            
            submenu.addItem(NSMenuItem.separator())
            
            // Clear History option
            let clearItem = NSMenuItem(title: "Clear History", action: #selector(clearHistoryClicked), keyEquivalent: "")
            clearItem.target = self
            clearItem.toolTip = "Remove all recent colors from history."
            submenu.addItem(clearItem)
        } else if !hasShownRecentColorsHint {
            let hintItem = NSMenuItem(title: "Your picked colors appear here", action: nil, keyEquivalent: "")
            hintItem.isEnabled = false
            submenu.addItem(hintItem)
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
        item.toolTip = "Copy \(hex) to clipboard. Double-tap to select."

        // Create color swatch image
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
    
    // MARK: - NSMenuDelegate
    
    func menuWillOpen(_ menu: NSMenu) {
        KeyboardShortcuts.disable(.pickColor)
        MenuBarHintView.dismissIfVisible()
        MenuBarHintView.markMenuBarHintShown()
        updateRecentColorsSubmenu()
        viewContrastItem?.isEnabled = lastPickedColor != nil
        UserDefaults.standard.set(true, forKey: FirstTimeHintKeys.hasShownRecentColorsHint)
    }

    func menuDidClose(_ menu: NSMenu) {
        KeyboardShortcuts.enable(.pickColor)
    }
    
    // MARK: - Menu Actions
    
    @objc private func pickColorClicked(_ sender: Any?) {
        ColorPickerManager.shared.pickColor()
    }
    
    @objc private func recentColorClicked(_ sender: NSMenuItem) {
        guard let hex = sender.representedObject as? String else { return }
        ColorHistoryManager.shared.copyToClipboard(hex)
        if let picked = PickedColor.fromHex(hex) {
            lastPickedColor = picked
            viewContrastItem?.isEnabled = true
            showClipboardNotification(picked: picked)
        }
    }

    @objc private func viewContrastClicked() {
        guard let picked = lastPickedColor else { return }
        ContrastPanelController.shared.show(picked: picked)
    }
    
    @objc private func clearHistoryClicked() {
        ColorHistoryManager.shared.clearHistory()
    }
    
    private func showClipboardNotification(picked: PickedColor) {
        let notification = ClipboardNotificationView(picked: picked)
        notification.show()
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
