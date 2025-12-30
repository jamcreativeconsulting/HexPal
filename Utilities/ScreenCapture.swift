//
//  ScreenCapture.swift
//  HexPal
//
//  Handles screen capture functionality for color picking.
//  Supports multiple displays and accurate pixel color extraction.
//

import Cocoa
import CoreGraphics

/// Handles screen capture and pixel color extraction.
///
/// This utility provides functionality to:
/// - Capture screen content from any display
/// - Extract pixel colors at specific screen coordinates
/// - Handle multiple display configurations correctly
/// - Convert colors to sRGB for accurate HEX representation
///
/// ## Usage
/// ```swift
/// let screenCapture = ScreenCapture()
/// if let color = screenCapture.getPixelColor(at: CGPoint(x: 100, y: 200)) {
///     print("Color at point: \(color)")
/// }
/// ```
///
/// ## Thread Safety
/// All methods should be called from the main thread.
///
/// ## Performance
/// Screen captures are performed on-demand. For repeated color picking,
/// consider caching the capture if performance becomes an issue.
///
/// - Warning: Requires Screen Recording permission. Will return nil if not granted.
class ScreenCapture {
    
    // MARK: - Public Methods
    
    /// Captures the entire screen content.
    ///
    /// Captures all displays in the system. For multi-display setups,
    /// this creates a composite image of all displays.
    ///
    /// - Returns: A CGImage representing the captured screen, or nil if capture fails
    /// - Note: Returns nil if Screen Recording permission is not granted
    func captureScreen() -> CGImage? {
        // Use CGWindowListCreateImage to capture entire screen
        // kCGWindowListOptionOnScreenOnly captures visible windows
        // kCGWindowListExcludeDesktopElements excludes desktop elements for cleaner capture
        let screenRect = getCombinedScreenBounds()
        
        guard let image = CGWindowListCreateImage(
            screenRect,
            .optionOnScreenOnly,
            kCGNullWindowID,
            .bestResolution
        ) else {
            return nil
        }
        
        return image
    }
    
    /// Captures a specific display by its index.
    ///
    /// - Parameter displayIndex: Zero-based index of the display to capture
    /// - Returns: A CGImage representing the captured display, or nil if capture fails
    /// - Note: Returns nil if display index is invalid or permission is not granted
    func captureDisplay(atIndex displayIndex: Int) -> CGImage? {
        let screens = NSScreen.screens
        
        guard displayIndex >= 0 && displayIndex < screens.count else {
            return nil
        }
        
        let screen = screens[displayIndex]
        let screenRect = screen.frame
        
        guard let image = CGWindowListCreateImage(
            screenRect,
            .optionOnScreenOnly,
            kCGNullWindowID,
            .bestResolution
        ) else {
            return nil
        }
        
        return image
    }
    
    /// Gets the pixel color at a specific screen coordinate.
    ///
    /// Automatically detects which display contains the point and captures
    /// that display to extract the color. Colors are converted to sRGB
    /// for accurate HEX representation.
    ///
    /// - Parameter point: Screen coordinates (origin at top-left)
    /// - Returns: NSColor at the specified point in sRGB color space, or nil if extraction fails
    /// - Note: Returns nil if Screen Recording permission is not granted
    /// - Note: Color accuracy may vary based on display color profile. Results are converted to sRGB.
    func getPixelColor(at point: CGPoint) -> NSColor? {
        // Find which display contains this point
        guard let containingScreen = getScreenContaining(point: point) else {
            return nil
        }
        
        // Capture the specific display
        guard let image = captureDisplay(containingScreen) else {
            return nil
        }
        
        // Convert point to display-local coordinates
        let localPoint = convertToLocalCoordinates(point: point, in: containingScreen)
        
        // Extract pixel color from image
        return extractPixelColor(from: image, at: localPoint)
    }
    
    /// Checks if Screen Recording permission is granted.
    ///
    /// - Returns: true if permission is granted, false otherwise
    func hasScreenRecordingPermission() -> Bool {
        // #region agent log
        NSLog("🔍 ScreenCapture: Checking screen recording permission")
        // #endregion
        
        // Attempt a small capture to check permission
        // If permission is not granted, CGWindowListCreateImage returns nil
        let testRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let testImage = CGWindowListCreateImage(
            testRect,
            .optionOnScreenOnly,
            kCGNullWindowID,
            .bestResolution
        )
        
        let hasPermission = testImage != nil
        
        // #region agent log
        NSLog("🔍 ScreenCapture: Permission check result: \(hasPermission)")
        // #endregion
        
        return hasPermission
    }
    
