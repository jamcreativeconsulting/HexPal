//
//  ClipboardNotificationView.swift
//  HexPal
//
//  Displays a modern, non-intrusive notification when a color is copied to clipboard.
//  Shows color swatch, checkmark, and HEX code. Auto-dismisses with smooth fade animation.
//  Supports click-to-copy and hover-to-pause interactions.
//

import Cocoa

// MARK: - Interactive Content View

/// Custom view that handles mouse events for the notification.
private class InteractiveNotificationView: NSView {
    var onClicked: (() -> Void)?
    var onMouseEntered: (() -> Void)?
    var onMouseExited: (() -> Void)?
    private var trackingArea: NSTrackingArea?
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let existing = trackingArea { removeTrackingArea(existing) }
        trackingArea = NSTrackingArea(
            rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        if let area = trackingArea { addTrackingArea(area) }
    }
    
    override func mouseDown(with event: NSEvent) { onClicked?() }
    
    override func mouseEntered(with event: NSEvent) {
        onMouseEntered?()
        NSCursor.pointingHand.push()
    }
    
    override func mouseExited(with event: NSEvent) {
        onMouseExited?()
        NSCursor.pop()
    }
}

// MARK: - Clipboard Notification View

/// A modern, non-intrusive notification for clipboard copy confirmation.
///
/// Displays a sleek notification in the top-right corner of the screen showing
/// a color swatch, checkmark indicator, and HEX code. Uses minimal text with
/// universal visual language (✓ = success). Automatically dismisses after a short delay
/// with a smooth fade animation. Appears on the screen where the mouse is located.
///
/// ## Features
/// - **Click to copy**: Clicking the notification re-copies the HEX code
/// - **Hover to pause**: Mouse hover pauses the auto-dismiss timer
///
/// ## Usage
/// ```swift
/// let notification = ClipboardNotificationView(hex: "#FF5733")
/// notification.show()
/// ```
class ClipboardNotificationView {

    // MARK: - Layout Constants

    private static let dismissInterval: TimeInterval = 2.0
    private static let width: CGFloat = 180
    private static let height: CGFloat = 56
    private static let padding: CGFloat = 20
    private static let cornerRadius: CGFloat = 12

    // MARK: - Properties

    /// The HEX code to display
    private let hexCode: String

    /// The notification window
    private var notificationWindow: NSWindow?

    /// Timer for auto-dismissal
    private var dismissTimer: Timer?

    /// Time remaining when timer was paused (for hover-to-pause)
    private var remainingTime: TimeInterval = ClipboardNotificationView.dismissInterval
    
    /// Timestamp when timer was paused
    private var pausedAt: Date?
    
    /// Self-reference to prevent deallocation during animation
    /// Set during show(), cleared after dismiss animation completes
    private static var activeNotification: ClipboardNotificationView?
    
    /// Flag to prevent double cleanup
    private var hasCleanedUp = false
    
    /// Tooltip label reference for "⌘V to paste" hint
    private var tooltipLabel: NSTextField?
    
    // MARK: - Initialization
    
    /// Creates a clipboard notification.
    ///
    /// - Parameter hex: The HEX code that was copied to the clipboard
    init(hex: String) {
        self.hexCode = hex
    }
    
