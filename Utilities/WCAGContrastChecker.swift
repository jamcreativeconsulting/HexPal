//
//  WCAGContrastChecker.swift
//  HEXPal
//
//  WCAG 2.x contrast ratio per W3C (https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio).
//  Pure Swift, Foundation only. No AppKit.
//

import Foundation

/// WCAG 2.x contrast checker. All static methods, no state.
struct WCAGContrastChecker {
    static let aaaNormalThreshold = 7.0
    static let aaNormalThreshold = 4.5
    static let aaLargeThreshold = 3.0

    /// Relative luminance per sRGB (components 0.0–1.0).
    /// Linearizes each component then returns weighted sum.
    static func relativeLuminance(r: Double, g: Double, b: Double) -> Double {
        func linearize(_ c: Double) -> Double {
            c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b)
    }

    /// Contrast ratio (1.0 to 21.0). Swapping fg/bg yields the same result.
    static func contrastRatio(
        foreground: (r: Double, g: Double, b: Double),
        background: (r: Double, g: Double, b: Double)
    ) -> Double {
        let l1 = relativeLuminance(r: foreground.r, g: foreground.g, b: foreground.b)
        let l2 = relativeLuminance(r: background.r, g: background.g, b: background.b)
        let (L1, L2) = l1 >= l2 ? (l1, l2) : (l2, l1)
        return (L1 + 0.05) / (L2 + 0.05)
    }

    /// Evaluates ratio against WCAG levels.
    static func evaluate(ratio: Double) -> ComplianceLevel {
        if ratio >= aaaNormalThreshold { return .passesAAA }
        if ratio >= aaNormalThreshold { return .passesAANormal }
        if ratio >= aaLargeThreshold { return .passesAALarge }
        return .fail
    }

    enum ComplianceLevel: String, Comparable {
        case fail = "Fail"
        case passesAALarge = "AA Large"
        case passesAANormal = "AA"
        case passesAAA = "AAA"

        static func < (lhs: Self, rhs: Self) -> Bool {
            let order: [Self] = [.fail, .passesAALarge, .passesAANormal, .passesAAA]
            return (order.firstIndex(of: lhs) ?? 0) < (order.firstIndex(of: rhs) ?? 0)
        }
    }
}
