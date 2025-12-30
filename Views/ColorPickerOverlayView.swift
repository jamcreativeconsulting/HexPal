//
//  ColorPickerOverlayView.swift
//  HexPal
//
//  Custom view for the color picker overlay window.
//  Handles mouse tracking and click events for color selection.
//

import Cocoa

/// Protocol for handling color picker overlay events.
protocol ColorPickerOverlayViewDelegate: AnyObject {
    /// Called when a color is selected at the specified point.
    ///
    /// - Parameters:
    ///   - view: The overlay view
    ///   - point: Screen coordinates where color was selected
    func overlayView(_ view: ColorPickerOverlayView, didSelectColorAt point: CGPoint)
    
    /// Called when color picker is cancelled (e.g., Escape key pressed).
    ///
    /// - Parameter view: The overlay view
    func overlayViewDidCancel(_ view: ColorPickerOverlayView)
}

/// Custom view for the color picker overlay window.
///
/// This view:
/// - Tracks mouse movement
/// - Handles click events for color selection
/// - Handles keyboard events (Escape to cancel)
/// - Provides visual feedback
class ColorPickerOverlayView: NSView {
    
    // MARK: - Properties
    
    /// Delegate for handling overlay events
    weak var delegate: ColorPickerOverlayViewDelegate?
    
    /// Tracks if mouse is currently being tracked
    private var isTrackingMouse = false
    
    // MARK: - Initialization
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    /// Sets up the view configuration.
    private func setupView() {
        // Make view transparent
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        
        // Enable mouse tracking
        wantsBestResolutionOpenGLSurface = true
    }
    
    // MARK: - Mouse Tracking
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        // Remove existing tracking areas
        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }
        
        // Add tracking area for entire view
        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeAlways, .mouseMoved, .mouseEnteredAndExited],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        
        // Update magnifying glass position (will be implemented in next step)
        // For now, just track mouse movement
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        // Get screen coordinates
        guard let window = window else {
            return
        }
        
        // Convert window coordinates to screen coordinates
        // macOS uses bottom-left origin, so we need to account for that
        let windowPoint = event.locationInWindow
        let screenRect = window.convertToScreen(NSRect(origin: windowPoint, size: .zero))
        
        // Convert to CGPoint (screen coordinates)
        let point = CGPoint(x: screenRect.origin.x, y: screenRect.origin.y)
        
        // Notify delegate of color selection
        delegate?.overlayView(self, didSelectColorAt: point)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        isTrackingMouse = true
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        isTrackingMouse = false
    }
    
    // MARK: - Keyboard Events
    
    override func keyDown(with event: NSEvent) {
        // Handle Escape key to cancel
        if event.keyCode == 53 { // Escape key
            delegate?.overlayViewDidCancel(self)
        } else {
            super.keyDown(with: event)
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
}