    deinit {
        // Just invalidate timer if somehow still active
        dismissTimer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Shows the notification with a smooth fade-in animation.
    ///
    /// Displays the notification in the top-right corner of the screen where the mouse is located
    /// and automatically dismisses it after 2 seconds with a fade-out animation.
    func show() {
        // Retain self to prevent deallocation during animation lifecycle
        ClipboardNotificationView.activeNotification = self
        
        // Find the screen containing the current mouse location
        let mouseLocation = NSEvent.mouseLocation
        let targetScreen = NSScreen.screens.first { screen in
            screen.frame.contains(mouseLocation)
        } ?? NSScreen.main
        
        guard let screen = targetScreen else {
            ClipboardNotificationView.activeNotification = nil
            return
        }
        
        // Calculate position (top-right corner with padding)
        let screenFrame = screen.visibleFrame
        let x = screenFrame.maxX - ClipboardNotificationView.width - ClipboardNotificationView.padding
        let y = screenFrame.maxY - ClipboardNotificationView.height - ClipboardNotificationView.padding

        let windowRect = NSRect(x: x, y: y, width: ClipboardNotificationView.width, height: ClipboardNotificationView.height)
        
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
        window.ignoresMouseEvents = false  // Enable mouse events for click/hover
        // Don't use .canJoinAllSpaces - it can cause wrong screen placement
        window.collectionBehavior = [.transient]
        window.title = "HEXPal color copied"  // VoiceOver reads window title when focus moves to window
        
        // Create interactive content view for click and hover support
        let contentView = InteractiveNotificationView(frame: NSRect(x: 0, y: 0, width: ClipboardNotificationView.width, height: ClipboardNotificationView.height))
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = ClipboardNotificationView.cornerRadius
        contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.95).cgColor

        // VoiceOver (WCAG 2.2 AA): Announce copied color and interaction
        contentView.setAccessibilityElement(true)
        contentView.setAccessibilityRole(.button)
        contentView.setAccessibilityLabel("Color \(hexCode) copied to clipboard. Success.")
        contentView.setAccessibilityHelp("Double-tap to copy \(hexCode) to clipboard again. Press Escape to dismiss.")

        // Wire up interaction callbacks
        contentView.onClicked = { [weak self] in
            self?.copyToClipboard()
        }
        contentView.onMouseEntered = { [weak self] in
            self?.pauseTimer()
        }
        contentView.onMouseExited = { [weak self] in
            self?.resumeTimer()
        }
        
        // Add blur effect - defer to next run loop to avoid layout recursion
        // (NSVisualEffectView can trigger layoutSubtreeIfNeeded during parent's layout pass)
        let visualEffect = NSVisualEffectView(frame: contentView.bounds)
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.blendingMode = .behindWindow
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 12
        visualEffect.autoresizingMask = [.width, .height]
        visualEffect.setAccessibilityElement(false)  // Decorative; VoiceOver skips
        DispatchQueue.main.async {
            contentView.addSubview(visualEffect, positioned: .below, relativeTo: nil)
        }
        
        // Parse HEX code to NSColor for swatch
        let color = NSColor.fromHex(hexCode)
        
        // Create color swatch
        let swatchSize: CGFloat = 28
        let swatchPadding: CGFloat = 12
        let swatchX = swatchPadding
        let swatchY = (ClipboardNotificationView.height - swatchSize) / 2
        
        let swatchView = NSView(frame: NSRect(x: swatchX, y: swatchY, width: swatchSize, height: swatchSize))
        swatchView.wantsLayer = true
        swatchView.layer?.backgroundColor = color.cgColor
        swatchView.layer?.cornerRadius = 6
        swatchView.layer?.borderWidth = 1.0
        swatchView.layer?.borderColor = NSColor.separatorColor.cgColor
        swatchView.setAccessibilityElement(true)
        swatchView.setAccessibilityRole(.image)
        swatchView.setAccessibilityLabel("Color swatch for \(hexCode)")
        contentView.addSubview(swatchView)
        
        // Create checkmark indicator (success confirmation)
        let checkmarkSize: CGFloat = 16
        let checkmarkX = swatchX + swatchSize + 10
        let checkmarkY = (ClipboardNotificationView.height - checkmarkSize) / 2
        
        let checkmarkLabel = NSTextField(labelWithString: "✓")
        checkmarkLabel.font = NSFont.systemFont(ofSize: 14, weight: .semibold)
        checkmarkLabel.textColor = NSColor.systemGreen
        checkmarkLabel.frame = NSRect(x: checkmarkX, y: checkmarkY, width: checkmarkSize, height: checkmarkSize)
        checkmarkLabel.alignment = .center
        checkmarkLabel.setAccessibilityElement(true)
        checkmarkLabel.setAccessibilityRole(.staticText)
        checkmarkLabel.setAccessibilityLabel("Copied successfully")
        contentView.addSubview(checkmarkLabel)
        
        // HEX code label - monospace, clean, primary color
        let hexLabelX = checkmarkX + checkmarkSize + 8
        let hexLabelWidth = ClipboardNotificationView.width - hexLabelX - swatchPadding
        
        let hexLabel = NSTextField(labelWithString: hexCode)
        hexLabel.font = NSFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        hexLabel.textColor = NSColor.labelColor
        hexLabel.frame = NSRect(x: hexLabelX, y: (ClipboardNotificationView.height - 20) / 2, width: hexLabelWidth, height: 20)
        hexLabel.alignment = .left
        hexLabel.setAccessibilityElement(true)
        hexLabel.setAccessibilityRole(.staticText)
        hexLabel.setAccessibilityLabel("HEX code \(hexCode)")
        contentView.addSubview(hexLabel)
        
        window.contentView = contentView
        notificationWindow = window
        
        // Show window with fade-in animation
        window.alphaValue = 0
        window.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            context.allowsImplicitAnimation = true
            window.animator().alphaValue = 1.0
        }
        
