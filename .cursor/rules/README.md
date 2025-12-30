# HEXPal Project Rules

This directory contains Project Rules for HEXPal using Cursor's modern MDC format. These rules guide the AI assistant during development.

## Rule Types

- **alwaysApply: true** - Always included in AI context
- **agentRequested: true** - AI decides when to include based on context
- **globs: ["**/*.swift"]** - Apply to specific file patterns

## Rule Files

1. **core-principles.mdc** - Project philosophy and core values (alwaysApply)
2. **swift-code-standards.mdc** - Swift style guide and architecture (alwaysApply, Swift files)
3. **file-size-limits.mdc** - Strict 400-line file size limit (alwaysApply, Swift files)
4. **documentation-standards.mdc** - Comprehensive documentation requirements including MCP usage (alwaysApply, Swift files)
5. **performance-requirements.mdc** - Performance targets and optimization (alwaysApply)
6. **macos-guidelines.mdc** - macOS-specific best practices (alwaysApply, Swift files)
7. **testing.mdc** - Testing requirements and scenarios (agentRequested)
8. **feature-development.mdc** - Feature development process and Git workflow (agentRequested)
9. **security-privacy.mdc** - Security and privacy guidelines (alwaysApply)
10. **maintenance.mdc** - Maintenance guidelines (agentRequested)

## Migration from .cursorrules

The legacy `.cursorrules` file has been migrated to this new Project Rules format for better organization and flexibility. The old file is kept for reference but is deprecated.

## Adding New Rules

To add a new rule, create a `.mdc` file in this directory with frontmatter:

```mdc
---
description: Brief description of the rule
globs: ["**/*.swift"]  # Optional: file patterns
alwaysApply: true      # or agentRequested: true
---

# Rule Content

Your rule content here...
```
