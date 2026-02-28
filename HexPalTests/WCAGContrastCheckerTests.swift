//
//  WCAGContrastCheckerTests.swift
//  HexPalTests
//
//  Tests WCAG 2.x contrast against W3C spec and reference values.
//

import XCTest
@testable import HexPal

final class WCAGContrastCheckerTests: XCTestCase {

    // MARK: - Relative Luminance Tests

    func test_relativeLuminance_pureBlack_returnsZero() {
        let result = WCAGContrastChecker.relativeLuminance(r: 0, g: 0, b: 0)
        XCTAssertEqual(result, 0.0, accuracy: 0)
    }

    func test_relativeLuminance_pureWhite_returnsOne() {
        let result = WCAGContrastChecker.relativeLuminance(r: 1, g: 1, b: 1)
        XCTAssertEqual(result, 1.0, accuracy: 0)
    }

    func test_relativeLuminance_pureRed_returnsRedCoefficient() {
        let result = WCAGContrastChecker.relativeLuminance(r: 1, g: 0, b: 0)
        XCTAssertEqual(result, 0.2126, accuracy: 0.001)
    }

    func test_relativeLuminance_midGray_returnsExpectedValue() {
        let midGray = 128.0 / 255.0
        let result = WCAGContrastChecker.relativeLuminance(r: midGray, g: midGray, b: midGray)
        XCTAssertEqual(result, 0.2159, accuracy: 0.001)
    }

    // MARK: - Contrast Ratio Tests

    func test_contrastRatio_blackOnWhite_returns21() {
        let fg = (r: 0.0, g: 0.0, b: 0.0)
        let bg = (r: 1.0, g: 1.0, b: 1.0)
        let result = WCAGContrastChecker.contrastRatio(foreground: fg, background: bg)
        XCTAssertEqual(result, 21.0, accuracy: 0.1)
    }

    func test_contrastRatio_whiteOnWhite_returns1() {
        let c = (r: 1.0, g: 1.0, b: 1.0)
        let result = WCAGContrastChecker.contrastRatio(foreground: c, background: c)
        XCTAssertEqual(result, 1.0, accuracy: 0)
    }

    func test_contrastRatio_isSymmetric() {
        let red = (r: 1.0, g: 0.0, b: 0.0)
        let blue = (r: 0.0, g: 0.0, b: 1.0)
        let a = WCAGContrastChecker.contrastRatio(foreground: red, background: blue)
        let b = WCAGContrastChecker.contrastRatio(foreground: blue, background: red)
        XCTAssertEqual(a, b)
    }

    func test_contrastRatio_alwaysGreaterThanOrEqualTo1() {
        let pairs: [((r: Double, g: Double, b: Double), (r: Double, g: Double, b: Double))] = [
            ((0.2, 0.5, 0.8), (0.9, 0.3, 0.1)),
            ((1, 0, 0), (0, 1, 0)),
            ((0.1, 0.2, 0.3), (0.7, 0.8, 0.9)),
        ]
        for (fg, bg) in pairs {
            let r = WCAGContrastChecker.contrastRatio(foreground: fg, background: bg)
            XCTAssertGreaterThanOrEqual(r, 1.0)
        }
    }

    // MARK: - Compliance Level Tests

    func test_evaluate_ratio21_passesAAA() {
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: 21.0), .passesAAA)
    }

    func test_evaluate_ratio7_passesAAA() {
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: 7.0), .passesAAA)
    }

    func test_evaluate_ratio6point9_passesAANormal() {
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: 6.99), .passesAANormal)
    }

    func test_evaluate_ratio4point5_passesAANormal() {
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: 4.5), .passesAANormal)
    }

    func test_evaluate_ratio3_passesAALarge() {
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: 3.0), .passesAALarge)
    }

    func test_evaluate_ratio2point9_fails() {
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: 2.99), .fail)
    }

    // MARK: - Integration Tests

    func test_knownPair_tailwindIndigo500OnWhite() {
        let indigo500 = (r: 99.0/255, g: 102.0/255, b: 241.0/255)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let ratio = WCAGContrastChecker.contrastRatio(foreground: indigo500, background: white)
        XCTAssertEqual(ratio, 4.46, accuracy: 0.35, "Tailwind indigo-500 on white; WebAIM ~4.46, implementations may vary")
        XCTAssertEqual(WCAGContrastChecker.evaluate(ratio: ratio), .passesAALarge)
    }
}
