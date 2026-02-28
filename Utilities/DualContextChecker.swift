//
//  DualContextChecker.swift
//  HEXPal
//
//  Orchestrates contrast checking against both light and dark backgrounds.
//  Pure Swift, Foundation only.
//

import Foundation

/// Checks a color's contrast against both standard light and dark backgrounds.
struct DualContextChecker {
    static let lightBackground = (r: 1.0, g: 1.0, b: 1.0)
    static let darkBackground = (r: 30.0/255, g: 30.0/255, b: 30.0/255)

    /// Check a color against both light and dark backgrounds.
    /// Returns WCAG 2.x AND APCA results for both contexts.
    static func check(r: Double, g: Double, b: Double) -> DualContextResult {
        let fg = (r: r, g: g, b: b)
        let lightWCAGRatio = WCAGContrastChecker.contrastRatio(foreground: fg, background: lightBackground)
        let lightAPCALc = APCAContrastChecker.contrastValue(textColor: fg, backgroundColor: lightBackground)
        let onLight = ContrastResult(
            wcagRatio: lightWCAGRatio,
            wcagLevel: WCAGContrastChecker.evaluate(ratio: lightWCAGRatio),
            apcaLc: lightAPCALc,
            apcaLevel: APCAContrastChecker.evaluate(lcValue: lightAPCALc)
        )
        let darkWCAGRatio = WCAGContrastChecker.contrastRatio(foreground: fg, background: darkBackground)
        let darkAPCALc = APCAContrastChecker.contrastValue(textColor: fg, backgroundColor: darkBackground)
        let onDark = ContrastResult(
            wcagRatio: darkWCAGRatio,
            wcagLevel: WCAGContrastChecker.evaluate(ratio: darkWCAGRatio),
            apcaLc: darkAPCALc,
            apcaLevel: APCAContrastChecker.evaluate(lcValue: darkAPCALc)
        )
        return DualContextResult(onLight: onLight, onDark: onDark)
    }
}
