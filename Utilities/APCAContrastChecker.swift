//
//  APCAContrastChecker.swift
//  HEXPal
//
//  APCA-W3 (Advanced Perceptual Contrast Algorithm) per WCAG 3.0.
//  Reference: https://github.com/Myndex/SAPC-APCA
//  Pure Swift, Foundation only. No AppKit.
//

import Foundation

/// APCA-W3 contrast checker. All static methods, no state.
struct APCAContrastChecker {

    // From APCA-W3 0.0.98G-4g
    static let sRcoefficient = 0.2126729
    static let sGcoefficient = 0.7151522
    static let sBcoefficient = 0.0721750
    static let normBGExp = 0.56
    static let normTXTExp = 0.57
    static let revBGExp = 0.65
    static let revTXTExp = 0.62
    static let scaleBoW = 1.14
    static let scaleWoB = 1.14
    static let loClip = 0.1
    static let deltaYmin = 0.0005
    static let outputOffset = 0.027
    static let softClampThreshold = 0.022
    static let softClampExponent = 1.414

    /// Estimated screen luminance from sRGB components (0–1). Linearizes via pow(c,2.4).
    /// Applies soft clamp for very dark colors per APCA-W3.
    static func estimatedScreenLuminance(r: Double, g: Double, b: Double) -> Double {
        func clamp(_ x: Double) -> Double { min(max(x, 0), 1) }
        let Y = sRcoefficient * pow(clamp(r), 2.4) +
                sGcoefficient * pow(clamp(g), 2.4) +
                sBcoefficient * pow(clamp(b), 2.4)
        if Y < softClampThreshold {
            return Y + pow(softClampThreshold - Y, softClampExponent)
        }
        return Y
    }

    /// APCA Lc value. Positive = dark text on light bg, negative = light on dark.
    /// NOT symmetric (unlike WCAG 2.x).
    static func contrastValue(
        textColor: (r: Double, g: Double, b: Double),
        backgroundColor: (r: Double, g: Double, b: Double)
    ) -> Double {
        let Ytxt = estimatedScreenLuminance(r: textColor.r, g: textColor.g, b: textColor.b)
        let Ybg = estimatedScreenLuminance(r: backgroundColor.r, g: backgroundColor.g, b: backgroundColor.b)
        if abs(Ybg - Ytxt) < deltaYmin { return 0.0 }

        if Ybg > Ytxt {
            let SAPC = (pow(Ybg, normBGExp) - pow(Ytxt, normTXTExp)) * scaleBoW
            if SAPC < loClip { return 0.0 }
            return (SAPC - outputOffset) * 100
        } else {
            let SAPC = (pow(Ybg, revBGExp) - pow(Ytxt, revTXTExp)) * scaleWoB
            if abs(SAPC) < loClip { return 0.0 }
            return (SAPC + outputOffset) * 100
        }
    }

    /// Evaluates |Lc| against APCA levels.
    static func evaluate(lcValue: Double) -> APCALevel {
        let absLc = abs(lcValue)
        if absLc >= 90 { return .preferred }
        if absLc >= 75 { return .minimumBody }
        if absLc >= 60 { return .minimumLarge }
        if absLc >= 45 { return .minimumNonText }
        return .fail
    }

    enum APCALevel: String, Comparable {
        case fail = "Fail"
        case minimumNonText = "Non-Text"
        case minimumLarge = "Large Text"
        case minimumBody = "Body Text"
        case preferred = "Preferred"

        static func < (lhs: Self, rhs: Self) -> Bool {
            let order: [Self] = [.fail, .minimumNonText, .minimumLarge, .minimumBody, .preferred]
            return (order.firstIndex(of: lhs) ?? 0) < (order.firstIndex(of: rhs) ?? 0)
        }
    }
}
