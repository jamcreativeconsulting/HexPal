//
//  NSColor+SRGBComponents.swift
//  HEXPal
//
//  Bridges NSColor to sRGB (r,g,b) for pure-Swift color utilities.
//  NSColorSampler output is sRGB-compatible; nil is rare in practice.
//

import AppKit

extension NSColor {

    /// Extract sRGB components as Doubles in 0.0-1.0 range.
    /// Converts from whatever color space the NSColor is in to sRGB first.
    /// Returns nil if the conversion fails (should be rare with NSColorSampler output).
    func srgbComponents() -> (r: Double, g: Double, b: Double)? {
        guard let srgb = usingColorSpace(.sRGB) else { return nil }
        return (
            r: Double(srgb.redComponent),
            g: Double(srgb.greenComponent),
            b: Double(srgb.blueComponent)
        )
    }
}
