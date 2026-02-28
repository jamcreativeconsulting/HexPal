//
//  DualContextResult.swift
//  HEXPal
//
//  Contrast results for both light and dark backgrounds.
//

import Foundation

/// The result of checking one color against both light (#FFFFFF) and dark (#1E1E1E) backgrounds.
struct DualContextResult {
    /// Contrast results when the picked color is used as text on a white background.
    let onLight: ContrastResult
    /// Contrast results when the picked color is used as text on a dark background.
    let onDark: ContrastResult
    /// True if WCAG AA passes on the light background.
    var passesLightWCAG: Bool { onLight.passesWCAGAA }
    /// True if WCAG AA passes on the dark background.
    var passesDarkWCAG: Bool { onDark.passesWCAGAA }
    /// True if WCAG AA passes on BOTH backgrounds.
    var passesBothWCAG: Bool { passesLightWCAG && passesDarkWCAG }
}
