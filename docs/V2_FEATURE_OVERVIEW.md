# HexPal v2 — Feature Overview

## Strategic Context
HexPal is a free, zero-permission macOS menu bar color picker that serves as lead generation for JAM Creative's accessibility consulting. Positioned as the only native macOS picker with WCAG 2.x + APCA dual contrast, OKLCH support, and light/dark dual-context checking.

## v2.0 Features (Launch)

### F1: Multi-Format Color Copy
Copy picked colors in 8+ formats: hex, rgb, hsl, OKLCH, CSS custom property, Tailwind class, Swift UIColor, SwiftUI Color. OKLCH support differentiates from all other macOS pickers.

### F2: Dual Contrast Badge (WCAG 2.x + APCA)
Every picked color shows both WCAG 2.x contrast ratio AND APCA Lc score. No other macOS picker shows APCA. APCA is the candidate algorithm for WCAG 3.0 (estimated ~2030).

### F3: Light/Dark Dual-Context Check
Contrast checked against both white (#FFFFFF) and dark (#1E1E1E) backgrounds simultaneously. 80%+ of users use dark mode. No other macOS picker tests both contexts at once.

### F4: "Fix It" — Nearest Accessible Shade
When contrast fails, one-click suggestion of the nearest accessible shade using OKLCH perceptual lightness shift. Preserves hue and chroma, adjusts only lightness. ColorSlurp charges for this behind Pro paywall.

### F5: Palette History
Last 20 picked colors persisted across sessions. Enables the Palette Report Card in v2.1.

## v2.1 Features (Post-Launch)
- F6: Palette Report Card (contrast matrix for all saved colors)
- F7: Near-duplicate color detection (ΔE < 3 flagged)
- F8: Export as design tokens (CSS, JSON, Tailwind config)

## v2.2 Features (Future)
- F9: Colorblind simulation preview
- F10: Accessible palette generation from single brand color

## Architecture
- All color math: pure Swift, zero dependencies, in Utilities/
- All models: Codable structs in Models/
- Every utility file has a 1:1 test file in HexPalTests/
- Only external dependency: KeyboardShortcuts

## Dependency Policy
ZERO new external dependencies for v2. All color math (OKLCH, WCAG, APCA, ΔE) is pure Swift. The canonical reference implementations are ported directly.
