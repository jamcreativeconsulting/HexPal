//
//  HotkeyManager.swift
//  HEXPal — Global shortcut via KeyboardShortcuts (no permissions required).
//

import KeyboardShortcuts

/// Registers and manages the global keyboard shortcut for color picking.
final class HotkeyManager {

    static let shared = HotkeyManager()

    private init() {}

    /// Call once on app launch to begin listening for the global shortcut.
    func start() {
        KeyboardShortcuts.onKeyUp(for: .pickColor) {
            ColorPickerManager.shared.pickColor()
        }
    }
}
