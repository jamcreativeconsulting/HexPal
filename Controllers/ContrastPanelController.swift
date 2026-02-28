//
//  ContrastPanelController.swift
//  HexPal
//
//  Persistent panel showing contrast results and accessible shade suggestions.
//  Format selector at top (swatch + dropdown). Single Copy CTA copies main color
//  when passing, or accessible suggestion when failing.
//

import Cocoa

/// Manages a persistent floating panel for viewing color contrast and copying colors.
///
/// Hero: swatch + format dropdown (HEX, RGB, HSL, OKLCH). User selects contrast standard
/// (WCAG 2.2 or APCA). Light/dark context swatches show pass/fail. Single Copy CTA at
/// bottom copies main color when passing, or accessible suggestion when failing.
final class ContrastPanelController: NSObject, NSWindowDelegate {

    // MARK: - Singleton

    static let shared = ContrastPanelController()

    // MARK: - Layout Constants (Negative Space)

    private static let panelWidth: CGFloat = 360
    private static let edgePadding: CGFloat = 20
    private static let sectionPadding: CGFloat = 14
    private static let rowSpacing: CGFloat = 12
    private static let heroSwatchSize: CGFloat = 40
    private static let contextSwatchWidth: CGFloat = 56
    private static let contextSwatchHeight: CGFloat = 20
    private static let rowHeight: CGFloat = 24

    // MARK: - Properties

    private var window: NSWindow?
    private var picked: PickedColor?
    private var copyFormatPopUp: NSPopUpButton?
    private var contrastStandardPopUp: NSPopUpButton?
    private var currentCopyTarget: String?

    // MARK: - Initialization

    private override init() {
        super.init()
    }

    // MARK: - Public Methods

    /// Shows the contrast panel for the given color. Creates the window if needed.
    ///
    /// - Parameter picked: The picked color with contrast data
    func show(picked: PickedColor) {
        self.picked = picked

        if window == nil {
            createWindow()
        }

        updateContent()
        NSApp.activate(ignoringOtherApps: true)
        window?.orderFrontRegardless()
        window?.center()
    }

    /// Dismisses the panel if it is visible.
    func dismiss() {
        window?.orderOut(nil)
    }

    // MARK: - Private Methods

