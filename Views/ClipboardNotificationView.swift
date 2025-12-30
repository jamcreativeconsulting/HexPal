//
//  ClipboardNotificationView.swift
//  HexPal
//
//  Displays a modern, non-intrusive notification when a color is copied to clipboard.
//  Shows HEX code with a subtle animation and auto-dismisses.
//

import Cocoa

/// A modern, non-intrusive notification view for clipboard copy confirmation.
///
/// Displays a sleek notification in the top-right corner of the screen showing
/// the HEX code that was copied. Automatically dismisses after a short delay.
///
/// ## Usage
/// ```swift
/// let notification = ClipboardNotificationView(hex: "#FF5733")
/// notification.show()
/// ```
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
        let width: CGFloat = 200
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
        
        // Add HEX code label
        let label = NSTextField(labelWithString: "Copied: \(hexCode)")
        label.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        label.textColor = .labelColor
        label.alignment = .center
        label.frame = NSRect(x: 0, y: 15, width: width, height: 30)
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
}
