//
//  ColorConverterTests.swift
//  HexPalTests
//
//  Tests all ColorConverter format outputs using known reference values.
//

import XCTest
@testable import HexPal

final class ColorConverterTests: XCTestCase {

    // MARK: - hexString

    func test_hexString_pureRed_returnsFF0000() {
        let result = ColorConverter.hexString(r: 1, g: 0, b: 0)
        XCTAssertEqual(result, "#FF0000")
    }

    func test_hexString_pureWhite_returnsFFFFFF() {
        let result = ColorConverter.hexString(r: 1, g: 1, b: 1)
        XCTAssertEqual(result, "#FFFFFF")
    }

    func test_hexString_pureBlack_returns000000() {
        let result = ColorConverter.hexString(r: 0, g: 0, b: 0)
        XCTAssertEqual(result, "#000000")
    }

    func test_hexString_knownColor_returnsExpected() {
        let result = ColorConverter.hexString(r: 255/255.0, g: 87/255.0, b: 51/255.0)
        XCTAssertEqual(result, "#FF5733")
    }

    // MARK: - rgbString

    func test_rgbString_pureRed_returns255_0_0() {
        let result = ColorConverter.rgbString(r: 1, g: 0, b: 0)
        XCTAssertEqual(result, "rgb(255, 0, 0)")
    }

    func test_rgbString_pureWhite_returns255_255_255() {
        let result = ColorConverter.rgbString(r: 1, g: 1, b: 1)
        XCTAssertEqual(result, "rgb(255, 255, 255)")
    }

    // MARK: - hslString

    func test_hslString_pureRed_containsHue0() {
        let result = ColorConverter.hslString(r: 1, g: 0, b: 0)
        XCTAssertTrue(result.hasPrefix("hsl("))
        XCTAssertTrue(result.contains("100%"))
    }

    // MARK: - oklchString

    func test_oklchString_pureRed_containsOklchPrefix() {
        let result = ColorConverter.oklchString(r: 1, g: 0, b: 0)
        XCTAssertTrue(result.hasPrefix("oklch("))
    }

    // MARK: - cssCustomProperty

    func test_cssCustomProperty_defaultName_returnsPicked() {
        let result = ColorConverter.cssCustomProperty(r: 1, g: 0, b: 0)
        XCTAssertTrue(result.contains("--color-picked:"))
        XCTAssertTrue(result.contains("#FF0000"))
    }

    func test_cssCustomProperty_customName_usesName() {
        let result = ColorConverter.cssCustomProperty(r: 0, g: 0, b: 1, name: "primary")
        XCTAssertTrue(result.contains("--color-primary:"))
    }

    // MARK: - tailwindClass

    func test_tailwindClass_returnsBgHexFormat() {
        let result = ColorConverter.tailwindClass(r: 1, g: 0, b: 0)
        XCTAssertEqual(result, "bg-[#FF0000]")
    }

    // MARK: - swiftUIColor

    func test_swiftUIColor_pureRed_containsColorRed() {
        let result = ColorConverter.swiftUIColor(r: 1, g: 0, b: 0)
        XCTAssertTrue(result.hasPrefix("Color(red:"))
        XCTAssertTrue(result.contains("1.000"))
    }

    // MARK: - uiColorString

    func test_uiColorString_pureRed_containsUIColor() {
        let result = ColorConverter.uiColorString(r: 1, g: 0, b: 0)
        XCTAssertTrue(result.hasPrefix("UIColor(red:"))
        XCTAssertTrue(result.contains("alpha: 1.0"))
    }

    // MARK: - allFormats

    func test_allFormats_returnsAllEightFormats() {
        let result = ColorConverter.allFormats(r: 1, g: 0, b: 0)
        XCTAssertEqual(result.count, 8)
        let formats = result.map(\.format)
        XCTAssertTrue(formats.contains(.hex))
        XCTAssertTrue(formats.contains(.rgb))
        XCTAssertTrue(formats.contains(.hsl))
        XCTAssertTrue(formats.contains(.oklch))
        XCTAssertTrue(formats.contains(.cssCustomProperty))
        XCTAssertTrue(formats.contains(.tailwindClass))
        XCTAssertTrue(formats.contains(.swiftUIColor))
        XCTAssertTrue(formats.contains(.uiColor))
    }

    func test_allFormats_hexValueMatchesHexString() {
        let r: Double = 0.4
        let g: Double = 0.6
        let b: Double = 0.9
        let all = ColorConverter.allFormats(r: r, g: g, b: b)
        let hexEntry = all.first { $0.format == .hex }
        XCTAssertEqual(hexEntry?.value, ColorConverter.hexString(r: r, g: g, b: b))
    }

    // MARK: - Clamping

    func test_hexString_outOfRange_clampsToValid() {
        let result = ColorConverter.hexString(r: 1.5, g: -0.1, b: 0.5)
        XCTAssertEqual(result, "#FF0080")
    }

    // MARK: - Performance

    func test_conversionPerformance_1000Iterations() {
        measure {
            for i in 0..<1000 {
                let r = Double(i % 256) / 255
                let g = Double((i + 1) % 256) / 255
                let b = Double((i + 2) % 256) / 255
                _ = ColorConverter.allFormats(r: r, g: g, b: b)
            }
        }
    }
}