        // Auto-dismiss after 2 seconds
        startDismissTimer(interval: ClipboardNotificationView.dismissInterval)
    }
    
    // MARK: - Private Methods
    
    /// Copies the HEX code to the clipboard (for click-to-copy).
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(hexCode, forType: .string)
        
        // Show "⌘V to paste" tooltip
        showPasteTooltip()
        
        // Brief visual feedback - flash the checkmark
        if let contentView = notificationWindow?.contentView {
            for subview in contentView.subviews {
                if let textField = subview as? NSTextField, textField.stringValue == "✓" {
                    // Quick flash animation for feedback
                    NSAnimationContext.runAnimationGroup { context in
                        context.duration = 0.1
                        textField.animator().alphaValue = 0.5
                    } completionHandler: {
                        NSAnimationContext.runAnimationGroup { context in
                            context.duration = 0.1
                            textField.animator().alphaValue = 1.0
                        }
                    }
                    break
                }
            }
        }
    }
    
    /// Shows a brief "⌘V to paste" tooltip below the notification.
    private func showPasteTooltip() {
        guard let contentView = notificationWindow?.contentView else { return }
        tooltipLabel?.removeFromSuperview()
        
        let tooltip = NSTextField(labelWithString: "⌘V to paste")
        tooltip.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        tooltip.textColor = NSColor.secondaryLabelColor
        tooltip.alignment = .center
        tooltip.alphaValue = 0
        tooltip.setAccessibilityElement(true)
        tooltip.setAccessibilityRole(.staticText)
        tooltip.setAccessibilityLabel("Press Command V to paste")
        tooltip.frame = NSRect(x: (contentView.bounds.width - 80) / 2, y: 8, width: 80, height: 16)
        contentView.addSubview(tooltip)
        tooltipLabel = tooltip
        
        // Fade in, wait 1.2s, fade out
        NSAnimationContext.runAnimationGroup({ $0.duration = 0.15; tooltip.animator().alphaValue = 1 }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                NSAnimationContext.runAnimationGroup({ $0.duration = 0.2; self?.tooltipLabel?.animator().alphaValue = 0 }) {
                    self?.tooltipLabel?.removeFromSuperview()
                    self?.tooltipLabel = nil
                }
            }
        }
    }
    
    /// Starts the dismiss timer with the specified interval.
    private func startDismissTimer(interval: TimeInterval) {
        remainingTime = interval
        pausedAt = nil
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    /// Pauses the dismiss timer (for hover-to-pause).
    private func pauseTimer() {
        guard let timer = dismissTimer, timer.isValid else { return }
        
        // Calculate remaining time
        let fireDate = timer.fireDate
        remainingTime = max(0.5, fireDate.timeIntervalSinceNow)
        pausedAt = Date()
        
        // Invalidate the timer
        timer.invalidate()
        dismissTimer = nil
    }
    
    /// Resumes the dismiss timer after hover ends.
    private func resumeTimer() {
        guard pausedAt != nil else { return }
        
        // Restart timer with remaining time
        dismissTimer = Timer.scheduledTimer(withTimeInterval: remainingTime, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
        pausedAt = nil
    }
    
    /// Dismisses the notification with a fade-out animation.
    private func dismiss() {
        guard let window = notificationWindow else { return }
        
        // Simple fade-out animation
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            context.allowsImplicitAnimation = true
            window.animator().alphaValue = 0.0
        }, completionHandler: { [weak self] in
            self?.cleanup()
        })
    }
    
    /// Cleans up resources. Guarded to prevent double cleanup.
    private func cleanup() {
        // Guard against double cleanup
        guard !hasCleanedUp else { return }
        hasCleanedUp = true
        
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        // Hide window instead of closing to avoid Core Animation conflicts
        notificationWindow?.orderOut(nil)
        notificationWindow = nil
        
        // Release self-reference to allow deallocation
        ClipboardNotificationView.activeNotification = nil
    }
}
