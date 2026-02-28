---
description: Checklist when adding any new feature to HexPal
---

Before implementing a new feature, verify ALL of the following:

PRE-IMPLEMENTATION:
- [ ] New files planned in correct directory (Utilities/ for pure logic, Models/ for data, Views/ for UI, Controllers/ for managers)
- [ ] No new external dependencies
- [ ] Test file(s) planned for every new Utilities/ and Models/ file
- [ ] Estimated line count — no file will exceed 400 lines

DURING IMPLEMENTATION:
- [ ] Every new public type and function has a /// doc comment
- [ ] All color math uses Double precision
- [ ] No force unwraps except in tests
- [ ] Utilities/ files have ZERO AppKit/SwiftUI imports
- [ ] Named constants for all threshold values and magic numbers
- [ ] Every new UI element has accessibilityLabel; interactive elements have accessibilityHint where needed (WCAG 2.2 AA)

POST-IMPLEMENTATION:
- [ ] Test file written with ≥ 5 test cases per utility file
- [ ] Tests include edge cases (pure black, pure white, boundary values)
- [ ] Full test suite passes (run verify-build command)
- [ ] No new warnings in the build
- [ ] Existing features still work (color pick → copy workflow unbroken)
- [ ] File sizes verified under 400 lines
- [ ] VoiceOver tested (Cmd+F5): all UI announced, keyboard navigation works, no focus traps
