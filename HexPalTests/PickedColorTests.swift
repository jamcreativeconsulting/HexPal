//
//  PickedColorTests.swift
//  HexPalTests
//
//  Tests PickedColor format API, fromHex, and Identifiable.
//

import XCTest
@testable import HexPal

final class PickedColorTests: XCTestCase {

    // MARK: - fromHex

    func test_fromHex_validHex_returnsPickedColor() {
        guard let picked = PickedColor.fromHex("#FF0000") else {
            XCTFail("Expected non-nil PickedColor")
            return
        }
        XCTAssertEqual(picked.hex, "#FF0000")
        XCTAssertEqual(picked.r, 1.0, accuracy: 0.01)
        XCTAssertEqual(picked.g, 0, accuracy: 0.01)
        XCTAssertEqual(picked.b, 0, accuracy: 0.01)
    }

    func test_fromHex_withoutHash_parsesCorrectly() {
        guard let picked = PickedColor.fromHex("00FF00") else {
            XCTFail("Expected non-nil PickedColor")
            return
        }
        XCTAssertEqual(picked.hex, "#00FF00")
    }

    func test_fromHex_invalidLength_returnsNil() {
        XCTAssertNil(PickedColor.fromHex("#FFF"))
        XCTAssertNil(PickedColor.fromHex("#FFFFFF00"))
    }

    func test_fromHex_invalidCharacters_returnsNil() {
        XCTAssertNil(PickedColor.fromHex("#GGGGGG"))
    }

    // MARK: - Format API

    func test_stringFor_hex_returnsHexFormat() {
        guard let picked = PickedColor.fromHex("#FF5733") else { XCTFail(); return }
        let result = picked.string(for: .hex)
        XCTAssertEqual(result, "#FF5733")
    }

    func test_stringFor_rgb_returnsRGBFormat() {
        guard let picked = PickedColor.fromHex("#FF0000") else { XCTFail(); return }
        let result = picked.string(for: .rgb)
        XCTAssertEqual(result, "rgb(255, 0, 0)")
    }

    func test_allFormats_returnsAllFormats() {
        guard let picked = PickedColor.fromHex("#FF0000") else { XCTFail(); return }
        let all = picked.allFormats
        XCTAssertEqual(all.count, 8)
    }

    // MARK: - Identifiable

    func test_id_isUnique() {
        guard let picked1 = PickedColor.fromHex("#FF0000"),
              let picked2 = PickedColor.fromHex("#FF0000") else { XCTFail(); return }
        XCTAssertNotEqual(picked1.id, picked2.id)
    }

    func test_timestamp_isSet() {
        let before = Date()
        guard let picked = PickedColor.fromHex("#FF0000") else { XCTFail(); return }
        let after = Date()
        XCTAssertGreaterThanOrEqual(picked.timestamp.timeIntervalSince1970, before.timeIntervalSince1970 - 0.1)
        XCTAssertLessThanOrEqual(picked.timestamp.timeIntervalSince1970, after.timeIntervalSince1970 + 0.1)
    }
}
