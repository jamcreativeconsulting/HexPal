//
//  APCAContrastCheckerTests.swift
//  HexPalTests
//
//  Tests APCA Lc against myndex.com/APCA reference values.
//

import XCTest
@testable import HexPal

final class APCAContrastCheckerTests: XCTestCase {

    // MARK: - Core Calculation Tests

    func test_apcaContrast_blackTextOnWhiteBg_returnsApprox106() {
        let text = (r: 0.0, g: 0.0, b: 0.0)
        let bg = (r: 1.0, g: 1.0, b: 1.0)
        let lc = APCAContrastChecker.contrastValue(textColor: text, backgroundColor: bg)
        XCTAssertEqual(lc, 106, accuracy: 3)
        XCTAssertGreaterThan(lc, 0)
    }

    func test_apcaContrast_whiteTextOnBlackBg_returnsApproxNeg108() {
        let text = (r: 1.0, g: 1.0, b: 1.0)
        let bg = (r: 0.0, g: 0.0, b: 0.0)
        let lc = APCAContrastChecker.contrastValue(textColor: text, backgroundColor: bg)
        XCTAssertEqual(lc, -108, accuracy: 3)
        XCTAssertLessThan(lc, 0)
    }

    func test_apcaContrast_isNOTSymmetric() {
        let black = (r: 0.0, g: 0.0, b: 0.0)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let bw = APCAContrastChecker.contrastValue(textColor: black, backgroundColor: white)
        let wb = APCAContrastChecker.contrastValue(textColor: white, backgroundColor: black)
        XCTAssertNotEqual(bw, wb)
        XCTAssertEqual(bw.sign, .plus)
        XCTAssertEqual(wb.sign, .minus)
    }

    func test_apcaContrast_sameColor_returnsZero() {
        let c = (r: 0.5, g: 0.3, b: 0.8)
        let lc = APCAContrastChecker.contrastValue(textColor: c, backgroundColor: c)
        XCTAssertEqual(lc, 0.0)
    }

    func test_apcaContrast_similarColors_returnsNearZero() {
        let gray1 = (r: 0.5, g: 0.5, b: 0.5)
        let gray2 = (r: 0.51, g: 0.51, b: 0.51)
        let lc = APCAContrastChecker.contrastValue(textColor: gray1, backgroundColor: gray2)
        XCTAssertLessThan(abs(lc), 10)
    }

    func test_apcaContrast_midGrayOnWhite_returnsModerate() {
        let text = (r: 0.502, g: 0.502, b: 0.502)
        let bg = (r: 1.0, g: 1.0, b: 1.0)
        let lc = APCAContrastChecker.contrastValue(textColor: text, backgroundColor: bg)
        XCTAssertEqual(abs(lc), 65, accuracy: 5)
    }

    // MARK: - The "Orange Button Problem"

    func test_apcaContrast_orangeButtonProblem() {
        let orange = (r: 1.0, g: 0.4, b: 0.0)
        let white = (r: 1.0, g: 1.0, b: 1.0)
        let lc = APCAContrastChecker.contrastValue(textColor: orange, backgroundColor: white)
        XCTAssertGreaterThan(abs(lc), 45)
    }

    // MARK: - Level Evaluation Tests

    func test_evaluate_lc95_preferred() {
        XCTAssertEqual(APCAContrastChecker.evaluate(lcValue: 95), .preferred)
    }

    func test_evaluate_lc75_minimumBody() {
        XCTAssertEqual(APCAContrastChecker.evaluate(lcValue: 75), .minimumBody)
    }

    func test_evaluate_lc60_minimumLarge() {
        XCTAssertEqual(APCAContrastChecker.evaluate(lcValue: 60), .minimumLarge)
    }

    func test_evaluate_lc45_minimumNonText() {
        XCTAssertEqual(APCAContrastChecker.evaluate(lcValue: 45), .minimumNonText)
    }

    func test_evaluate_lc30_fail() {
        XCTAssertEqual(APCAContrastChecker.evaluate(lcValue: 30), .fail)
    }

    func test_evaluate_negativeValue_usesAbsolute() {
        XCTAssertEqual(APCAContrastChecker.evaluate(lcValue: -80), .minimumBody)
    }
}
