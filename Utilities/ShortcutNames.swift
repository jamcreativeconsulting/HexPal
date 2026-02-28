import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    /// Global shortcut to activate the color picker. Default: ⌘⇧P
    static let pickColor = Self("pickColor", default: .init(.p, modifiers: [.command, .shift]))
}
