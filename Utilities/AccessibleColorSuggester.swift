//
//  AccessibleColorSuggester.swift
//  HEXPal
//
//  "Fix It" feature: nearest accessible shade via OKLCH lightness shift.
//  Preserves hue and chroma. Pure Swift, Foundation only.
//

import Foundation

/// Suggests the nearest accessible shade when a color fails contrast.
struct AccessibleColorSuggester {
    static let defaultTargetRatio = 4.5
    static let searchIterations = 20

    /// Suggest the nearest accessible shade. Returns nil if no solution exists (rare).
    static func suggest(
        r: Double, g: Double, b: Double,
        against background: (r: Double, g: Double, b: Double),
        targetRatio: Double = defaultTargetRatio
    ) -> (r: Double, g: Double, b: Double)? {
        let currentRatio = WCAGContrastChecker.contrastRatio(
            foreground: (r, g, b),
            background: background
        )
        if currentRatio >= targetRatio { return (r, g, b) }

        let oklch = OKLCHColor(fromSRGB: r, g, b)
        let bgLuminance = WCAGContrastChecker.relativeLuminance(
            r: background.r, g: background.g, b: background.b
        )
        let searchingDarker = bgLuminance > 0.5

        var low: Double
        var high: Double
        if searchingDarker {
            low = 0.0
            high = oklch.lightness
        } else {
            low = oklch.lightness
            high = 1.0
        }

        var bestL = searchingDarker ? low : high

        for _ in 0..<searchIterations {
            let midL = (low + high) / 2.0
            let candidate = OKLCHColor(lightness: midL, chroma: oklch.chroma, hue: oklch.hue)
            let srgb = candidate.toSRGB()
            let ratio = WCAGContrastChecker.contrastRatio(
                foreground: (srgb.r, srgb.g, srgb.b),
                background: background
            )

            if ratio >= targetRatio {
                bestL = midL
                if searchingDarker { low = midL } else { high = midL }
            } else {
                if searchingDarker { high = midL } else { low = midL }
            }
        }

        let result = OKLCHColor(lightness: bestL, chroma: oklch.chroma, hue: oklch.hue)
        let srgb = result.toSRGB()
        let finalRatio = WCAGContrastChecker.contrastRatio(
            foreground: (srgb.r, srgb.g, srgb.b),
            background: background
        )
        if finalRatio < targetRatio { return nil }
        return (r: srgb.r, g: srgb.g, b: srgb.b)
    }
}
