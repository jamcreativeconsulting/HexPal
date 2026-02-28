# HEXPal Project Rules

This directory contains Project Rules for HEXPal using Cursor's modern MDC format. These rules guide the AI assistant during development.

## Source of Truth

**hexpal-project.mdc** is the single source of truth for architecture, file rules, code quality, forbidden patterns, and dependencies. All other rules supplement it and reference it to avoid duplication.

## Rule Types

- **alwaysApply: true** - Always included in AI context
- **agentRequested: true** - AI decides when to include based on context
- **globs: ["**/*.swift"]** - Apply to specific file patterns

## Rule Files

1. **hexpal-project.mdc** - **Source of truth.** Architecture, file rules, forbidden patterns, color math (alwaysApply, Swift files)
2. **hexpal-testing.mdc** - Unit test structure, naming, reference values (alwaysApply, test files)
3. **core-principles.mdc** - Project philosophy (alwaysApply)
4. **swift-code-standards.mdc** - Swift style guide; supplements hexpal-project (alwaysApply, Swift files)
5. **file-size-limits.mdc** - Refactoring guidance; rule in hexpal-project (alwaysApply, Swift files)
6. **documentation-standards.mdc** - Doc format and MCP usage; hexpal-project requires /// doc comments (alwaysApply, Swift files)
7. **performance-requirements.mdc** - Performance targets (alwaysApply)
8. **macos-guidelines.mdc** - Platform specifics; supplements hexpal-project (alwaysApply, Swift files)
9. **security-privacy.mdc** - Privacy and logging; hexpal-project defines forbidden patterns (alwaysApply)
10. **testing.mdc** - Manual/integration scenarios; hexpal-testing for unit tests (agentRequested)
11. **feature-development.mdc** - Feature process and Git workflow (agentRequested)
12. **maintenance.mdc** - Maintenance guidelines (agentRequested)

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
