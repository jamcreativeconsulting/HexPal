//
//  ColorFormat.swift
//  HEXPal
//
//  Every color format HexPal can output.
//

import Foundation

/// Every color format HexPal can output.
enum ColorFormat: String, CaseIterable, Identifiable {
    case hex = "HEX"
    case rgb = "RGB"
    case hsl = "HSL"
    case oklch = "OKLCH"
    case cssCustomProperty = "CSS Variable"
    case tailwindClass = "Tailwind"
    case swiftUIColor = "SwiftUI"
    case uiColor = "UIColor"

    var id: String { rawValue }

    /// Short example showing what the format looks like.
    /// UserDefaults key for preferred copy format. Default is .hex.
    static let preferredFormatKey = "PreferredColorFormat"

    /// The user's preferred format, or .hex if unset.
    static var preferred: ColorFormat {
        get {
            let raw = UserDefaults.standard.string(forKey: preferredFormatKey)
            return raw.flatMap { ColorFormat(rawValue: $0) } ?? .hex
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: preferredFormatKey)
        }
    }

    var example: String {
        switch self {
        case .hex: return "#FF0000"
        case .rgb: return "rgb(255, 0, 0)"
        case .hsl: return "hsl(0, 100%, 50%)"
        case .oklch: return "oklch(62.8% 0.258 29.2)"
        case .cssCustomProperty: return "--color-picked: #FF0000;"
        case .tailwindClass: return "bg-[#FF0000]"
        case .swiftUIColor: return "Color(red: 1.0, ...)"
        case .uiColor: return "UIColor(red: 1.0, ...)"
        }
    }
}
