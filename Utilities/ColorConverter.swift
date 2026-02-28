//
//  ColorConverter.swift
//  HEXPal
//
//  Converts sRGB components to all supported format strings.
//  Pure Swift, Foundation only. No AppKit.
//

import Foundation

/// Converts sRGB components to format strings. All static methods.
struct ColorConverter {

    static func hexString(r: Double, g: Double, b: Double) -> String {
        let ri = Int(round(clamp01(r) * 255))
        let gi = Int(round(clamp01(g) * 255))
        let bi = Int(round(clamp01(b) * 255))
        return String(format: "#%02X%02X%02X", ri, gi, bi)
    }

    static func rgbString(r: Double, g: Double, b: Double) -> String {
        let ri = Int(round(clamp01(r) * 255))
        let gi = Int(round(clamp01(g) * 255))
        let bi = Int(round(clamp01(b) * 255))
        return "rgb(\(ri), \(gi), \(bi))"
    }

    static func hslString(r: Double, g: Double, b: Double) -> String {
        HSLColor(fromSRGB: r, g, b).cssString
    }

    static func oklchString(r: Double, g: Double, b: Double) -> String {
        OKLCHColor(fromSRGB: r, g, b).cssString
    }

    static func cssCustomProperty(r: Double, g: Double, b: Double, name: String = "picked") -> String {
        "--color-\(name): \(hexString(r: r, g: g, b: b));"
    }

    static func tailwindClass(r: Double, g: Double, b: Double) -> String {
        "bg-[\(hexString(r: r, g: g, b: b))]"
    }

    static func swiftUIColor(r: Double, g: Double, b: Double) -> String {
        let r3 = String(format: "%.3f", clamp01(r))
        let g3 = String(format: "%.3f", clamp01(g))
        let b3 = String(format: "%.3f", clamp01(b))
        return "Color(red: \(r3), green: \(g3), blue: \(b3))"
    }

    static func uiColorString(r: Double, g: Double, b: Double) -> String {
        let r3 = String(format: "%.3f", clamp01(r))
        let g3 = String(format: "%.3f", clamp01(g))
        let b3 = String(format: "%.3f", clamp01(b))
        return "UIColor(red: \(r3), green: \(g3), blue: \(b3), alpha: 1.0)"
    }

    /// Returns the color in the given format. Use for suggested shades and other RGB tuples.
    static func string(for format: ColorFormat, r: Double, g: Double, b: Double) -> String {
        switch format {
        case .hex: return hexString(r: r, g: g, b: b)
        case .rgb: return rgbString(r: r, g: g, b: b)
        case .hsl: return hslString(r: r, g: g, b: b)
        case .oklch: return oklchString(r: r, g: g, b: b)
        case .cssCustomProperty: return cssCustomProperty(r: r, g: g, b: b)
        case .tailwindClass: return tailwindClass(r: r, g: g, b: b)
        case .swiftUIColor: return swiftUIColor(r: r, g: g, b: b)
        case .uiColor: return uiColorString(r: r, g: g, b: b)
        }
    }

    static func allFormats(r: Double, g: Double, b: Double) -> [(format: ColorFormat, value: String)] {
        [
            (.hex, hexString(r: r, g: g, b: b)),
            (.rgb, rgbString(r: r, g: g, b: b)),
            (.hsl, hslString(r: r, g: g, b: b)),
            (.oklch, oklchString(r: r, g: g, b: b)),
            (.cssCustomProperty, cssCustomProperty(r: r, g: g, b: b)),
            (.tailwindClass, tailwindClass(r: r, g: g, b: b)),
            (.swiftUIColor, swiftUIColor(r: r, g: g, b: b)),
            (.uiColor, uiColorString(r: r, g: g, b: b)),
        ]
    }

    private static func clamp01(_ value: Double) -> Double {
        min(max(value, 0.0), 1.0)
    }
}
