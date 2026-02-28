# HEXPal Coding Style & Organization Guide

## Overview

This document outlines the coding style and organization standards for HEXPal, designed to ensure clarity, maintainability, and contributor-friendliness for an open source project.

---

## File Size Limits

### Strict Rule: 400 Lines Maximum
- **No Swift file may exceed 400 lines** (including comments and whitespace)
- Files approaching this limit should be refactored proactively
- This ensures code remains readable, maintainable, and easy to understand

### Refactoring Strategy
When a file grows large:
1. Extract related functionality into separate files
2. Use extensions to organize code logically
3. Separate protocol conformances into extension files
4. Split large classes into smaller, focused components
5. Move utility functions to dedicated utility files

### Example Refactoring
**Before:** `MenuBarController.swift` (500 lines)
- Contains: menu logic, color history, hotkey formatting, clipboard, notifications

**After:**
- `MenuBarController.swift` (core menu logic, ~200 lines)
- `MenuBarController+History.swift` (recent colors, ~150 lines)
- `MenuBarController+Formatting.swift` (key code display helpers, ~150 lines)

---

## Coding Style

### Swift API Design Guidelines
Follow the official [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/):
- Use clear, descriptive names
- Prefer clarity over brevity
- Use Swift naming conventions consistently

### Naming Conventions

**Variables & Functions:**
- Use camelCase: `calculateTotalPrice()`, `isColorPickerActive`
- Be descriptive: `colorPickerController` not `cpc`
- Avoid abbreviations: `color` not `clr`, `manager` not `mgr`

**Types:**
- Use PascalCase: `ColorPickerController`, `ColorModel`
- File names match type names exactly

**Booleans:**
- Use prefixes: `is`, `has`, `can`
- Examples: `isActive`, `hasPermission`, `canCapture`

### Code Formatting
- **Indentation:** 4 spaces (not tabs)
- **Line Length:** 100 characters (soft limit), 120 max
- **Spacing:** Consistent spacing around operators and braces
- **Braces:** Opening brace on same line

### Code Organization

#### File Structure
```swift
//
//  ColorConverter.swift
//  HEXPal
//
//  Converts NSColor instances to HEX string format.
//

import AppKit

/// Main type definition
class ColorConverter {
    // Core properties and methods
}

// MARK: - Protocol Conformances
extension ColorConverter: SomeProtocol {
    // Protocol methods
}

// MARK: - Private Helpers
private extension ColorConverter {
    // Private helper methods
}
```

#### Directory Organization
```
HEXPal/
├── App/              # Application entry point
├── Controllers/       # View controllers and managers
├── Models/           # Data models
├── Views/            # UI components
├── Utilities/        # Helper classes
└── Resources/        # Assets and config
```

---

## Documentation Standards

### Inline Documentation (Required)

**Public APIs MUST have documentation:**
```swift
/// Converts an NSColor to a HEX string representation.
///
/// - Parameter color: The color to convert
/// - Returns: A HEX string in the format "#RRGGBB"
/// - Example:
///   ```swift
///   let hex = colorToHex(NSColor.red) // Returns "#FF0000"
///   ```
func colorToHex(_ color: NSColor) -> String {
    // Implementation
}
```

**Complex Logic MUST have comments:**
```swift
// Convert display coordinates to screen capture coordinates
// macOS uses different coordinate systems - this ensures accurate pixel extraction
let capturePoint = convertDisplayToCapture(point: mouseLocation)
```

**Document WHY, not WHAT:**
- ✅ Good: "Convert to sRGB because HEX codes are always in sRGB color space"
- ❌ Bad: "Convert color" (obvious from code)

### External Documentation

**README.md** must include:
- Project overview
- Installation instructions
- Quick start guide
- Usage examples
- Contributing guidelines

**docs/** directory for:
- Architecture overview
- API reference
- Design decisions
- Development setup
- Testing guide

---

## Architecture Principles

### Single Responsibility
Each class/struct should have one clear purpose:
- `ColorPickerManager` - presents NSColorSampler and fires callback
- `ColorHistoryManager` - stores and retrieves recent colors
- `ErrorHandler` - shows user-facing error alerts

### Separation of Concerns
- **Controllers:** Handle user interaction and coordination
- **Models:** Represent data and business logic
- **Views:** Handle UI rendering
- **Utilities:** Provide reusable helper functions

### Protocol-Oriented Design
Use protocols for abstraction and testability:
```swift
protocol ColorConvertible {
    func toHex() -> String
}

extension NSColor: ColorConvertible {
    func toHex() -> String {
        // Implementation
    }
}
```

### Dependency Injection
Avoid singletons - inject dependencies:
```swift
// Good: Dependency injection
class MenuBarController {
    let colorPicker: ColorPickerManager
    
    init(colorPicker: ColorPickerManager = .shared) {
        self.colorPicker = colorPicker
    }
}

// Bad: Hardcoded singleton access scattered throughout code
class MenuBarController {
    func pick() { ColorPickerManager.shared.pickColor() }
}
```

---

## Code Quality Standards

### Clarity Over Cleverness
- Write code that's easy to understand
- Favor explicit over implicit
- Make intent clear through naming

### Error Handling
- Always use try-catch for error-prone operations
- Use Result types for operations that can fail
- Provide user-friendly error messages
- Log errors for debugging

### Type Safety
- Use strong typing, avoid `Any`
- Use optionals appropriately
- Leverage Swift's type system

### Performance
- Profile before optimizing
- Use lazy properties for expensive initialization
- Cache expensive computations
- Avoid unnecessary allocations

---

## Open Source Best Practices

### Code Clarity
- **Self-documenting code:** Names explain purpose
- **Logical structure:** Code flows naturally
- **Comments for WHY:** Explain decisions, not code

### Modularity
- **Clear boundaries:** Well-defined module interfaces
- **Minimal coupling:** Modules don't depend on each other unnecessarily
- **High cohesion:** Related functionality grouped together

### Consistency
- **Follow patterns:** Use established patterns in codebase
- **Consistent formatting:** Same style throughout
- **Consistent naming:** Same terminology everywhere

### Contributor-Friendly
- **Clear structure:** Easy to navigate
- **Well-documented:** Easy to understand
- **Examples provided:** Easy to learn from
- **Guidelines clear:** Easy to contribute

---

## Code Review Checklist

Before submitting code:
- [ ] File size under 400 lines
- [ ] Follows Swift API Design Guidelines
- [ ] Public APIs documented
- [ ] Complex logic commented
- [ ] No linter errors
- [ ] All tests passing
- [ ] Error handling implemented
- [ ] Performance targets met
- [ ] Code is clear and self-documenting
- [ ] Naming is descriptive and consistent

---

## Examples

### Good: Small, Focused File
```swift
//
//  ColorConverter.swift (~150 lines)
//  HEXPal
//
//  Converts NSColor instances to HEX string format.
//

import AppKit

/// Converts colors to HEX string representation.
class ColorConverter {
    /// Converts NSColor to HEX string.
    func toHex(_ color: NSColor) -> String {
        // Implementation
    }
}
```

### Bad: Large Monolithic File
```swift
//
//  ColorManager.swift (~600 lines)
//  Contains: conversion, history, clipboard, UI, etc.
//  Should be split into multiple files
//
```

---

## Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Swift Style Guide](https://github.com/kodecocodes/swift-style-guide)
- [Swift.org Contributing Guide](https://swift.org/contributing/)

---

**Remember:** Code is read more often than it's written. Write for clarity, maintainability, and future contributors.
