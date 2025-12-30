//
//  ClipboardNotificationView.swift
//  HexPal
//
//  Displays a modern, non-intrusive notification when a color is copied to clipboard.
//  Shows color swatch, HEX code, and auto-dismisses with smooth animation.
//

import Cocoa

/// A modern, non-intrusive notification view for clipboard copy confirmation.
///
/// Displays a sleek notification in the top-right corner of the screen showing
/// a color swatch and HEX code that was copied. Automatically dismisses after a short delay.
///
/// ## Usage
/// ```swift
/// let notification = ClipboardNotificationView(hex: "#FF5733")
/// notification.show()
/// ```
///
/// ## Visual Design
/// - Color swatch: 32x32 rounded square with border
/// - HEX code: Monospaced font, two-line layout
/// - Blur effect: HUD material for modern macOS look
/// - Animation: Smooth fade in/out transitions
class ClipboardNotificationView: NSView {
    
    // MARK: - Properties
    
    /// The HEX code to display
    private let hexCode: String
    
    /// The notification window
    private var notificationWindow: NSWindow?
    
    /// Timer for auto-dismissal
    private var dismissTimer: Timer?
    
    // MARK: - Initialization
    
    /// Creates a clipboard notification view.
    ///
    /// - Parameter hex: The HEX code that was copied to the clipboard
    init(hex: String) {
        self.hexCode = hex
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    /// Shows the notification with a smooth animation.
    ///
    /// Displays the notification in the top-right corner of the main screen
    /// and automatically dismisses it after 2 seconds.
    func show() {
        guard let mainScreen = NSScreen.main else { return }
        
        // Calculate position (top-right corner with padding)
        let padding: CGFloat = 20
        let width: CGFloat = 240
        let height: CGFloat = 60
        
        let screenFrame = mainScreen.visibleFrame
        let x = screenFrame.maxX - width - padding
        let y = screenFrame.maxY - height - padding
        
        let windowRect = NSRect(x: x, y: y, width: width, height: height)
        
        // Create borderless window
        let window = NSWindow(
            contentRect: windowRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.level = .floating
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        
        // Create content view
        let contentView = self
        contentView.frame = windowRect
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 12
        contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.95).cgColor
        
        // Add blur effect for modern look
        let visualEffect = NSVisualEffectView(frame: contentView.bounds)
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.blendingMode = .behindWindow
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 12
        contentView.addSubview(visualEffect, positioned: .below, relativeTo: nil)
        
        // Parse HEX code to NSColor for swatch
        let color = hexToColor(hexCode)
        
        // Create color swatch
        let swatchSize: CGFloat = 32
        let swatchPadding: CGFloat = 12
        let swatchX = swatchPadding
        let swatchY = (height - swatchSize) / 2
        
        let swatchView = NSView(frame: NSRect(x: swatchX, y: swatchY, width: swatchSize, height: swatchSize))
        swatchView.wantsLayer = true
        swatchView.layer?.backgroundColor = color.cgColor
        swatchView.layer?.cornerRadius = 6
        swatchView.layer?.borderWidth = 1.0
        swatchView.layer?.borderColor = NSColor.separatorColor.cgColor
        contentView.addSubview(swatchView)
        
        // Add HEX code label (positioned to the right of swatch)
        let labelX = swatchX + swatchSize + 12
        let labelWidth = width - labelX - swatchPadding
        let label = NSTextField(labelWithString: "Copied\n\(hexCode)")
        label.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelColor
        label.alignment = .left
        label.frame = NSRect(x: labelX, y: 8, width: labelWidth, height: 44)
        label.maximumNumberOfLines = 2
        contentView.addSubview(label)
        
        window.contentView = contentView
        notificationWindow = window
        
        // Animate in
        window.alphaValue = 0
        window.makeKeyAndOrderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 1.0
        }
        
        // Auto-dismiss after 2 seconds
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    /// Dismisses the notification with animation.
    private func dismiss() {
        guard let window = notificationWindow else { return }
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 0.0
        }, completionHandler: {
            window.close()
            self.notificationWindow = nil
        })
        
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
    
    // MARK: - Private Helpers
    
    /// Converts a HEX string to NSColor.
    ///
    /// Parses a HEX string in the format "#RRGGBB" or "RRGGBB" and converts it
    /// to an NSColor in sRGB color space.
    ///
    /// - Parameter hex: The HEX code string (with or without # prefix)
    /// - Returns: An NSColor representing the HEX code, or black (#000000) if parsing fails
    private func hexToColor(_ hex: String) -> NSColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove # if present
        if hexSanitized.hasPrefix("#") {
            hexSanitized = String(hexSanitized.dropFirst())
        }
        
        // Validate length
        guard hexSanitized.count == 6 else {
            return NSColor.black
        }
        
        // Parse RGB components
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return NSColor.black
        }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return NSColor(srgbRed: red, green: green, blue: blue, alpha: 1.0)
    }
}
