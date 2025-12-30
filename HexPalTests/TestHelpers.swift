//
//  TestHelpers.swift
//  HexPalTests
//
//  Test helper utilities and mock objects for HEXPal unit tests.
//  Provides reusable test utilities and mock implementations.
//

import XCTest
import AppKit

/// Test helper utilities for HEXPal tests.
///
/// Provides common test utilities, mock objects, and helper functions
/// to simplify test writing and reduce code duplication.
enum TestHelpers {
    
    // MARK: - Color Test Utilities
    
    /// Creates a test NSColor with specified RGB values.
    ///
    /// - Parameters:
    ///   - red: Red component (0.0 - 1.0)
    ///   - green: Green component (0.0 - 1.0)
    ///   - blue: Blue component (0.0 - 1.0)
    ///   - alpha: Alpha component (0.0 - 1.0), defaults to 1.0
    /// - Returns: NSColor with specified RGB values in sRGB color space
    static func createTestColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> NSColor {
        return NSColor(
            calibratedRed: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
    
    /// Creates a test NSColor from HEX string.
    ///
    /// - Parameter hex: HEX string in format "#RRGGBB" or "RRGGBB"
    /// - Returns: NSColor representation of the HEX color, or nil if invalid
    /// - Note: This is a test helper. Actual HEX conversion will be tested separately.
    static func createColorFromHex(_ hex: String) -> NSColor? {
        // TODO: Implement when ColorConverter is created
        // This will be implemented in Phase 3: HEX Conversion & Display
        return nil
    }
    
    // MARK: - Assertion Helpers
    
    /// Asserts that two colors are approximately equal within tolerance.
    ///
    /// Useful for testing color conversions where slight floating-point differences may occur.
    ///
    /// - Parameters:
    ///   - color1: First color to compare
    ///   - color2: Second color to compare
    ///   - tolerance: Maximum allowed difference per component (default: 0.01)
    ///   - message: Optional failure message
    static func assertColorsEqual(
        _ color1: NSColor,
        _ color2: NSColor,
        tolerance: CGFloat = 0.01,
        _ message: String = "Colors should be equal",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let c1 = color1.usingColorSpace(.sRGB) ?? color1
        let c2 = color2.usingColorSpace(.sRGB) ?? color2
        
        let redDiff = abs(c1.redComponent - c2.redComponent)
        let greenDiff = abs(c1.greenComponent - c2.greenComponent)
        let blueDiff = abs(c1.blueComponent - c2.blueComponent)
        let alphaDiff = abs(c1.alphaComponent - c2.alphaComponent)
        
        XCTAssert(
            redDiff <= tolerance && greenDiff <= tolerance && blueDiff <= tolerance && alphaDiff <= tolerance,
            "\(message) - Red: \(redDiff), Green: \(greenDiff), Blue: \(blueDiff), Alpha: \(alphaDiff)",
            file: file,
            line: line
        )
    }
    
    // MARK: - Performance Helpers
    
    /// Measures execution time of a block and verifies it meets performance target.
    ///
    /// - Parameters:
    ///   - targetTime: Maximum allowed execution time in seconds
    ///   - block: Block of code to measure
    ///   - message: Optional failure message
    static func assertPerformance(
        targetTime: TimeInterval,
        _ message: String = "Operation exceeded performance target",
        file: StaticString = #file,
        line: UInt = #line,
        block: () -> Void
    ) {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        XCTAssert(
            executionTime <= targetTime,
            "\(message) - Execution time: \(executionTime)s, Target: \(targetTime)s",
            file: file,
            line: line
        )
    }
}
