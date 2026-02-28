//
//  ShortcutNames.swift
//  HexPal
//
//  Keyboard shortcut name constants for the HexPal app.
//  Lives in Controllers/ because KeyboardShortcuts uses NSEvent.ModifierFlags from AppKit.
//

import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    /// Global shortcut to activate the color picker. Default: ⌘⇧P
    static let pickColor = Self("pickColor", default: .init(.p, modifiers: [.command, .shift]))
}
