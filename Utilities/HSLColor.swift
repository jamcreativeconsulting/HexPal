//
//  HSLColor.swift
//  HEXPal
//
//  RGB to HSL conversion for web color format output.
//  Pure Swift, Foundation only. No AppKit.
//

import Foundation

/// HSL (Hue, Saturation, Lightness) representation.
struct HSLColor {
    /// Hue in degrees, 0-360.
    let hue: Double
    /// Saturation as fraction, 0.0 to 1.0.
    let saturation: Double
    /// Lightness as fraction, 0.0 to 1.0.
    let lightness: Double

    /// Initialize from sRGB components (each 0.0 to 1.0).
    init(fromSRGB r: Double, _ g: Double, _ b: Double) {
        let maxC = max(r, g, b)
        let minC = min(r, g, b)
        let delta = maxC - minC

        let l = (maxC + minC) / 2.0

        let s: Double
        if delta == 0 {
            s = 0
        } else {
            s = delta / (1.0 - abs(2.0 * l - 1.0))
        }

        var h: Double
        if delta == 0 {
            h = 0
        } else if maxC == r {
            h = 60.0 * (((g - b) / delta).truncatingRemainder(dividingBy: 6))
        } else if maxC == g {
            h = 60.0 * (((b - r) / delta) + 2.0)
        } else {
            h = 60.0 * (((r - g) / delta) + 4.0)
        }
        if h < 0 { h += 360.0 }

        hue = h
        saturation = min(max(s, 0), 1)
        lightness = l
    }

    /// CSS-ready string: "hsl(0, 100%, 50%)"
    var cssString: String {
        "hsl(\(Int(round(hue))), \(Int(round(saturation * 100)))%, \(Int(round(lightness * 100)))%)"
    }
}
