//
//  ColorPickerManager.swift
//  HexPal
//
//  Manages system color sampling using Apple's native NSColorSampler.
//  Requires zero system permissions — no privacy entitlements needed.
//

import AppKit

/// Manages system color sampling using Apple's native NSColorSampler.
///
/// Uses `NSColorSampler` (macOS 10.15+), which presents the system magnifier loupe
/// and requires zero permissions — no privacy entitlements are needed.
///
/// ## Usage
/// ```swift
/// ColorPickerManager.shared.onColorPicked = { pickedColor in
///     // handle PickedColor with hex, contrast, and fix suggestions
/// }
/// ColorPickerManager.shared.pickColor()
/// ```
final class ColorPickerManager {

    /// Shared instance for app-wide access.
    static let shared = ColorPickerManager()

    /// Callback fired on the main thread when the user successfully picks a color.
    /// Not called if the user cancels by pressing Escape.
    var onColorPicked: ((PickedColor) -> Void)?

    private init() {}

    /// Presents the system color sampler loupe. The user clicks anywhere on screen
    /// to select a color. Calls `onColorPicked` with the result, or does nothing if
    /// the user cancels (Escape key).
    func pickColor() {
        let sampler = NSColorSampler()
        sampler.show { [weak self] selectedColor in
            guard let color = selectedColor,
                  let (r, g, b) = color.srgbComponents() else { return }
            let dualContext = DualContextChecker.check(r: r, g: g, b: b)
            let lightSuggestion = dualContext.onLight.passesWCAGAA ? nil
                : AccessibleColorSuggester.suggest(r: r, g: g, b: b, against: DualContextChecker.lightBackground)
            let darkSuggestion = dualContext.onDark.passesWCAGAA ? nil
                : AccessibleColorSuggester.suggest(r: r, g: g, b: b, against: DualContextChecker.darkBackground)
            let picked = PickedColor(
                r: r, g: g, b: b,
                dualContext: dualContext,
                lightSuggestion: lightSuggestion,
                darkSuggestion: darkSuggestion
            )
            self?.onColorPicked?(picked)
        }
    }
}
