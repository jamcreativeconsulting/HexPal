# HEXPal - MCP (Model Context Protocol) Strategy

## Overview

This document outlines the MCP servers and tools that will be used during HEXPal development to ensure reliable, up-to-date code and easy maintenance.

---

## Primary MCP: Context7

### Purpose
Context7 provides up-to-date documentation and code examples for Swift, AppKit, and Core Graphics frameworks. This ensures we're using current best practices and APIs.

### Configuration

**Installation:**
```bash
npm install -g @upstash/context7-mcp
```

**MCP Client Configuration (Cursor):**
Add to your MCP configuration file:
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

### Context7 Libraries for HEXPal

#### 1. Swift Language Documentation
- **Library ID:** `/swiftlang/swift`
- **Use Cases:**
  - Swift syntax and best practices
  - Type safety and error handling
  - Modern Swift features (async/await, concurrency)
  - Memory management

**Example Queries:**
- "How to implement global hotkey registration in Swift?"
- "Best practices for menu bar apps in Swift"
- "Swift clipboard management examples"

#### 2. Apple Framework Documentation
While Context7 may not have direct Apple framework docs, we'll use it for:
- Swift language features
- General macOS development patterns
- Code examples and snippets

**Note:** For Apple-specific APIs (AppKit, Core Graphics), we'll reference:
- Official Apple Developer Documentation
- Apple Developer Forums
- WWDC sessions

### Usage During Development

When implementing features, use Context7 queries like:
```
@context7 How to capture screen pixels using Core Graphics in Swift?
@context7 Show me examples of menu bar app implementation in Swift
@context7 Best practices for global hotkey handling in macOS apps
```

---

## Secondary MCP: Sequential Thinking

### Purpose
Sequential thinking MCP helps break down complex problems into manageable steps, which is valuable for:
- Architecture decisions
- Debugging complex issues
- Planning feature implementations
- Problem-solving during development

### When to Use
- Complex technical challenges (screen capture, hotkey conflicts)
- Architecture planning
- Debugging difficult bugs
- Performance optimization decisions

### Example Usage
```
@sequential-thinking How should we handle multi-display screen capture 
with different color profiles while maintaining accuracy?
```

---

## Additional MCPs Considered

### Browser Tools (Puppeteer) - Optional
**Status:** Not critical for this project

**Potential Use Cases:**
- Testing web-based documentation
- Scraping Apple Developer docs (if needed)
- Testing any web-based components (unlikely for native app)

**Decision:** Skip for MVP, add later if needed for documentation/testing

### Shadcn UI - Not Applicable
**Status:** Not relevant

**Reason:** Shadcn is for React/web UI components. HEXPal is a native macOS app using AppKit/SwiftUI.

---

## MCP Usage Workflow

### During Development

1. **Planning Phase**
   - Use Context7 to research Swift/AppKit patterns
   - Use Sequential Thinking for architecture decisions

2. **Implementation Phase**
   - Query Context7 for code examples
   - Use Sequential Thinking for complex implementations
   - Reference Apple docs for API specifics

3. **Debugging Phase**
   - Use Sequential Thinking to break down problems
   - Query Context7 for similar issues/solutions

4. **Optimization Phase**
   - Use Sequential Thinking for performance analysis
   - Query Context7 for optimization patterns

---

## Documentation References

### Primary Sources (via Context7)
- Swift Language Documentation (`/swiftlang/swift`)
- Swift best practices and patterns

### Secondary Sources (Direct)
- [Apple AppKit Documentation](https://developer.apple.com/documentation/appkit)
- [Core Graphics Documentation](https://developer.apple.com/documentation/coregraphics)
- [Quartz Window Services](https://developer.apple.com/documentation/coregraphics/quartz_window_services)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)

### Code Examples & Libraries
- [MASShortcut](https://github.com/shpakovski/MASShortcut) - Global hotkey library
- [SwiftUI Menu Bar Examples](https://github.com/topics/swift-menu-bar-app)
- Apple WWDC Sessions (menu bar apps, screen capture)

---

## MCP Integration in Code

### Example: Using Context7 for Screen Capture

When implementing screen capture, query Context7:
```
@context7 How to capture screen pixels using CGWindowListCreateImage 
and extract color data in Swift?
```

### Example: Using Sequential Thinking for Architecture

When planning the color picker overlay:
```
@sequential-thinking What's the best approach for implementing a 
full-screen overlay window with magnifying glass that captures 
pixel colors accurately across multiple displays?
```

---

## Maintenance Strategy

### Regular Updates
1. **Weekly:** Check Context7 for Swift language updates
2. **Monthly:** Review Apple documentation for API changes
3. **As Needed:** Query Context7 when implementing new features

### Version Management
- Pin Context7 to stable versions when possible
- Test MCP updates before adopting in production code
- Keep backup of working configurations

### Documentation Sync
- Update this document when adding new MCPs
- Document any MCP-specific patterns or conventions
- Share MCP usage patterns with team

---

## Troubleshooting

### Context7 Not Responding
1. Check npm/node version (requires Node 18+)
2. Verify MCP configuration in Cursor
3. Try reinstalling: `npm install -g @upstash/context7-mcp`
4. Check network connectivity

### Sequential Thinking Not Available
- Use manual problem-solving approach
- Document reasoning in code comments
- Break down problems into smaller steps manually

---

## Best Practices

1. **Always verify Context7 results** - Cross-reference with official Apple docs
2. **Use Sequential Thinking for complex problems** - Don't skip the thinking process
3. **Document MCP usage** - Note which MCPs helped with which features
4. **Keep MCPs updated** - But test updates before adopting
5. **Don't over-rely on MCPs** - Use them as tools, not crutches

---

## Summary

### Active MCPs
- ✅ **Context7** - Primary documentation and code examples
- ✅ **Sequential Thinking** - Complex problem-solving

### Inactive/Not Needed
- ❌ Browser Tools - Not relevant for native app
- ❌ Shadcn UI - Not applicable (React/web only)

### Key Libraries (Context7)
- `/swiftlang/swift` - Swift language documentation

---

**Last Updated:** [Current Date]  
**Status:** Active  
**Next Review:** After MVP completion
