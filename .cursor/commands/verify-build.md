---
description: Run before every commit — builds, tests, and checks for quality violations
---

Run these verification steps in order. Stop and report at the FIRST failure:

1. BUILD CHECK: Build the HexPal target. Zero errors, zero warnings required.

2. TEST CHECK: Run all tests in HexPalTests. Zero failures required.

3. FORBIDDEN PATTERNS: Search the entire project. Each must return ZERO results:
   - `AXIsProcessTrusted` (accessibility permission — forbidden)
   - `CGRequestScreenCaptureAccess` (screen recording — forbidden)
   - `CGWindowListCreateImage` (custom screen capture — forbidden)
   - `print(` in any non-test .swift file (use os_log instead)
   - `// TODO` or `// FIXME` or `// HACK` (use GitHub issues)
   - `try!` in any non-test .swift file (handle errors explicitly)

4. FILE SIZE CHECK: No .swift file exceeds 400 lines.

5. IMPORT CHECK: No file in Utilities/ imports AppKit, SwiftUI, or Cocoa.

6. TEST COVERAGE CHECK: Every .swift file in Utilities/ has a corresponding *Tests.swift in HexPalTests/.

7. ACCESSIBILITY CHECK (WCAG 2.2 AA): Manual — run VoiceOver (Cmd+F5) and verify: all interactive elements are announced with labels; picked color and contrast results are announced; full flow is keyboard navigable; no focus traps. Every View/NSView with user interaction must have accessibilityLabel (or accessibilityHidden for decorative only).

Report "✅ All checks passed" or list every violation found with file and line number.
