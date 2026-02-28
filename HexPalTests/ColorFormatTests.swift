//
//  ColorFormatTests.swift
//  HexPalTests
//
//  Tests ColorFormat preferred persistence and string parsing.
//

import XCTest
@testable import HexPal

final class ColorFormatTests: XCTestCase {

    // MARK: - Preferred Format Persistence

    func test_preferred_formatRoundTripsCorrectly() {
        let defaults = UserDefaults.standard
        let key = ColorFormat.preferredFormatKey
        let original = defaults.string(forKey: key)

        defer {
            if let orig = original {
                defaults.set(orig, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }

        ColorFormat.preferred = .rgb
        XCTAssertEqual(ColorFormat.preferred, .rgb)

        ColorFormat.preferred = .hsl
        XCTAssertEqual(ColorFormat.preferred, .hsl)

        ColorFormat.preferred = .hex
        XCTAssertEqual(ColorFormat.preferred, .hex)
    }

    func test_preferred_unset_returnsHex() {
        let defaults = UserDefaults.standard
        let key = ColorFormat.preferredFormatKey
        let original = defaults.string(forKey: key)

        defer {
            if let orig = original {
                defaults.set(orig, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }

        defaults.removeObject(forKey: key)
        XCTAssertEqual(ColorFormat.preferred, .hex)
    }
}
