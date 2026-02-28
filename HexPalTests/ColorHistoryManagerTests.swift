//
//  ColorHistoryManagerTests.swift
//  HexPalTests
//
//  Unit tests for ColorHistoryManager. Verifies add, clear, hasColors, and normalization.
//

import XCTest
@testable import HexPal

/// Tests for ColorHistoryManager.
final class ColorHistoryManagerTests: XCTestCase {

    private var manager: ColorHistoryManager { ColorHistoryManager.shared }

    override func setUp() {
        super.setUp()
        manager.clearHistory()
    }

    // MARK: - Add Color

    func test_addColor_singleHex_addsToRecentColors() {
        manager.addColor("#FF0000")
        XCTAssertEqual(manager.recentColors, ["#FF0000"])
    }

    func test_addColor_multipleColors_ordersMostRecentFirst() {
        manager.addColor("#FF0000")
        manager.addColor("#00FF00")
        manager.addColor("#0000FF")
        XCTAssertEqual(manager.recentColors, ["#0000FF", "#00FF00", "#FF0000"])
    }

    func test_addColor_duplicateHex_movesToFront() {
        manager.addColor("#FF0000")
        manager.addColor("#00FF00")
        manager.addColor("#FF0000")
        XCTAssertEqual(manager.recentColors, ["#FF0000", "#00FF00"])
    }

    func test_addColor_withoutHash_normalizesWithHashPrefix() {
        manager.addColor("FF5733")
        XCTAssertEqual(manager.recentColors.first, "#FF5733")
    }

    func test_addColor_maxColors_truncatesToListSize() {
        for i in 0..<12 {
            manager.addColor(String(format: "#%06X", i))
        }
        XCTAssertEqual(manager.recentColors.count, 10)
        XCTAssertEqual(manager.recentColors.first, "#00000B")  // Last added
    }

    // MARK: - Has Colors

    func test_hasColors_empty_returnsFalse() {
        XCTAssertFalse(manager.hasColors)
    }

    func test_hasColors_withColors_returnsTrue() {
        manager.addColor("#FF0000")
        XCTAssertTrue(manager.hasColors)
    }

    // MARK: - Clear History

    func test_clearHistory_removesAllColors() {
        manager.addColor("#FF0000")
        manager.addColor("#00FF00")
        manager.clearHistory()
        XCTAssertTrue(manager.recentColors.isEmpty)
        XCTAssertFalse(manager.hasColors)
    }

    // MARK: - Copy to Clipboard

    func test_copyToClipboard_validHex_returnsTrue() {
        let result = manager.copyToClipboard("#FF5733")
        XCTAssertTrue(result)
    }
}
