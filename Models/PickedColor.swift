//
//  PickedColor.swift
//  HEXPal
//
//  Full result of a color pick: formats, contrast, and fix suggestions.
//

import Foundation

/// Result of picking a color, including contrast data and accessible suggestions.
struct PickedColor: Identifiable {
    let id = UUID()
    let timestamp = Date()
    let r: Double
    let g: Double
    let b: Double
    let dualContext: DualContextResult
    let lightSuggestion: (r: Double, g: Double, b: Double)?
    let darkSuggestion: (r: Double, g: Double, b: Double)?

    /// Hex string (e.g. "#FF0000"). Most common format.
    var hex: String { ColorConverter.hexString(r: r, g: g, b: b) }

    /// Alias for hex; same value.
    var hexString: String { hex }

    /// All supported format strings for UI display.
    var allFormats: [(format: ColorFormat, value: String)] {
        ColorConverter.allFormats(r: r, g: g, b: b)
    }

    /// Get the format string for a specific format.
    func string(for format: ColorFormat) -> String {
        switch format {
        case .hex: return ColorConverter.hexString(r: r, g: g, b: b)
        case .rgb: return ColorConverter.rgbString(r: r, g: g, b: b)
        case .hsl: return ColorConverter.hslString(r: r, g: g, b: b)
        case .oklch: return ColorConverter.oklchString(r: r, g: g, b: b)
        case .cssCustomProperty: return ColorConverter.cssCustomProperty(r: r, g: g, b: b)
        case .tailwindClass: return ColorConverter.tailwindClass(r: r, g: g, b: b)
        case .swiftUIColor: return ColorConverter.swiftUIColor(r: r, g: g, b: b)
        case .uiColor: return ColorConverter.uiColorString(r: r, g: g, b: b)
        }
    }

    /// Create from hex string (e.g. "#FF5733"). Returns nil if invalid.
    static func fromHex(_ hex: String) -> PickedColor? {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s = String(s.dropFirst()) }
        guard s.count == 6 else { return nil }
        var rgb: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&rgb) else { return nil }
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        let dualContext = DualContextChecker.check(r: r, g: g, b: b)
        let lightSuggestion = dualContext.onLight.passesWCAGAA ? nil
            : AccessibleColorSuggester.suggest(r: r, g: g, b: b, against: DualContextChecker.lightBackground)
        let darkSuggestion = dualContext.onDark.passesWCAGAA ? nil
            : AccessibleColorSuggester.suggest(r: r, g: g, b: b, against: DualContextChecker.darkBackground)
        return PickedColor(
            r: r, g: g, b: b,
            dualContext: dualContext,
            lightSuggestion: lightSuggestion,
            darkSuggestion: darkSuggestion
        )
    }
}
