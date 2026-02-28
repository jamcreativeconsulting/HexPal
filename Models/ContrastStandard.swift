//
//  ContrastStandard.swift
//  HexPal
//
//  User's preferred contrast standard for the Accessibility panel.
//

import Foundation

/// Which contrast standard to display in the Accessibility panel.
///
/// - wcag22: WCAG 2.2 (ratio + AA/AAA level)
/// - apca: APCA (Lc value + level)
enum ContrastStandard: String, CaseIterable, Identifiable {
    case wcag22 = "WCAG 2.2"
    case apca = "APCA"

    var id: String { rawValue }

    /// UserDefaults key for preferred contrast standard.
    static let preferredKey = "HexPal.ContrastStandard.preferred"

    /// User's preferred contrast standard. Defaults to WCAG 2.2.
    static var preferred: ContrastStandard {
        get {
            let raw = UserDefaults.standard.string(forKey: preferredKey)
            return raw.flatMap { ContrastStandard(rawValue: $0) } ?? .wcag22
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: preferredKey)
        }
    }
}
