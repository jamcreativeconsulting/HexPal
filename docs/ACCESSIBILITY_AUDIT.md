# HexPal Accessibility Audit (WCAG 2.2 AA)

HexPal must be 100% WCAG 2.2 AA accessible. This document tracks VoiceOver support across all features.

## Compliance Requirements (hexpal-project.mdc)

- Every interactive UI element: `accessibilityLabel`
- Interactive elements: `accessibilityHint` when action is non-obvious
- Images/icons: meaningful labels or `accessibilityHidden` if decorative
- Color never sole indicator — pair with text/icons/labels
- App UI contrast: 4.5:1 text, 3:1 large text
- Full keyboard navigation
- VoiceOver announces all content
- No focus traps
- Dynamic content announced via `accessibilityValue` or live regions

## Feature Coverage

### 1. Menu Bar Icon & Dropdown (MenuBarController)

| Element | VoiceOver Support | Notes |
|---------|-------------------|-------|
| Status item button | ✅ | `accessibilityLabel`: "HEXPal. Click to open menu and pick a color." `accessibilityHelp`: Double-tap to open menu |
| Menu bar icon (eyedropper) | ✅ | `accessibilityDescription`: "HEXPal color picker" |
| Pick Color menu item | ✅ | Title read; `toolTip` adds context |
| Recent Colors submenu | ✅ | `toolTip` on parent item |
| Recent color items | ✅ | Title = HEX (announced); `toolTip`: "Copy [hex] to clipboard. Double-tap to select." |
| Clear History | ✅ | `toolTip` |
| Preferences | ✅ | `toolTip` |
| About | ✅ | NSAlert — system default |
| Quit | ✅ | Standard menu item |

### 2. Clipboard Notification (ClipboardNotificationView)

Shown after picking a color or selecting from recent colors.

| Element | VoiceOver Support | Notes |
|---------|-------------------|-------|
| Main content (clickable) | ✅ | `accessibilityRole`: button. `accessibilityLabel`: "Color [hex] copied to clipboard. Success." `accessibilityHelp`: Double-tap to copy again |
| Color swatch | ✅ | `accessibilityRole`: image. `accessibilityLabel`: "Color swatch for [hex]" |
| Checkmark | ✅ | `accessibilityLabel`: "Copied successfully" |
| HEX label | ✅ | `accessibilityLabel`: "HEX code [hex]" |
| "⌘V to paste" tooltip | ✅ | `accessibilityLabel`: "Press Command V to paste" |
| Window title | ✅ | "HEXPal color copied" |
| Blur background | ✅ | `setAccessibilityElement(false)` — decorative |

### 3. Menu Bar Hint (MenuBarHintView)

First-launch hint: "Click here or press ⌘⇧P to pick a color"

| Element | VoiceOver Support | Notes |
|---------|-------------------|-------|
| Content view | ✅ | `accessibilityRole`: group. `accessibilityLabel`: "HEXPal first-launch hint. [message]" |
| Message label | ✅ | `accessibilityLabel`, `accessibilityHelp` |
| Window title | ✅ | "HEXPal hint" |
| Blur background | ✅ | Decorative (hidden) |

### 4. Welcome Notification (WelcomeNotificationView)

First-launch welcome with hotkey hint.

| Element | VoiceOver Support | Notes |
|---------|-------------------|-------|
| Content (click to dismiss) | ✅ | `accessibilityRole`: button. Label + Help |
| Palette emoji | ✅ | `setAccessibilityElement(false)` — decorative |
| Welcome text | ✅ | NSTextField (read by default) |
| Tagline | ✅ | NSTextField |
| Hotkey label | ✅ | `accessibilityLabel`: "Press Command Shift P to pick a color" |
| Window title | ✅ | "HEXPal welcome" |
| Blur background | ✅ | Decorative (hidden) |

### 5. Preferences Window (PreferencesWindowController)

| Element | VoiceOver Support | Notes |
|---------|-------------------|-------|
| "Pick Color Shortcut" label | ✅ | `accessibilityLabel` |
| Keyboard shortcut recorder | ✅ | `accessibilityLabel`, `accessibilityHelp` |
| "Launch at Login" title | ✅ | `accessibilityLabel` |
| Launch checkbox | ✅ | `accessibilityLabel`, `accessibilityHelp` |
| Window | ✅ | Title: "HEXPal Preferences" |

### 6. System Color Picker (NSColorSampler)

Apple's system API. Provides its own magnifier loupe and is accessible by default. No HexPal code controls it.

---

## Technical Limitations & System Constraints

HexPal intentionally uses **zero system permissions** (no Accessibility, no Screen Recording). This design choice creates technical constraints we cannot override:

| Constraint | Cause | Impact |
|------------|-------|--------|
| **Color picker UI** | HexPal uses `NSColorSampler` — Apple's system API. We call `show()` and receive a color. We have **no API** to customize the loupe, announcements, or focus order. | Whatever VoiceOver announces during color sampling (instructions, live color values, etc.) is determined entirely by Apple. HexPal cannot change it. |
| **Alternative: custom picker** | A custom accessible color picker would require screen capture (e.g., `CGWindowListCreateImage`, Screen Recording permission). | HexPal's architecture explicitly forbids this. See hexpal-project.mdc Forbidden Patterns. |

**What HexPal does control:** All UI we build — menu, notifications, preferences, hints — has full VoiceOver support (labels, hints, roles). Post-pick: the clipboard notification announces the copied HEX clearly.

**What HexPal does NOT control:** The system color sampling loupe, its keyboard navigation, and any announcements made while the loupe is active.

## Verification Checklist

Before every release:

- [ ] Enable VoiceOver (Cmd+F5)
- [ ] Navigate menu bar icon → menu opens, items announced
- [ ] Pick color (hotkey or menu) → system picker appears, pick a color
- [ ] Clipboard notification appears → announces "Color [hex] copied to clipboard. Success."
- [ ] Double-tap notification → re-copies; "⌘V to paste" tooltip announced
- [ ] Open Recent Colors → each HEX announced with "Copy to clipboard" hint
- [ ] Select recent color → copies; notification announced
- [ ] Open Preferences → hotkey recorder and checkbox announced with hints
- [ ] First launch: Welcome and Menu Bar Hint both announced and dismissible
- [ ] Full flow keyboard navigable; no focus traps
- [ ] App UI contrast meets 4.5:1 (text) / 3:1 (large text)

---

## Conformance Statement

**Scope of conformance:** HexPal implements WCAG 2.2 AA for all user interface components it creates and controls. The system color picker (`NSColorSampler`) is provided by Apple; HexPal cannot modify its accessibility behavior.

**Partial conformance (Level AA):** Per WCAG 2.2, conformance can be claimed "except for" specific content or processes. HexPal's exception: the color sampling loupe shown during "Pick Color" is a third-party/system component outside our control. All other UI meets WCAG 2.2 AA.

**Documentation purpose:** This audit and the limitations section document our technical constraints in good faith. Accessibility laws (e.g., ADA, Section 508, AODA) vary by jurisdiction. **Liability and legal compliance are legal matters.** JAM Creative should consult qualified legal counsel for liability concerns. This document is technical documentation only, not legal advice.

---

## Future Features (V2)

When adding F1–F10 (multi-format copy, contrast badge, Fix It, etc.):

- Every new interactive element: `accessibilityLabel` + `accessibilityHint` if needed
- Contrast results: announced via `accessibilityValue` or live region
- "Fix It" button: clear label and hint
- Palette Report Card: table/grid with proper headers and cell associations
- See new-feature-checklist: VoiceOver tested (Cmd+F5) for every UI change