    private func createWindow() {
        let frame = NSRect(x: 0, y: 0, width: ContrastPanelController.panelWidth, height: ContrastPanelController.panelContentHeight)

        window = NSWindow(
            contentRect: frame,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window?.title = "Accessibility"
        window?.delegate = self
        window?.isReleasedWhenClosed = false
        window?.level = .floating
    }

    private func updateContent() {
        guard let picked = picked, let window = window else { return }

        let contentHeight = ContrastPanelController.panelContentHeight
        let contentView = NSView(frame: NSRect(x: 0, y: 0, width: ContrastPanelController.panelWidth, height: contentHeight))
        contentView.wantsLayer = true

        // Add blur first to avoid layout recursion (NSVisualEffectView)
        let visualEffect = NSVisualEffectView(frame: contentView.bounds)
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.blendingMode = .behindWindow
        visualEffect.autoresizingMask = [.width, .height]
        visualEffect.setAccessibilityElement(false)
        contentView.addSubview(visualEffect)

        let pickedColor = NSColor(srgbRed: CGFloat(picked.r), green: CGFloat(picked.g), blue: CGFloat(picked.b), alpha: 1.0)
        var y = contentHeight - ContrastPanelController.edgePadding - ContrastPanelController.heroSwatchSize

        // Hero swatch + format dropdown (value in selected format)
        let heroSwatch = NSView(frame: NSRect(x: ContrastPanelController.edgePadding, y: y, width: ContrastPanelController.heroSwatchSize, height: ContrastPanelController.heroSwatchSize))
        heroSwatch.wantsLayer = true
        heroSwatch.layer?.backgroundColor = pickedColor.cgColor
        heroSwatch.layer?.cornerRadius = 8
        heroSwatch.layer?.borderWidth = 1.0
        heroSwatch.layer?.borderColor = NSColor.separatorColor.cgColor
        heroSwatch.setAccessibilityElement(true)
        heroSwatch.setAccessibilityRole(.image)
        heroSwatch.setAccessibilityLabel("Color swatch for \(picked.hex)")
        contentView.addSubview(heroSwatch)

        let formatTitles = ColorFormat.allCases.map { fmt -> String in
            let value = picked.string(for: fmt)
            return "\(fmt.rawValue): \(value)"
        }
        let formatPopUp = NSPopUpButton(frame: NSRect(x: ContrastPanelController.edgePadding + ContrastPanelController.heroSwatchSize + ContrastPanelController.sectionPadding, y: y + 8, width: ContrastPanelController.panelWidth - 2 * ContrastPanelController.edgePadding - ContrastPanelController.heroSwatchSize - ContrastPanelController.sectionPadding, height: 24), pullsDown: false)
        formatPopUp.addItems(withTitles: formatTitles)
        formatPopUp.selectItem(at: ColorFormat.allCases.firstIndex(of: ColorFormat.preferred) ?? 0)
        formatPopUp.target = self
        formatPopUp.action = #selector(copyFormatChanged(_:))
        formatPopUp.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        formatPopUp.setAccessibilityElement(true)
        formatPopUp.setAccessibilityRole(.popUpButton)
        formatPopUp.setAccessibilityLabel("Select format and copy value")
        copyFormatPopUp = formatPopUp
        contentView.addSubview(formatPopUp)

        y -= ContrastPanelController.heroSwatchSize + ContrastPanelController.sectionPadding

        // Show: [WCAG 2.2 | APCA]
        let showLabel = NSTextField(labelWithString: "Show:")
        showLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        showLabel.textColor = NSColor.secondaryLabelColor
        showLabel.frame = NSRect(x: ContrastPanelController.edgePadding, y: y - 2, width: 40, height: ContrastPanelController.rowHeight)
        showLabel.setAccessibilityElement(true)
        showLabel.setAccessibilityRole(.staticText)
        showLabel.setAccessibilityLabel("Contrast standard")
        contentView.addSubview(showLabel)

        let contrastPopUp = NSPopUpButton(frame: NSRect(x: ContrastPanelController.edgePadding + 48, y: y - 2, width: 120, height: 24), pullsDown: false)
        contrastPopUp.addItems(withTitles: ContrastStandard.allCases.map(\.rawValue))
        contrastPopUp.selectItem(at: ContrastStandard.allCases.firstIndex(of: ContrastStandard.preferred) ?? 0)
        contrastPopUp.target = self
        contrastPopUp.action = #selector(contrastStandardChanged(_:))
        contrastPopUp.setAccessibilityElement(true)
        contrastPopUp.setAccessibilityRole(.popUpButton)
        contrastPopUp.setAccessibilityLabel("Contrast standard: WCAG 2.2 or APCA")
        contrastStandardPopUp = contrastPopUp
        contentView.addSubview(contrastPopUp)

        y -= ContrastPanelController.rowHeight + ContrastPanelController.sectionPadding

        // Explanation
        let explanationLabel = NSTextField(labelWithString: "Light = on white · Dark = on near-black")
        explanationLabel.font = NSFont.systemFont(ofSize: 10, weight: .regular)
        explanationLabel.textColor = NSColor.tertiaryLabelColor
        explanationLabel.frame = NSRect(x: ContrastPanelController.edgePadding, y: y - 2, width: ContrastPanelController.panelWidth - 2 * ContrastPanelController.edgePadding, height: 16)
        explanationLabel.setAccessibilityElement(true)
        explanationLabel.setAccessibilityRole(.staticText)
        explanationLabel.setAccessibilityLabel("Light means on white background, Dark means on near-black background")
        contentView.addSubview(explanationLabel)

        y -= ContrastPanelController.rowSpacing + 4

        let light = picked.dualContext.onLight
        let dark = picked.dualContext.onDark
        let standard = ContrastStandard.preferred

        // Light row: context swatch + badge
        let lightSwatch = makeContextSwatch(foreground: pickedColor, background: ContrastPanelController.lightBackgroundColor, label: "Color on white")
        lightSwatch.frame = NSRect(x: ContrastPanelController.edgePadding, y: y - 2, width: ContrastPanelController.contextSwatchWidth, height: ContrastPanelController.contextSwatchHeight)
        contentView.addSubview(lightSwatch)

        let lightBadge = badge(for: light, standard: standard)
        let lightLabel = NSTextField(labelWithString: "Light: \(lightBadge)")
        lightLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        lightLabel.textColor = NSColor.secondaryLabelColor
        let lightLabelWidth = ContrastPanelController.panelWidth - 2 * ContrastPanelController.edgePadding - ContrastPanelController.contextSwatchWidth - ContrastPanelController.rowSpacing
        lightLabel.frame = NSRect(x: ContrastPanelController.edgePadding + ContrastPanelController.contextSwatchWidth + ContrastPanelController.rowSpacing, y: y - 2, width: lightLabelWidth, height: ContrastPanelController.rowHeight)
        lightLabel.setAccessibilityElement(true)
        lightLabel.setAccessibilityRole(.staticText)
        lightLabel.setAccessibilityLabel("On white: \(lightBadge)")
        contentView.addSubview(lightLabel)

        y -= ContrastPanelController.rowHeight + ContrastPanelController.rowSpacing

        // Dark row
        let darkSwatch = makeContextSwatch(foreground: pickedColor, background: ContrastPanelController.darkBackgroundColor, label: "Color on dark")
        darkSwatch.frame = NSRect(x: ContrastPanelController.edgePadding, y: y - 2, width: ContrastPanelController.contextSwatchWidth, height: ContrastPanelController.contextSwatchHeight)
        contentView.addSubview(darkSwatch)

        let darkBadge = badge(for: dark, standard: standard)
        let darkLabel = NSTextField(labelWithString: "Dark: \(darkBadge)")
        darkLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        darkLabel.textColor = NSColor.secondaryLabelColor
        let darkLabelWidth = ContrastPanelController.panelWidth - 2 * ContrastPanelController.edgePadding - ContrastPanelController.contextSwatchWidth - ContrastPanelController.rowSpacing
        darkLabel.frame = NSRect(x: ContrastPanelController.edgePadding + ContrastPanelController.contextSwatchWidth + ContrastPanelController.rowSpacing, y: y - 2, width: darkLabelWidth, height: ContrastPanelController.rowHeight)
        darkLabel.setAccessibilityElement(true)
        darkLabel.setAccessibilityRole(.staticText)
        darkLabel.setAccessibilityLabel("On dark: \(darkBadge)")
        contentView.addSubview(darkLabel)

        // Single Copy CTA: main color if passing, accessible suggestion if failing
        y -= ContrastPanelController.rowHeight + ContrastPanelController.sectionPadding
        let copyInfo = copyTargetAndLabel(picked: picked, light: light, dark: dark)
        currentCopyTarget = copyInfo.value
        let copyBtn = NSButton(title: truncateForButton(copyInfo.buttonTitle), target: self, action: #selector(copyColor(_:)))
        copyBtn.bezelStyle = .rounded
        copyBtn.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        copyBtn.frame = NSRect(x: ContrastPanelController.edgePadding, y: y, width: ContrastPanelController.panelWidth - 2 * ContrastPanelController.edgePadding, height: 28)
        copyBtn.setAccessibilityLabel(copyInfo.a11yLabel)
        contentView.addSubview(copyBtn)

        window.contentView = contentView
    }

    private func makeContextSwatch(foreground: NSColor, background: NSColor, label: String) -> NSView {
        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor = background.cgColor
        container.layer?.cornerRadius = 4
        container.layer?.borderWidth = 0.5
        container.layer?.borderColor = NSColor.separatorColor.cgColor

        let bar = NSView()
        bar.wantsLayer = true
        bar.layer?.backgroundColor = foreground.cgColor
        bar.layer?.cornerRadius = 2
        bar.frame = NSRect(x: 4, y: 4, width: 48, height: 12)
        container.addSubview(bar)

        container.setAccessibilityElement(true)
        container.setAccessibilityRole(.image)
        container.setAccessibilityLabel(label)
        return container
    }

    private func truncateForButton(_ title: String, maxLength: Int = 42) -> String {
        if title.count <= maxLength { return title }
        return String(title.prefix(maxLength - 3)) + "..."
    }

    private func copyTargetAndLabel(picked: PickedColor, light: ContrastResult, dark: ContrastResult) -> (value: String, buttonTitle: String, a11yLabel: String) {
        let fmt = ColorFormat.preferred
        let standard = ContrastStandard.preferred
        let passesLight = standard == .wcag22 ? light.passesWCAGAA : light.passesAPCABody
        let passesDark = standard == .wcag22 ? dark.passesWCAGAA : dark.passesAPCABody

        if passesLight && passesDark {
            let str = picked.string(for: fmt)
            return (str, "Copy \(str)", "Copy color \(str)")
        }
        if !passesLight, let fix = picked.lightSuggestion {
            let str = ColorConverter.string(for: fmt, r: fix.r, g: fix.g, b: fix.b)
            return (str, "Copy accessible: \(str)", "Copy accessible shade for light background \(str)")
        }
        if !passesDark, let fix = picked.darkSuggestion {
            let str = ColorConverter.string(for: fmt, r: fix.r, g: fix.g, b: fix.b)
            return (str, "Copy accessible: \(str)", "Copy accessible shade for dark background \(str)")
        }
        let str = picked.string(for: fmt)
        return (str, "Copy \(str)", "Copy color \(str)")
    }

    private func badge(for result: ContrastResult, standard: ContrastStandard) -> String {
        switch standard {
        case .wcag22:
            let wcag = String(format: "%.1f:1", result.wcagRatio)
            let icon = result.passesWCAGAA ? "✓" : "✗"
            return "\(wcag) \(result.wcagLevel.rawValue) \(icon)"
        case .apca:
            let lc = Int(round(abs(result.apcaLc)))
            let icon = result.passesAPCABody ? "✓" : "✗"
            return "Lc \(lc) \(result.apcaLevel.rawValue) \(icon)"
        }
    }

    @objc private func copyFormatChanged(_ sender: NSPopUpButton) {
        guard let title = sender.titleOfSelectedItem else { return }
        let formatPart = title.components(separatedBy: ": ").first?.trimmingCharacters(in: .whitespaces) ?? title
        guard let format = ColorFormat(rawValue: formatPart) else { return }
        ColorFormat.preferred = format
        if picked != nil { updateContent() }
    }

    @objc private func contrastStandardChanged(_ sender: NSPopUpButton) {
        guard let title = sender.titleOfSelectedItem,
              let standard = ContrastStandard(rawValue: title) else { return }
        ContrastStandard.preferred = standard
        if picked != nil { updateContent() }
    }

    @objc private func copyColor(_ sender: Any?) {
        guard let str = currentCopyTarget else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(str, forType: .string)
    }

    // MARK: - NSWindowDelegate

    func windowWillClose(_ notification: Notification) {
        window = nil
    }
}

// MARK: - Layout Constants

private extension ContrastPanelController {
    static var panelContentHeight: CGFloat { 280 }
    static var lightBackgroundColor: NSColor {
        NSColor(srgbRed: CGFloat(DualContextChecker.lightBackground.r), green: CGFloat(DualContextChecker.lightBackground.g), blue: CGFloat(DualContextChecker.lightBackground.b), alpha: 1.0)
    }
    static var darkBackgroundColor: NSColor {
        NSColor(srgbRed: CGFloat(DualContextChecker.darkBackground.r), green: CGFloat(DualContextChecker.darkBackground.g), blue: CGFloat(DualContextChecker.darkBackground.b), alpha: 1.0)
    }
}
