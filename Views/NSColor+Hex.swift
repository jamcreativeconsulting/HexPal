//
//  NSColor+Hex.swift
//  HexPal
//
//  Extension to create NSColor from HEX strings. Used by notification and menu UI.
//

import AppKit

extension NSColor {

    /// Creates an NSColor from a HEX string (with or without # prefix).
    ///
    /// - Parameter hex: The HEX code string (e.g., "#FF5733" or "FF5733")
    /// - Returns: An NSColor in sRGB, or black if parsing fails
    static func fromHex(_ hex: String) -> NSColor {
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if sanitized.hasPrefix("#") { sanitized = String(sanitized.dropFirst()) }
        guard sanitized.count == 6 else { return .black }
        var rgb: UInt64 = 0
        guard Scanner(string: sanitized).scanHexInt64(&rgb) else { return .black }
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        return NSColor(srgbRed: r, green: g, blue: b, alpha: 1.0)
    }
}
