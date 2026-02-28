//
//  OKLCHColorTests.swift
//  HexPalTests
//
//  Tests OKLCH conversion against oklch.org and Bottosson Oklab reference.
//

import XCTest
@testable import HexPal

final class OKLCHColorTests: XCTestCase {

    // MARK: - Init from sRGB

    func test_initFromSRGB_pureBlack_returnsNearZeroLightness() {
        let oklch = OKLCHColor(fromSRGB: 0, 0, 0)
        XCTAssertEqual(oklch.lightness, 0, accuracy: 0.01)
        XCTAssertEqual(oklch.chroma, 0, accuracy: 0.01)
    }

    func test_initFromSRGB_pureWhite_returnsUnitLightnessZeroChroma() {
        let oklch = OKLCHColor(fromSRGB: 1, 1, 1)
        XCTAssertEqual(oklch.lightness, 1, accuracy: 0.001)
        XCTAssertEqual(oklch.chroma, 0, accuracy: 0.001)
    }

    func test_initFromSRGB_pureRed_returnsExpectedOklch() {
        let oklch = OKLCHColor(fromSRGB: 1, 0, 0)
        XCTAssertEqual(oklch.lightness, 0.628, accuracy: 0.02)
        XCTAssertEqual(oklch.chroma, 0.258, accuracy: 0.02)
        XCTAssertEqual(oklch.hue, 29.2, accuracy: 5)
    }

    func test_initFromSRGB_midGray_returnsLowChroma() {
        let gray = 0.5
        let oklch = OKLCHColor(fromSRGB: gray, gray, gray)
        XCTAssertEqual(oklch.lightness, 0.598, accuracy: 0.02)
        XCTAssertEqual(oklch.chroma, 0, accuracy: 0.01)
    }

    // MARK: - Init from OKLCH

    func test_initFromOKLCH_storesValues() {
        let oklch = OKLCHColor(lightness: 0.5, chroma: 0.2, hue: 180)
        XCTAssertEqual(oklch.lightness, 0.5, accuracy: 0)
        XCTAssertEqual(oklch.chroma, 0.2, accuracy: 0)
        XCTAssertEqual(oklch.hue, 180, accuracy: 0)
    }

    // MARK: - toSRGB

    func test_toSRGB_pureWhite_returnsOneOneOne() {
        let oklch = OKLCHColor(lightness: 1, chroma: 0, hue: 0)
        let srgb = oklch.toSRGB()
        XCTAssertEqual(srgb.r, 1, accuracy: 0.01)
        XCTAssertEqual(srgb.g, 1, accuracy: 0.01)
        XCTAssertEqual(srgb.b, 1, accuracy: 0.01)
    }

    func test_toSRGB_pureBlack_returnsZeroZeroZero() {
        let oklch = OKLCHColor(lightness: 0, chroma: 0, hue: 0)
        let srgb = oklch.toSRGB()
        XCTAssertEqual(srgb.r, 0, accuracy: 0.01)
        XCTAssertEqual(srgb.g, 0, accuracy: 0.01)
        XCTAssertEqual(srgb.b, 0, accuracy: 0.01)
    }

    func test_toSRGB_clampsToZeroOne() {
        let oklch = OKLCHColor(lightness: 0.8, chroma: 0.4, hue: 0)
        let srgb = oklch.toSRGB()
        XCTAssertGreaterThanOrEqual(srgb.r, 0)
        XCTAssertLessThanOrEqual(srgb.r, 1)
        XCTAssertGreaterThanOrEqual(srgb.g, 0)
        XCTAssertLessThanOrEqual(srgb.g, 1)
        XCTAssertGreaterThanOrEqual(srgb.b, 0)
        XCTAssertLessThanOrEqual(srgb.b, 1)
    }

    // MARK: - Round-Trip

    func test_roundTrip_sRGBToOKLCHToSRGB_preservesColor() {
        let orig = (r: 0.4, g: 0.6, b: 0.9)
        let oklch = OKLCHColor(fromSRGB: orig.r, orig.g, orig.b)
        let back = oklch.toSRGB()
        XCTAssertEqual(back.r, orig.r, accuracy: 0.02)
        XCTAssertEqual(back.g, orig.g, accuracy: 0.02)
        XCTAssertEqual(back.b, orig.b, accuracy: 0.02)
    }

    func test_roundTrip_OKLCHToSRGBToOKLCH_preservesInGamut() {
        let orig = OKLCHColor(lightness: 0.6, chroma: 0.15, hue: 250)
        let srgb = orig.toSRGB()
        let back = OKLCHColor(fromSRGB: srgb.r, srgb.g, srgb.b)
        XCTAssertEqual(back.lightness, orig.lightness, accuracy: 0.02)
        XCTAssertEqual(back.chroma, orig.chroma, accuracy: 0.02)
        XCTAssertEqual(back.hue, orig.hue, accuracy: 5)
    }

    // MARK: - Hue Range

    func test_hue_isInZeroTo360() {
        let oklch = OKLCHColor(fromSRGB: 0.9, 0.3, 0.5)
        XCTAssertGreaterThanOrEqual(oklch.hue, 0)
        XCTAssertLessThanOrEqual(oklch.hue, 360)
    }

    // MARK: - CSS String Output

    func test_cssString_formatsCorrectly() {
        let oklch = OKLCHColor(lightness: 0.628, chroma: 0.258, hue: 29.2)
        let css = oklch.cssString
        XCTAssertTrue(css.hasPrefix("oklch("))
        XCTAssertTrue(css.hasSuffix(")"))
        XCTAssertTrue(css.contains("62.8%"))
    }

    func test_cssString_achromatic_handlesZeroChroma() {
        let oklch = OKLCHColor(lightness: 0.534, chroma: 0, hue: 0)
        let css = oklch.cssString
        XCTAssertEqual(css, "oklch(53.4% 0.0000 0.0)")
    }

    // MARK: - Performance

    func test_conversionPerformance_1000Iterations() {
        measure {
            for i in 0..<1000 {
                let r = Double(i % 256) / 255
                let g = Double((i + 1) % 256) / 255
                let b = Double((i + 2) % 256) / 255
                let oklch = OKLCHColor(fromSRGB: r, g, b)
                _ = oklch.toSRGB()
            }
        }
    }
}
