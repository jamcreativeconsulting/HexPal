//
//  HexPalTests.swift
//  HexPalTests
//
//  Unit tests for HEXPal application.
//  Tests core singletons, shortcut configuration, and baseline behavior.
//

import XCTest
import KeyboardShortcuts
@testable import HexPal

/// Main test suite for HEXPal.
///
/// This test suite covers:
/// - Shortcut name configuration (KeyboardShortcuts)
/// - ColorPickerManager singleton
/// - HotkeyManager singleton and start()
/// - Baseline performance
final class HexPalTests: XCTestCase {

    // MARK: - Shortcut Configuration

    /// Verifies pickColor shortcut is defined with the correct name.
    func testPickColorShortcutExistsWithCorrectDefault() {
        XCTAssertEqual(KeyboardShortcuts.Name.pickColor.rawValue, "pickColor")
    }

    // MARK: - Singletons

    /// Verifies ColorPickerManager.shared exists and can be referenced.
    func testColorPickerManagerSharedExists() {
        let manager = ColorPickerManager.shared
        XCTAssertNotNil(manager)
    }

    /// Verifies HotkeyManager.shared exists and start() can be called without crash.
    func testHotkeyManagerStartDoesNotCrash() {
        HotkeyManager.shared.start()
    }

    // MARK: - Sanity & Performance

    /// Verifies the test framework is operational.
    func testFrameworkSanity() {
        XCTAssertTrue(true)
    }

    /// Baseline performance measurement.
    func testBaselinePerformance() {
        measure {}
    }
}
