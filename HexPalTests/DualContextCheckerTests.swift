//
//  DualContextCheckerTests.swift
//  HexPalTests
//
//  Tests dual-context contrast checking (light + dark backgrounds).
//

import XCTest
@testable import HexPal

final class DualContextCheckerTests: XCTestCase {

    func test_pureWhiteText_failsOnLight_passesOnDark() {
        let result = DualContextChecker.check(r: 1, g: 1, b: 1)
        XCTAssertEqual(result.onLight.wcagRatio, 1.0, accuracy: 0.01)
        XCTAssertEqual(result.onLight.wcagLevel, .fail)
        XCTAssertGreaterThan(result.onDark.wcagRatio, 4.0)
        XCTAssertTrue(result.onDark.passesWCAGAA)
    }

    func test_pureBlackText_passesOnLight_failsOnDark() {
        let result = DualContextChecker.check(r: 0, g: 0, b: 0)
        XCTAssertEqual(result.onLight.wcagRatio, 21.0, accuracy: 0.5)
        XCTAssertEqual(result.onLight.wcagLevel, .passesAAA)
        XCTAssertLessThan(result.onDark.wcagRatio, 4.5)
    }

    func test_midBlue_checkBothContexts() {
        let blue500 = (59.0/255, 130.0/255, 246.0/255)
        let result = DualContextChecker.check(r: blue500.0, g: blue500.1, b: blue500.2)
        XCTAssertGreaterThan(result.onLight.wcagRatio, 1.0)
        XCTAssertNotEqual(result.onLight.apcaLc, 0)
        XCTAssertGreaterThan(result.onDark.wcagRatio, 1.0)
        XCTAssertNotEqual(result.onDark.apcaLc, 0)
    }

    func test_passesBothWCAG_trueWhenBothContextsPass() {
        // No color passes AA Normal on BOTH #FFF and #1E1E1E (ranges don't overlap).
        // Verify the property: when both pass, passesBothWCAG is true.
        let onLight = ContrastResult(
            wcagRatio: 5.0, wcagLevel: .passesAANormal,
            apcaLc: 60, apcaLevel: .minimumLarge
        )
        let onDark = ContrastResult(
            wcagRatio: 5.0, wcagLevel: .passesAANormal,
            apcaLc: -60, apcaLevel: .minimumLarge
        )
        let result = DualContextResult(onLight: onLight, onDark: onDark)
        XCTAssertTrue(result.passesBothWCAG)
    }

    func test_passesBothWCAG_falseWhenLightContextFails() {
        let nearWhite = (r: 0.95, g: 0.95, b: 0.95)
        let result = DualContextChecker.check(r: nearWhite.r, g: nearWhite.g, b: nearWhite.b)
        XCTAssertFalse(result.passesBothWCAG)
    }

    func test_darkBackground_isCorrectHex() {
        let db = DualContextChecker.darkBackground
        let r = Int(round(db.r * 255))
        let g = Int(round(db.g * 255))
        let b = Int(round(db.b * 255))
        XCTAssertEqual(r, 0x1E)
        XCTAssertEqual(g, 0x1E)
        XCTAssertEqual(b, 0x1E)
    }
}
