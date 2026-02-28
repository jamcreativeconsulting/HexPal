//
//  OKLCHColor.swift
//  HEXPal
//
//  OKLCH color space per Björn Ottosson's Oklab (https://bottosson.github.io/posts/oklab/).
//  Pure Swift, Foundation only. No AppKit.
//

import Foundation

/// OKLCH color: lightness (0-1), chroma (>=0), hue (0-360 degrees).
struct OKLCHColor {
    let lightness: Double
    let chroma: Double
    let hue: Double

    /// Create from sRGB components (0-1). Converts via Oklab.
    init(fromSRGB r: Double, _ g: Double, _ b: Double) {
        let (L, a, b) = Self.srgbToOklab(r: r, g: g, b: b)
        lightness = L
        chroma = sqrt(a * a + b * b)
        let hDeg = atan2(b, a) * 180 / .pi
        hue = chroma < 1e-10 ? 0 : (hDeg >= 0 ? hDeg : hDeg + 360)
    }

    /// Create from OKLCH components. Hue in degrees 0-360.
    init(lightness: Double, chroma: Double, hue: Double) {
        self.lightness = lightness
        self.chroma = chroma
        self.hue = hue
    }

    /// CSS-ready format: "oklch(62.8% 0.2580 29.2)"
    var cssString: String {
        String(format: "oklch(%.1f%% %.4f %.1f)", lightness * 100, chroma, hue)
    }

    /// Convert to sRGB (r,g,b) in 0-1. Clamps out-of-gamut values.
    func toSRGB() -> (r: Double, g: Double, b: Double) {
        let hRad = hue * .pi / 180
        let aVal = chroma * cos(hRad)
        let bVal = chroma * sin(hRad)
        let (r, g, b) = Self.oklabToSrgb(L: lightness, a: aVal, b: bVal)
        return (
            r: min(max(r, 0), 1),
            g: min(max(g, 0), 1),
            b: min(max(b, 0), 1)
        )
    }

    private static func linearize(_ c: Double) -> Double {
        c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
    }

    private static func srgbToOklab(r: Double, g: Double, b: Double) -> (L: Double, a: Double, b: Double) {
        let l = 0.4122214708 * linearize(r) + 0.5363325363 * linearize(g) + 0.0514459929 * linearize(b)
        let m = 0.2119034982 * linearize(r) + 0.6806995451 * linearize(g) + 0.1073969566 * linearize(b)
        let s = 0.0883024619 * linearize(r) + 0.2817188376 * linearize(g) + 0.6299787005 * linearize(b)
        let l_ = pow(l, 1/3)
        let m_ = pow(m, 1/3)
        let s_ = pow(s, 1/3)
        let L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_
        let a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_
        let bVal = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
        return (L, a, bVal)
    }

    private static func oklabToSrgb(L: Double, a: Double, b: Double) -> (r: Double, g: Double, b: Double) {
        let l_ = L + 0.3963377774 * a + 0.2158037573 * b
        let m_ = L - 0.1055613458 * a - 0.0638541728 * b
        let s_ = L - 0.0894841775 * a - 1.2914855480 * b
        let l = l_ * l_ * l_
        let m = m_ * m_ * m_
        let s = s_ * s_ * s_
        let rLin = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
        let gLin = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
        let bLin = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
        func delinearize(_ c: Double) -> Double {
            c <= 0.0031308 ? 12.92 * c : 1.055 * pow(c, 1/2.4) - 0.055
        }
        return (delinearize(rLin), delinearize(gLin), delinearize(bLin))
    }
}