    // MARK: - Private Methods
    
    /// Gets the combined bounds of all screens.
    ///
    /// Returns a rectangle that encompasses all displays in the system.
    /// This is used for capturing the entire multi-display setup.
    private func getCombinedScreenBounds() -> CGRect {
        var combinedRect = CGRect.zero
        
        for screen in NSScreen.screens {
            combinedRect = combinedRect.union(screen.frame)
        }
        
        return combinedRect
    }
    
    /// Finds the screen that contains the specified point.
    ///
    /// - Parameter point: Screen coordinates to check
    /// - Returns: The NSScreen containing the point, or nil if point is outside all screens
    private func getScreenContaining(point: CGPoint) -> NSScreen? {
        for screen in NSScreen.screens {
            if screen.frame.contains(point) {
                return screen
            }
        }
        return nil
    }
    
    /// Captures a specific screen.
    ///
    /// - Parameter screen: The NSScreen to capture
    /// - Returns: A CGImage representing the captured screen, or nil if capture fails
    private func captureDisplay(_ screen: NSScreen) -> CGImage? {
        let screenRect = screen.frame
        
        guard let image = CGWindowListCreateImage(
            screenRect,
            .optionOnScreenOnly,
            kCGNullWindowID,
            .bestResolution
        ) else {
            return nil
        }
        
        return image
    }
    
    /// Converts screen coordinates to display-local coordinates.
    ///
    /// macOS uses a coordinate system where the origin is at the bottom-left
    /// of the primary display. This method converts global screen coordinates
    /// to coordinates relative to a specific display's frame.
    ///
    /// - Parameters:
    ///   - point: Global screen coordinates
    ///   - screen: The screen to convert coordinates for
    /// - Returns: Local coordinates relative to the screen's frame
    private func convertToLocalCoordinates(point: CGPoint, in screen: NSScreen) -> CGPoint {
        let screenFrame = screen.frame
        
        // Convert from global coordinates to screen-local coordinates
        // macOS origin is at bottom-left, but CGImage origin is at top-left
        let localX = point.x - screenFrame.origin.x
        let localY = point.y - screenFrame.origin.y
        
        // Convert Y coordinate: macOS Y increases upward, CGImage Y increases downward
        // Screen frame height minus local Y gives us the image-relative Y
        let imageY = screenFrame.height - localY
        
        return CGPoint(x: localX, y: imageY)
    }
    
    /// Extracts pixel color from a captured image at a specific point.
    ///
    /// - Parameters:
    ///   - image: The CGImage to extract color from
    ///   - point: Coordinates within the image (origin at top-left)
    /// - Returns: NSColor in sRGB color space, or nil if extraction fails
    private func extractPixelColor(from image: CGImage, at point: CGPoint) -> NSColor? {
        // Ensure point is within image bounds
        let width = image.width
        let height = image.height
        
        guard point.x >= 0 && point.x < CGFloat(width) &&
              point.y >= 0 && point.y < CGFloat(height) else {
            return nil
        }
        
        // Create a bitmap context to read pixel data
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel
        let bitsPerComponent = 8
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        guard let context = CGContext(
            data: &pixelData,
            width: 1,
            height: 1,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        
        // Draw the pixel at the specified point into our 1x1 context
        // Convert width/height to CGFloat for CGRect
        context.draw(
            image,
            in: CGRect(x: -point.x, y: -point.y, width: CGFloat(width), height: CGFloat(height))
        )
        
        // Extract RGB values (pixelData is RGBA)
        let red = CGFloat(pixelData[0]) / 255.0
        let green = CGFloat(pixelData[1]) / 255.0
        let blue = CGFloat(pixelData[2]) / 255.0
        let alpha = CGFloat(pixelData[3]) / 255.0
        
        // Create NSColor in sRGB color space for accurate HEX representation
        // HEX codes are always represented in sRGB color space
        guard let sRGBColorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            // Fallback to generic RGB if sRGB is unavailable
            return NSColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        // Create CGColor in sRGB color space, then convert to NSColor
        guard let cgColor = CGColor(colorSpace: sRGBColorSpace, components: [red, green, blue, alpha]) else {
            // Fallback if sRGB color creation fails
            return NSColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return NSColor(cgColor: cgColor)
    }
}
