//
//  WelcomeNotificationView.swift
//  HexPal
//
//  Displays a modern welcome notification on first launch.
//  Shows the hotkey and guides new users on how to use the app.
//

import Cocoa

/// A modern welcome notification shown on first launch.
///
/// Displays a sleek notification introducing HEXPal and showing the hotkey
/// for picking colors. Only shown once on first launch, tracked via UserDefaults.
///
/// ## Features
/// - Shows app name and tagline
/// - Displays the hotkey (⌘⇧P) prominently
/// - Auto-dismisses after a few seconds or on click
/// - Click anywhere to dismiss
///
/// ## Usage
/// ```swift
/// WelcomeNotificationView.showIfFirstLaunch()
/// ```
class WelcomeNotificationView {

    // MARK: - Constants

    /// UserDefaults key to track if welcome has been shown
    private static let hasShownWelcomeKey = "HexPal.hasShownWelcome"

    /// Layout constants for the welcome notification
    private static let width: CGFloat = 280
    private static let height: CGFloat = 100
    private static let padding: CGFloat = 60
    private static let cornerRadius: CGFloat = 16

    // MARK: - Properties

    private var notificationWindow: NSWindow?
    private var dismissTimer: Timer?
    private static var activeNotification: WelcomeNotificationView?
    private var hasCleanedUp = false
    
    // MARK: - Public Methods
    
    /// Shows the welcome notification if this is the first launch.
    /// Uses UserDefaults to track whether the welcome has been shown.
    static func showIfFirstLaunch() {
        let hasShown = UserDefaults.standard.bool(forKey: hasShownWelcomeKey)
        
        if !hasShown {
            let welcome = WelcomeNotificationView()
            welcome.show()
            
            // Mark as shown
            UserDefaults.standard.set(true, forKey: hasShownWelcomeKey)
        }
    }
    
    /// Resets the first launch flag (for testing purposes).
    static func resetFirstLaunch() {
        UserDefaults.standard.removeObject(forKey: hasShownWelcomeKey)
    }
    
    // MARK: - Private Methods
    
    /// Shows the welcome notification with a smooth fade-in animation.
    private func show() {
        WelcomeNotificationView.activeNotification = self
        
        // Get the main screen
        guard let screen = NSScreen.main else {
            WelcomeNotificationView.activeNotification = nil
            return
        }
        
        // Calculate position (center-top of screen)
        let screenFrame = screen.visibleFrame
        let x = screenFrame.midX - (WelcomeNotificationView.width / 2)
        let y = screenFrame.maxY - WelcomeNotificationView.height - WelcomeNotificationView.padding

        let windowRect = NSRect(x: x, y: y, width: WelcomeNotificationView.width, height: WelcomeNotificationView.height)
        
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
        window.ignoresMouseEvents = false
        window.collectionBehavior = [.transient]
        
        // Create interactive content view
        let contentView = ClickableView(frame: NSRect(x: 0, y: 0, width: WelcomeNotificationView.width, height: WelcomeNotificationView.height))
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = WelcomeNotificationView.cornerRadius
        contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.98).cgColor
        contentView.onClicked = { [weak self] in
            self?.dismiss()
        }
        
        // Add blur effect - defer to next run loop to avoid layout recursion
        // (NSVisualEffectView can trigger layoutSubtreeIfNeeded during parent's layout pass)
        let visualEffect = NSVisualEffectView(frame: contentView.bounds)
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.blendingMode = .behindWindow
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = WelcomeNotificationView.cornerRadius
        visualEffect.autoresizingMask = [.width, .height]
        DispatchQueue.main.async {
            contentView.addSubview(visualEffect, positioned: .below, relativeTo: nil)
        }
        
        // App icon/emoji
        let iconLabel = NSTextField(labelWithString: "🎨")
        iconLabel.font = NSFont.systemFont(ofSize: 28)
        iconLabel.frame = NSRect(x: 20, y: WelcomeNotificationView.height - 50, width: 40, height: 36)
        contentView.addSubview(iconLabel)
        
        // Welcome text
        let welcomeLabel = NSTextField(labelWithString: "Welcome to HEXPal")
        welcomeLabel.font = NSFont.systemFont(ofSize: 16, weight: .semibold)
        welcomeLabel.textColor = NSColor.labelColor
        welcomeLabel.frame = NSRect(x: 62, y: WelcomeNotificationView.height - 42, width: 200, height: 22)
        contentView.addSubview(welcomeLabel)
        
        // Tagline
        let taglineLabel = NSTextField(labelWithString: "Pick colors. Get HEX. Instantly.")
        taglineLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        taglineLabel.textColor = NSColor.secondaryLabelColor
        taglineLabel.frame = NSRect(x: 62, y: WelcomeNotificationView.height - 62, width: 200, height: 18)
        contentView.addSubview(taglineLabel)
        
        // Hotkey hint with styled background
        let hotkeyContainer = NSView(frame: NSRect(x: 20, y: 12, width: WelcomeNotificationView.width - 40, height: 28))
        hotkeyContainer.wantsLayer = true
        hotkeyContainer.layer?.cornerRadius = 8
        hotkeyContainer.layer?.backgroundColor = NSColor.quaternaryLabelColor.cgColor
        contentView.addSubview(hotkeyContainer)
        
        // Hotkey text
        let hotkeyLabel = NSTextField(labelWithString: "Press ⌘⇧P to pick a color")
        hotkeyLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        hotkeyLabel.textColor = NSColor.labelColor
        hotkeyLabel.alignment = .center
        hotkeyLabel.frame = NSRect(x: 0, y: 4, width: WelcomeNotificationView.width - 40, height: 20)
        hotkeyContainer.addSubview(hotkeyLabel)
        
        window.contentView = contentView
        notificationWindow = window
        
        // Show with fade-in animation
        window.alphaValue = 0
        window.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            context.allowsImplicitAnimation = true
            window.animator().alphaValue = 1.0
        }
        
        // Auto-dismiss after 5 seconds
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    /// Dismisses the notification with a fade-out animation.
    private func dismiss() {
        guard let window = notificationWindow, !hasCleanedUp else { return }
        
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            context.allowsImplicitAnimation = true
            window.animator().alphaValue = 0.0
        }, completionHandler: { [weak self] in
            self?.cleanup()
        })
    }
    
    /// Cleans up resources.
    private func cleanup() {
        guard !hasCleanedUp else { return }
        hasCleanedUp = true
        
        notificationWindow?.orderOut(nil)
        notificationWindow = nil
        WelcomeNotificationView.activeNotification = nil
    }
    
    deinit {
        dismissTimer?.invalidate()
    }
}

// MARK: - Clickable View

/// Simple view that handles click events.
private class ClickableView: NSView {
    var onClicked: (() -> Void)?
    
    override func mouseDown(with event: NSEvent) {
        onClicked?()
    }
}
