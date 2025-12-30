//
//  ColorPickerController.swift
//  HexPal
//
//  Manages the color picker overlay and color selection workflow.
//  Handles full-screen overlay, mouse tracking, and color capture.
//

import Cocoa

/// Manages the color picker overlay and color selection workflow.
///
/// This controller handles:
/// - Creating and managing the full-screen overlay window
/// - Mouse tracking and cursor changes
/// - Color selection on click
/// - Integration with ScreenCapture utility
///
/// ## Usage
/// ```swift
/// let colorPicker = ColorPickerController()
/// colorPicker.activateColorPicker { selectedColor in
///     print("Selected color: \(selectedColor)")
/// }
/// ```
///
/// ## Thread Safety
/// All methods must be called from the main thread.
class ColorPickerController {
    
    // MARK: - Properties
    
    /// The overlay window that covers the entire screen
    private var overlayWindow: NSWindow?
    
    /// Screen capture utility for extracting pixel colors
    private let screenCapture = ScreenCapture()
    
    /// Callback invoked when a color is selected
    private var colorSelectionCallback: ((NSColor?) -> Void)?
    
    /// Tracks if color picker is currently active
    private var isActive = false
    
    // MARK: - Public Methods
    
    /// Activates the color picker overlay.
    ///
    /// Creates a full-screen overlay window and begins tracking mouse movement.
    /// The overlay will capture the color at the clicked location.
    ///
    /// - Parameter completion: Callback invoked with the selected color, or nil if cancelled
    func activateColorPicker(completion: @escaping (NSColor?) -> Void) {
        debugLog("🎨 ColorPickerController: activateColorPicker called")
        
        // Check if already active
        guard !isActive else {
            debugLog("⚠️ ColorPickerController: Already active, returning")
            return
        }
        
        // TEMPORARILY SKIP permission check to debug overlay issue
        debugLog("🎨 ColorPickerController: Skipping permission check for now")
        
        isActive = true
        colorSelectionCallback = completion
        
        // Create and show overlay window
        debugLog("🎨 ColorPickerController: Creating overlay window")
        createOverlayWindow()
        
        debugLog("🎨 ColorPickerController: overlayWindow = \(overlayWindow != nil ? "created" : "nil")")
        
        if let window = overlayWindow {
            debugLog("🎨 ColorPickerController: Window frame = \(window.frame)")
            debugLog("🎨 ColorPickerController: Window level = \(window.level.rawValue)")
            
            // Make window visible
            window.makeKeyAndOrderFront(nil)
            
            // Ensure app is active
            NSApp.activate(ignoringOtherApps: true)
            
            debugLog("🎨 ColorPickerController: Window visible = \(window.isVisible)")
        } else {
            debugLog("❌ ColorPickerController: overlayWindow is nil!")
        }
        
        // Change cursor to crosshair
        NSCursor.crosshair.push()
        
        debugLog("✅ ColorPickerController: Color picker activation complete")
        
        // Start monitoring events
        startEventMonitoring()
    }
    
    /// Deactivates the color picker overlay.
    ///
    /// Dismisses the overlay window and restores normal cursor.
    func deactivateColorPicker() {
        guard isActive else {
            return
        }
        
        isActive = false
        
        // Restore cursor
        NSCursor.pop()
        
        // Close overlay window
        overlayWindow?.close()
        overlayWindow = nil
        
        // Stop monitoring events
        stopEventMonitoring()
        
        // Clear callback
        colorSelectionCallback = nil
    }
    
    // MARK: - Private Methods
    
    /// Creates the full-screen overlay window.
    ///
    /// Creates a transparent, borderless window that covers all screens.
    /// The window is configured to be click-through and capture mouse events.
    private func createOverlayWindow() {
        debugLog("🎨 createOverlayWindow: Starting")
        
        // Get the main screen bounds (simpler approach)
        guard let mainScreen = NSScreen.main else {
            debugLog("❌ createOverlayWindow: No main screen found!")
            return
        }
        
        let screenFrame = mainScreen.frame
        debugLog("🎨 createOverlayWindow: Main screen frame = \(screenFrame)")
        
        // Create borderless window
        debugLog("🎨 createOverlayWindow: Creating NSWindow")
        let window = NSWindow(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        debugLog("🎨 createOverlayWindow: Configuring window")
        
        // Configure window properties
        window.level = .floating
        window.backgroundColor = NSColor.red.withAlphaComponent(0.3) // RED tint for debugging visibility
        window.isOpaque = false
        window.hasShadow = false
        window.ignoresMouseEvents = false
        window.acceptsMouseMovedEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        debugLog("🎨 createOverlayWindow: Creating content view")
        
        // Create content view
        let contentView = ColorPickerOverlayView(frame: screenFrame)
        contentView.delegate = self
        window.contentView = contentView
        
        // Make the window key window
        window.makeFirstResponder(contentView)
        
        debugLog("✅ createOverlayWindow: Window created successfully")
        
        overlayWindow = window
    }
    
    /// Starts monitoring mouse and keyboard events.
    ///
    /// Sets up event monitoring to track mouse movement and handle clicks.
    private func startEventMonitoring() {
        // Event monitoring is handled by the overlay view
        // This method can be extended for global event monitoring if needed
    }
    
    /// Stops monitoring mouse and keyboard events.
    private func stopEventMonitoring() {
        // Cleanup handled by deactivateColorPicker
    }
    
    /// Shows an alert requesting Screen Recording permission.
    private func showPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = "Screen Recording Permission Required"
        alert.informativeText = """
        HEXPal needs Screen Recording permission to pick colors from your screen.
        
        Please grant permission in System Settings:
        1. Open System Settings
        2. Go to Privacy & Security
        3. Select Screen Recording
        4. Enable HEXPal
        """
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Settings")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            // Open System Settings to Screen Recording section
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    /// Handles color selection at a specific point.
    ///
    /// - Parameter point: Screen coordinates where color was selected
    private func handleColorSelection(at point: CGPoint) {
        // Extract color at point
        guard let color = screenCapture.getPixelColor(at: point) else {
            // Failed to extract color
            colorSelectionCallback?(nil)
            deactivateColorPicker()
            return
        }
        
        // Invoke callback with selected color
        colorSelectionCallback?(color)
        
        // Deactivate picker
        deactivateColorPicker()
    }
}

// MARK: - ColorPickerOverlayViewDelegate

extension ColorPickerController: ColorPickerOverlayViewDelegate {
    func overlayView(_ view: ColorPickerOverlayView, didSelectColorAt point: CGPoint) {
        handleColorSelection(at: point)
    }
    
    func overlayViewDidCancel(_ view: ColorPickerOverlayView) {
        colorSelectionCallback?(nil)
        deactivateColorPicker()
    }
}
