//
//  AccessibleColorSuggesterTests.swift
//  HexPalTests
//
//  Tests the "Fix It" feature: nearest accessible shade.
//

import XCTest
@testable import HexPal

final class AccessibleColorSuggesterTests: XCTestCase {

    // MARK: - Already Passing

    func test_alreadyPassing_returnsOriginalColor() {
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let black = (r: 0.0, g: 0.0, b: 0.0)
        let result = AccessibleColorSuggester.suggest(
            r: black.r, g: black.g, b: black.b,
            against: white
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.r, 0, accuracy: 0.01)
        XCTAssertEqual(result!.g, 0, accuracy: 0.01)
        XCTAssertEqual(result!.b, 0, accuracy: 0.01)
    }

    // MARK: - Light Background Fixes

    func test_lightGrayOnWhite_suggestsDarkerShade() {
        let lightGray = (r: 0.85, g: 0.85, b: 0.85)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let result = AccessibleColorSuggester.suggest(
            r: lightGray.r, g: lightGray.g, b: lightGray.b,
            against: white
        )
        XCTAssertNotNil(result)
        let orig = OKLCHColor(fromSRGB: lightGray.r, lightGray.g, lightGray.b)
        let sugg = OKLCHColor(fromSRGB: result!.r, result!.g, result!.b)
        XCTAssertLessThan(sugg.lightness, orig.lightness)
    }

    func test_lightGrayOnWhite_suggestionPassesWCAG() {
        let lightGray = (r: 0.85, g: 0.85, b: 0.85)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let result = AccessibleColorSuggester.suggest(
            r: lightGray.r, g: lightGray.g, b: lightGray.b,
            against: white
        )
        XCTAssertNotNil(result)
        let ratio = WCAGContrastChecker.contrastRatio(
            foreground: (result!.r, result!.g, result!.b),
            background: white
        )
        XCTAssertGreaterThanOrEqual(ratio, 4.5)
    }

    // MARK: - Dark Background Fixes

    func test_darkGrayOnDark_suggestsLighterShade() {
        let darkGray = (r: 0.15, g: 0.15, b: 0.15)
        let darkBg = DualContextChecker.darkBackground
        let result = AccessibleColorSuggester.suggest(
            r: darkGray.r, g: darkGray.g, b: darkGray.b,
            against: darkBg
        )
        XCTAssertNotNil(result)
        let orig = OKLCHColor(fromSRGB: darkGray.r, darkGray.g, darkGray.b)
        let sugg = OKLCHColor(fromSRGB: result!.r, result!.g, result!.b)
        XCTAssertGreaterThan(sugg.lightness, orig.lightness)
    }

    func test_darkGrayOnDark_suggestionPassesWCAG() {
        let darkGray = (r: 0.15, g: 0.15, b: 0.15)
        let darkBg = DualContextChecker.darkBackground
        let result = AccessibleColorSuggester.suggest(
            r: darkGray.r, g: darkGray.g, b: darkGray.b,
            against: darkBg
        )
        XCTAssertNotNil(result)
        let ratio = WCAGContrastChecker.contrastRatio(
            foreground: (result!.r, result!.g, result!.b),
            background: darkBg
        )
        XCTAssertGreaterThanOrEqual(ratio, 4.5)
    }

    // MARK: - Hue and Chroma Preservation

    func test_suggestion_preservesHue() {
        let indigo300 = (165.0/255, 180.0/255, 252.0/255)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let result = AccessibleColorSuggester.suggest(
            r: indigo300.0, g: indigo300.1, b: indigo300.2,
            against: white
        )
        XCTAssertNotNil(result)
        let orig = OKLCHColor(fromSRGB: indigo300.0, indigo300.1, indigo300.2)
        let sugg = OKLCHColor(fromSRGB: result!.r, result!.g, result!.b)
        let hueDiff = abs(sugg.hue - orig.hue)
        let hueDiffWrap = min(hueDiff, 360 - hueDiff)
        XCTAssertLessThan(hueDiffWrap, 2)
    }

