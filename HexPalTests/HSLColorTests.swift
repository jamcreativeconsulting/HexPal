//
//  HSLColorTests.swift
//  HexPalTests
//
//  Tests HSL conversion from sRGB and cssString output.
//

import XCTest
@testable import HexPal

final class HSLColorTests: XCTestCase {

    // MARK: - Init from sRGB — Pure Colors

    func test_initFromSRGB_pureRed_returnsHue0Saturation100Lightness50() {
        let hsl = HSLColor(fromSRGB: 1, 0, 0)
        XCTAssertEqual(hsl.hue, 0, accuracy: 1)
        XCTAssertEqual(hsl.saturation, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsl.lightness, 0.5, accuracy: 0.01)
    }

    func test_initFromSRGB_pureGreen_returnsHue120() {
        let hsl = HSLColor(fromSRGB: 0, 1, 0)
        XCTAssertEqual(hsl.hue, 120, accuracy: 1)
        XCTAssertEqual(hsl.saturation, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsl.lightness, 0.5, accuracy: 0.01)
    }

    func test_initFromSRGB_pureBlue_returnsHue240() {
        let hsl = HSLColor(fromSRGB: 0, 0, 1)
        XCTAssertEqual(hsl.hue, 240, accuracy: 1)
        XCTAssertEqual(hsl.saturation, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsl.lightness, 0.5, accuracy: 0.01)
    }

    func test_initFromSRGB_pureBlack_returnsZeroLightness() {
        let hsl = HSLColor(fromSRGB: 0, 0, 0)
        XCTAssertEqual(hsl.lightness, 0, accuracy: 0.01)
        XCTAssertEqual(hsl.saturation, 0, accuracy: 0.01)
    }

    func test_initFromSRGB_pureWhite_returnsFullLightness() {
        let hsl = HSLColor(fromSRGB: 1, 1, 1)
        XCTAssertEqual(hsl.lightness, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsl.saturation, 0, accuracy: 0.01)
    }

    func test_initFromSRGB_midGray_returnsLowSaturation() {
        let hsl = HSLColor(fromSRGB: 0.5, 0.5, 0.5)
        XCTAssertEqual(hsl.saturation, 0, accuracy: 0.01)
        XCTAssertEqual(hsl.lightness, 0.5, accuracy: 0.01)
    }

    // MARK: - CSS String

    func test_cssString_pureRed_returnsExpectedFormat() {
        let hsl = HSLColor(fromSRGB: 1, 0, 0)
        let css = hsl.cssString
        XCTAssertTrue(css.hasPrefix("hsl("))
        XCTAssertTrue(css.hasSuffix("%)"))
        XCTAssertTrue(css.contains("100%"))
    }

    func test_cssString_midGray_returnsAchromatic() {
        let hsl = HSLColor(fromSRGB: 0.5, 0.5, 0.5)
        let css = hsl.cssString
        XCTAssertTrue(css.contains("50%"))
    }

    func test_cssString_customColor_returnsValidFormat() {
        let hsl = HSLColor(fromSRGB: 0.4, 0.6, 0.8)
        let css = hsl.cssString
        XCTAssertTrue(css.hasPrefix("hsl("))
        XCTAssertTrue(css.contains("%"))
    }
}
