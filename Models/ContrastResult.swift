//
//  ContrastResult.swift
//  HEXPal
//
//  Result of checking one color against one background for WCAG and APCA.
//

import Foundation

/// The result of checking one color against one background for both WCAG 2.x and APCA contrast.
struct ContrastResult {
    /// WCAG 2.x contrast ratio (e.g., 4.6). Always >= 1.0.
    let wcagRatio: Double
    /// WCAG 2.x compliance level based on the ratio.
    let wcagLevel: WCAGContrastChecker.ComplianceLevel
    /// APCA Lc value (e.g., 62.5). Positive = dark on light, negative = light on dark.
    let apcaLc: Double
    /// APCA compliance level based on |Lc|.
    let apcaLevel: APCAContrastChecker.APCALevel
    /// True if at least WCAG AA Normal text passes.
    var passesWCAGAA: Bool { wcagLevel >= .passesAANormal }
    /// True if APCA indicates at least minimum body text readability.
    var passesAPCABody: Bool { apcaLevel >= .minimumBody }
}
