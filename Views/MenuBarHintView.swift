//
//  MenuBarHintView.swift
//  HexPal
//
//  Non-intrusive first-launch hint near the menu bar icon.
//  Shows "Click here or press ⌘⇧P to pick a color" - dismisses on first interaction.
//

import Cocoa

/// UserDefaults keys for first-time hint tracking.
enum FirstTimeHintKeys {
    static let hasShownMenuBarHint = "HexPal.hasShownMenuBarHint"
    static let hasShownRecentColorsHint = "HexPal.hasShownRecentColorsHint"
}

/// A small hint popover shown near the menu bar icon on first launch.
///
/// Dismisses when user clicks the menu bar icon or presses the hotkey.
/// Auto-dismisses after a few seconds. Uses same visual style as other notifications.
class MenuBarHintView {
    
    // MARK: - Properties
    
    private var hintWindow: NSWindow?
    private var dismissTimer: Timer?
    private static var activeHint: MenuBarHintView?
    private var hasCleanedUp = false
    
    // MARK: - Public Methods
    
    /// Shows the menu bar hint if first launch. Call after menu bar is set up.
    ///
    /// - Parameter hotkeyString: Formatted hotkey (e.g. "⌘⇧P") or empty if none
    static func showIfFirstLaunch(hotkeyString: String) {
        guard !UserDefaults.standard.bool(forKey: FirstTimeHintKeys.hasShownMenuBarHint) else {
            return
        }
        
        let hint = MenuBarHintView()
        hint.show(hotkeyString: hotkeyString)
    }
    
    /// Marks the menu bar hint as seen (call when user interacts).
    static func markMenuBarHintShown() {
        UserDefaults.standard.set(true, forKey: FirstTimeHintKeys.hasShownMenuBarHint)
    }
    
    /// Dismisses the hint if visible. Call when user clicks menu or uses hotkey.
    static func dismissIfVisible() {
        activeHint?.dismiss()
    }
    
    /// Resets hint flags (for testing).
    static func resetHints() {
        UserDefaults.standard.removeObject(forKey: FirstTimeHintKeys.hasShownMenuBarHint)
        UserDefaults.standard.removeObject(forKey: FirstTimeHintKeys.hasShownRecentColorsHint)
    }
    
    // MARK: - Private Methods
    
    private func show(hotkeyString: String) {
        MenuBarHintView.activeHint = self
        
        guard let screen = NSScreen.main else {
            MenuBarHintView.activeHint = nil
            return
        }
        
        let width: CGFloat = 220
        let height: CGFloat = 44
        let padding: CGFloat = 12
        
        // Position just below menu bar (top-right area where status items live)
        let screenFrame = screen.visibleFrame
        let x = screenFrame.maxX - width - padding
        let y = screenFrame.maxY - height - padding
        
        let windowRect = NSRect(x: x, y: y, width: width, height: height)
        
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
        
        let contentView = HintContentView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 10
        contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.95).cgColor
        
        let message = hotkeyString.isEmpty
            ? "Click the menu bar icon to pick a color"
            : "Click here or press \(hotkeyString) to pick a color"
        
        let label = NSTextField(labelWithString: message)
        label.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = NSColor.labelColor
        label.alignment = .center
        label.frame = NSRect(x: 12, y: 10, width: width - 24, height: 24)
        label.lineBreakMode = .byTruncatingTail
        contentView.addSubview(label)
        
        let visualEffect = NSVisualEffectView(frame: contentView.bounds)
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.blendingMode = .behindWindow
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 10
        visualEffect.autoresizingMask = [.width, .height]
        DispatchQueue.main.async {
            contentView.addSubview(visualEffect, positioned: .below, relativeTo: nil)
        }
        
        window.contentView = contentView
        hintWindow = window
        
        window.alphaValue = 0
        window.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            context.allowsImplicitAnimation = true
            window.animator().alphaValue = 1.0
        }
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    private func dismiss() {
        guard let window = hintWindow, !hasCleanedUp else { return }
        
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        MenuBarHintView.markMenuBarHintShown()
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            context.allowsImplicitAnimation = true
            window.animator().alphaValue = 0.0
        }, completionHandler: { [weak self] in
            self?.cleanup()
        })
    }
    
    private func cleanup() {
        guard !hasCleanedUp else { return }
        hasCleanedUp = true
        
        hintWindow?.orderOut(nil)
        hintWindow = nil
        MenuBarHintView.activeHint = nil
    }
    
    deinit {
        dismissTimer?.invalidate()
    }
}

// MARK: - Hint Content View

private class HintContentView: NSView {}
