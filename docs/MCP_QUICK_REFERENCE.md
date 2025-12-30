# HEXPal - MCP Quick Reference Guide

## Quick Start

### Using Context7 MCP

**Query Format:**
```
@context7 [your question about Swift/macOS development]
```

**Example Queries:**
```
@context7 How to capture screen pixels using Core Graphics in Swift?
@context7 Best practices for menu bar applications in macOS
@context7 How to register global hotkeys in Swift for macOS?
@context7 Swift clipboard management examples
@context7 NSStatusItem menu bar implementation examples
```

**Library ID:** `/swiftlang/swift`

### Using Sequential Thinking MCP

**Query Format:**
```
@sequential-thinking [complex problem or architecture question]
```

**Example Queries:**
```
@sequential-thinking How should we handle multi-display screen capture 
with different color profiles while maintaining accuracy?

@sequential-thinking What's the best architecture for a menu bar app 
that needs to capture screen pixels and display results quickly?
```

---

## Common Development Scenarios

### Scenario 1: Implementing Screen Capture

**Query Context7:**
```
@context7 How to use CGWindowListCreateImage to capture screen 
and extract pixel color data in Swift?
```

**Then use Sequential Thinking:**
```
@sequential-thinking What's the best approach for capturing screen 
pixels accurately across multiple displays with different resolutions?
```

### Scenario 2: Global Hotkey Implementation

**Query Context7:**
```
@context7 How to register and handle global keyboard shortcuts 
in a macOS Swift application?
```

**Reference:** Also check MASShortcut library documentation

### Scenario 3: Menu Bar App Setup

**Query Context7:**
```
@context7 How to create a menu bar only application in Swift 
without dock icon?
```

**Reference:** Apple AppKit documentation for NSStatusItem

### Scenario 4: Color Conversion

**Query Context7:**
```
@context7 How to convert NSColor to HEX string format in Swift?
```

### Scenario 5: Clipboard Management

**Query Context7:**
```
@context7 How to copy text to clipboard programmatically in Swift?
```

---

## MCP Workflow Tips

### 1. Start with Context7
- Get code examples and patterns
- Understand Swift best practices
- Find similar implementations

### 2. Use Sequential Thinking for Complex Problems
- Break down architecture decisions
- Plan multi-step implementations
- Debug complex issues

### 3. Cross-Reference with Official Docs
- Always verify Context7 results with Apple docs
- Use Context7 for patterns, Apple docs for API specifics
- Combine both for best results

### 4. Document MCP Usage
- Note which queries helped solve problems
- Save useful code examples
- Update this guide with new patterns

---

## Troubleshooting

### Context7 Not Working?
1. Check MCP configuration in Cursor settings
2. Verify npm/node installation: `node --version` (needs 18+)
3. Try reinstalling: `npm install -g @upstash/context7-mcp`
4. Check network connectivity

### Getting Generic Results?
- Be more specific in queries
- Include "Swift" and "macOS" in queries
- Reference specific APIs (e.g., "AppKit", "Core Graphics")

### Need Apple-Specific APIs?
- Context7 may not have all Apple framework docs
- Use Apple Developer Documentation directly
- Combine Context7 patterns with Apple API docs

---

## Best Practices

✅ **Do:**
- Use Context7 for Swift language patterns
- Use Sequential Thinking for complex problems
- Cross-reference with official Apple docs
- Document useful queries and results

❌ **Don't:**
- Rely solely on MCPs without verification
- Skip reading official Apple documentation
- Use outdated patterns without checking
- Ignore Apple's Human Interface Guidelines

---

## Useful Context7 Library IDs

- `/swiftlang/swift` - Swift language documentation (Primary)

**Note:** For Apple-specific frameworks (AppKit, Core Graphics), reference:
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- Official API references
- WWDC session videos

---

**Last Updated:** [Current Date]  
**Quick Reference:** Keep this handy during development
