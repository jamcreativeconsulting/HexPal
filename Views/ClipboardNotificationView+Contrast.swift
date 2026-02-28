//
//  ClipboardNotificationView+Contrast.swift
//  HexPal
//
//  Contrast rows and Fix buttons for the clipboard notification.
//

import Cocoa

extension ClipboardNotificationView {

    /// Adds contrast rows (light/dark) with optional Fix buttons.
    func addContrastRows(to contentView: InteractiveNotificationView, swatchPadding: CGFloat) {
        let rowHeight: CGFloat = 22
        let font = NSFont.systemFont(ofSize: 11, weight: .medium)
        let light = picked.dualContext.onLight
        let dark = picked.dualContext.onDark

        func badge(_ r: ContrastResult) -> String {
            let wcag = String(format: "%.1f:1", r.wcagRatio)
            let wcagIcon = r.passesWCAGAA ? "✓" : "✗"
            let apca = String(format: "Lc%.0f", abs(r.apcaLc))
            return "\(wcag) \(r.wcagLevel.rawValue) \(wcagIcon)  \(apca) \(r.apcaLevel.rawValue)"
        }

        var y = ClipboardNotificationView.height - swatchPadding - 28 - rowHeight - 4

        let lightLabel = NSTextField(labelWithString: "Light: \(badge(light))")
        lightLabel.font = font
        lightLabel.textColor = NSColor.secondaryLabelColor
        lightLabel.frame = NSRect(x: swatchPadding, y: y, width: 140, height: rowHeight)
        lightLabel.alignment = .left
        lightLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lightLabel.setAccessibilityElement(true)
        lightLabel.setAccessibilityRole(.staticText)
        lightLabel.setAccessibilityLabel("On white: \(light.wcagRatio):1 \(light.wcagLevel.rawValue), APCA \(abs(light.apcaLc)) \(light.apcaLevel.rawValue)")
        contentView.addSubview(lightLabel)

        if let fix = picked.lightSuggestion {
            let fixHex = String(format: "#%02X%02X%02X", Int(fix.r * 255), Int(fix.g * 255), Int(fix.b * 255))
            let fixBtn = NSButton(title: "Fix → \(fixHex)", target: self, action: #selector(fixLightCopy(_:)))
            fixBtn.bezelStyle = NSButton.BezelStyle.rounded
            fixBtn.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .medium)
            fixBtn.frame = NSRect(x: 150, y: y - 2, width: 62, height: 18)
            fixBtn.setAccessibilityLabel("Copy accessible shade for light background \(fixHex)")
            contentView.addSubview(fixBtn)
        }

        y -= rowHeight

        let darkLabel = NSTextField(labelWithString: "Dark: \(badge(dark))")
        darkLabel.font = font
        darkLabel.textColor = NSColor.secondaryLabelColor
        darkLabel.frame = NSRect(x: swatchPadding, y: y, width: 140, height: rowHeight)
        darkLabel.alignment = .left
        darkLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        darkLabel.setAccessibilityElement(true)
        darkLabel.setAccessibilityRole(.staticText)
        darkLabel.setAccessibilityLabel("On dark: \(dark.wcagRatio):1 \(dark.wcagLevel.rawValue), APCA \(abs(dark.apcaLc)) \(dark.apcaLevel.rawValue)")
        contentView.addSubview(darkLabel)

        if let fix = picked.darkSuggestion {
            let fixHex = String(format: "#%02X%02X%02X", Int(fix.r * 255), Int(fix.g * 255), Int(fix.b * 255))
            let fixBtn = NSButton(title: "Fix → \(fixHex)", target: self, action: #selector(fixDarkCopy(_:)))
            fixBtn.bezelStyle = NSButton.BezelStyle.rounded
            fixBtn.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .medium)
            fixBtn.frame = NSRect(x: 150, y: y - 2, width: 62, height: 18)
            fixBtn.setAccessibilityLabel("Copy accessible shade for dark background \(fixHex)")
            contentView.addSubview(fixBtn)
        }
    }

    @objc func fixLightCopy(_ sender: Any?) {
        guard let fix = picked.lightSuggestion else { return }
        let hex = String(format: "#%02X%02X%02X", Int(fix.r * 255), Int(fix.g * 255), Int(fix.b * 255))
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(hex, forType: .string)
        showPasteTooltip()
    }

    @objc func fixDarkCopy(_ sender: Any?) {
        guard let fix = picked.darkSuggestion else { return }
        let hex = String(format: "#%02X%02X%02X", Int(fix.r * 255), Int(fix.g * 255), Int(fix.b * 255))
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(hex, forType: .string)
        showPasteTooltip()
    }
}