    func test_suggestion_preservesChroma() {
        let indigo300 = (165.0/255, 180.0/255, 252.0/255)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let result = AccessibleColorSuggester.suggest(
            r: indigo300.0, g: indigo300.1, b: indigo300.2,
            against: white
        )
        XCTAssertNotNil(result)
        let orig = OKLCHColor(fromSRGB: indigo300.0, indigo300.1, indigo300.2)
        let sugg = OKLCHColor(fromSRGB: result!.r, result!.g, result!.b)
        XCTAssertLessThan(abs(sugg.chroma - orig.chroma), 0.01)
    }

    // MARK: - Minimum Change

    func test_suggestion_minimumLightnessChange() {
        // Color that barely fails (~4.2:1)
        let barelyFails = (r: 0.55, g: 0.55, b: 0.55)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let ratioBefore = WCAGContrastChecker.contrastRatio(
            foreground: barelyFails,
            background: white
        )
        XCTAssertLessThan(ratioBefore, 4.5)
        let result = AccessibleColorSuggester.suggest(
            r: barelyFails.r, g: barelyFails.g, b: barelyFails.b,
            against: white
        )
        XCTAssertNotNil(result)
        let orig = OKLCHColor(fromSRGB: barelyFails.r, barelyFails.g, barelyFails.b)
        let sugg = OKLCHColor(fromSRGB: result!.r, result!.g, result!.b)
        XCTAssertLessThan(abs(sugg.lightness - orig.lightness), 0.1)
    }

    // MARK: - Custom Target Ratio

    func test_customTarget_AAA_7to1() {
        // Color that passes AA but fails AAA
        let passesAA = (r: 0.35, g: 0.35, b: 0.35)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let result = AccessibleColorSuggester.suggest(
            r: passesAA.r, g: passesAA.g, b: passesAA.b,
            against: white,
            targetRatio: 7.0
        )
        XCTAssertNotNil(result)
        let ratio = WCAGContrastChecker.contrastRatio(
            foreground: (result!.r, result!.g, result!.b),
            background: white
        )
        XCTAssertGreaterThanOrEqual(ratio, 7.0)
    }

    // MARK: - Edge Cases

    func test_pureWhiteOnWhite_suggestsDarkEnoughShade() {
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let result = AccessibleColorSuggester.suggest(
            r: white.r, g: white.g, b: white.b,
            against: white
        )
        XCTAssertNotNil(result)
        let ratio = WCAGContrastChecker.contrastRatio(
            foreground: (result!.r, result!.g, result!.b),
            background: white
        )
        XCTAssertGreaterThanOrEqual(ratio, 4.5)
    }

    func test_suggestion_sRGBValuesInRange() {
        let colors: [(Double, Double, Double)] = [
            (0.9, 0.9, 0.9),
            (0.2, 0.5, 0.8),
            (1, 0, 0),
            (0.1, 0.1, 0.1),
            (0.6, 0.3, 0.9),
        ]
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let darkBg = DualContextChecker.darkBackground
        for c in colors {
            if let r = AccessibleColorSuggester.suggest(r: c.0, g: c.1, b: c.2, against: white) {
                XCTAssertGreaterThanOrEqual(r.r, 0)
                XCTAssertLessThanOrEqual(r.r, 1)
                XCTAssertGreaterThanOrEqual(r.g, 0)
                XCTAssertLessThanOrEqual(r.g, 1)
                XCTAssertGreaterThanOrEqual(r.b, 0)
                XCTAssertLessThanOrEqual(r.b, 1)
            }
            if let r = AccessibleColorSuggester.suggest(r: c.0, g: c.1, b: c.2, against: darkBg) {
                XCTAssertGreaterThanOrEqual(r.r, 0)
                XCTAssertLessThanOrEqual(r.r, 1)
                XCTAssertGreaterThanOrEqual(r.g, 0)
                XCTAssertLessThanOrEqual(r.g, 1)
                XCTAssertGreaterThanOrEqual(r.b, 0)
                XCTAssertLessThanOrEqual(r.b, 1)
            }
        }
    }
}
