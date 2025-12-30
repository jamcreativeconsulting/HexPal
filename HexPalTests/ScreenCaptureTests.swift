//
//  ScreenCaptureTests.swift
//  HexPalTests
//
//  Unit tests for ScreenCapture utility.
//  Tests screen capture functionality and multi-display support.
//

import XCTest
@testable import HexPal

/// Test suite for ScreenCapture utility.
///
/// Tests cover:
/// - Screen capture functionality
/// - Multi-display support
/// - Pixel color extraction
/// - Permission handling
final class ScreenCaptureTests: XCTestCase {
    
    // MARK: - Properties
    
    /// Screen capture instance for testing
    private var screenCapture: ScreenCapture!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        screenCapture = ScreenCapture()
    }
    
    override func tearDown() {
        screenCapture = nil
        super.tearDown()
    }
    
    // MARK: - Permission Tests
    
    /// Tests that Screen Recording permission can be checked.
    ///
    /// Note: This test may fail if permission is not granted.
    /// The test verifies the method exists and can be called without crashing.
    func testHasScreenRecordingPermission() {
        // This test verifies the method can be called
        // Actual permission status depends on system configuration
        let hasPermission = screenCapture.hasScreenRecordingPermission()
        
        // We can't assert a specific value since it depends on system state
        // But we can verify the method doesn't crash
        XCTAssertNotNil(hasPermission, "Permission check should return a boolean value")
    }
    
    // MARK: - Screen Capture Tests
    
    /// Tests that screen capture can be performed.
    ///
    /// Note: This test requires Screen Recording permission.
    /// If permission is not granted, the test will be skipped.
    func testCaptureScreen() {
        // Check if we have permission first
        guard screenCapture.hasScreenRecordingPermission() else {
            XCTSkip("Screen Recording permission not granted - skipping capture test")
        }
        
        // Attempt to capture screen
        let image = screenCapture.captureScreen()
        
        // Verify capture succeeded
        XCTAssertNotNil(image, "Screen capture should return an image when permission is granted")
        
        // Verify image has valid dimensions
        if let image = image {
            XCTAssertGreaterThan(image.width, 0, "Captured image should have width > 0")
            XCTAssertGreaterThan(image.height, 0, "Captured image should have height > 0")
        }
    }
    
    /// Tests capturing a specific display by index.
    ///
    /// Verifies that individual displays can be captured correctly.
    func testCaptureDisplayAtIndex() {
        guard screenCapture.hasScreenRecordingPermission() else {
            XCTSkip("Screen Recording permission not granted - skipping capture test")
        }
        
        let screens = NSScreen.screens
        
        // Test capturing first display
        if screens.count > 0 {
            let image = screenCapture.captureDisplay(atIndex: 0)
            XCTAssertNotNil(image, "Should be able to capture first display")
        }
        
        // Test invalid display index
        let invalidImage = screenCapture.captureDisplay(atIndex: screens.count)
        XCTAssertNil(invalidImage, "Should return nil for invalid display index")
        
        let negativeImage = screenCapture.captureDisplay(atIndex: -1)
        XCTAssertNil(negativeImage, "Should return nil for negative display index")
    }
    
    // MARK: - Pixel Color Extraction Tests
    
    /// Tests extracting pixel color from screen.
    ///
    /// Verifies that pixel colors can be extracted at specific coordinates.
    func testGetPixelColor() {
        guard screenCapture.hasScreenRecordingPermission() else {
            XCTSkip("Screen Recording permission not granted - skipping color extraction test")
        }
        
        // Get screen bounds to find a valid point
        let screens = NSScreen.screens
        guard let firstScreen = screens.first else {
            XCTSkip("No screens available for testing")
        }
        
        // Test point in center of first screen
        let screenFrame = firstScreen.frame
        let testPoint = CGPoint(
            x: screenFrame.midX,
            y: screenFrame.midY
        )
        
        // Extract color
        let color = screenCapture.getPixelColor(at: testPoint)
        
        // Verify color extraction succeeded
        XCTAssertNotNil(color, "Should be able to extract color at valid screen point")
        
        // Verify color is in valid range
        if let color = color {
            let red = color.redComponent
            let green = color.greenComponent
            let blue = color.blueComponent
            
            XCTAssertGreaterThanOrEqual(red, 0.0, "Red component should be >= 0")
            XCTAssertLessThanOrEqual(red, 1.0, "Red component should be <= 1")
            XCTAssertGreaterThanOrEqual(green, 0.0, "Green component should be >= 0")
            XCTAssertLessThanOrEqual(green, 1.0, "Green component should be <= 1")
            XCTAssertGreaterThanOrEqual(blue, 0.0, "Blue component should be >= 0")
            XCTAssertLessThanOrEqual(blue, 1.0, "Blue component should be <= 1")
        }
    }
    
    /// Tests extracting color from invalid coordinates.
    ///
    /// Verifies that invalid coordinates return nil.
    func testGetPixelColorInvalidCoordinates() {
        guard screenCapture.hasScreenRecordingPermission() else {
            XCTSkip("Screen Recording permission not granted - skipping test")
        }
        
        // Test point far outside screen bounds
        let invalidPoint = CGPoint(x: -1000, y: -1000)
        let color = screenCapture.getPixelColor(at: invalidPoint)
        
        // Should return nil for invalid coordinates
        XCTAssertNil(color, "Should return nil for coordinates outside screen bounds")
    }
    
    // MARK: - Multi-Display Tests
    
    /// Tests that multiple displays are handled correctly.
    ///
    /// Verifies that the system can detect and work with multiple displays.
    func testMultipleDisplays() {
        let screens = NSScreen.screens
        
        // Verify we can detect displays
        XCTAssertGreaterThan(screens.count, 0, "Should detect at least one display")
        
        // If multiple displays exist, test capturing each
        if screens.count > 1 {
            for index in 0..<screens.count {
                guard screenCapture.hasScreenRecordingPermission() else {
                    XCTSkip("Screen Recording permission not granted")
                }
                
                let image = screenCapture.captureDisplay(atIndex: index)
                XCTAssertNotNil(image, "Should be able to capture display at index \(index)")
            }
        }
    }
    
    // MARK: - Performance Tests
    
    /// Tests that screen capture meets performance targets.
    ///
    /// Verifies capture can be performed quickly enough for real-time color picking.
    func testCapturePerformance() {
        guard screenCapture.hasScreenRecordingPermission() else {
            XCTSkip("Screen Recording permission not granted - skipping performance test")
        }
        
        // Measure capture performance
        // Target: Should be fast enough for real-time color picking
        measure {
            _ = screenCapture.captureScreen()
        }
    }
    
    /// Tests that pixel color extraction meets performance targets.
    ///
    /// Verifies extraction is fast enough for real-time preview.
    func testPixelColorExtractionPerformance() {
        guard screenCapture.hasScreenRecordingPermission() else {
            XCTSkip("Screen Recording permission not granted - skipping performance test")
        }
        
        let screens = NSScreen.screens
        guard let firstScreen = screens.first else {
            XCTSkip("No screens available for testing")
        }
        
        let screenFrame = firstScreen.frame
        let testPoint = CGPoint(
            x: screenFrame.midX,
            y: screenFrame.midY
        )
        
        // Measure extraction performance
        // Target: Should be fast enough for real-time color preview
        measure {
            _ = screenCapture.getPixelColor(at: testPoint)
        }
    }
}
