# Contributing to HEXPal

Thank you for your interest in contributing to HEXPal! This document provides guidelines and instructions for contributing to the project.

## 🎯 Our Philosophy

HEXPal follows a **speed-first design** philosophy:
- Optimize for the most common use case (getting HEX codes quickly)
- Keep it simple - do one thing exceptionally well
- Every feature must justify its impact on speed
- Free and open source forever

Before contributing, ask yourself: **"Does this make getting HEX codes faster or simpler?"**

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [Feature Development](#feature-development)
- [Bug Reports](#bug-reports)
- [Documentation](#documentation)

## 📜 Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). We are committed to providing a welcoming and inclusive environment for all contributors.

## 🚀 Getting Started

### Prerequisites

- macOS 11.0 (Big Sur) or later
- Xcode 14.0 or later
- Swift 5.7 or later
- Git

### Setting Up Your Development Environment

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/jamcreativeconsulting/HEXPal.git
   cd HEXPal
   ```

3. **Add upstream** remote:
   ```bash
   git remote add upstream https://github.com/jamcreativeconsulting/HEXPal.git
   ```

4. **Open** the project in Xcode:
   ```bash
   open HEXPal.xcodeproj
   ```

5. **Build** and run to verify setup:
   - Press `Cmd+B` to build
   - Press `Cmd+R` to run

## 💻 Development Setup

### Project Structure

```
HEXPal/
├── App/                    # Application entry point
├── Controllers/            # View controllers and managers
├── Models/                 # Data models
├── Utilities/              # Helper classes and utilities
├── Views/                  # UI components
├── Resources/              # Assets and configuration
├── HEXPalTests/            # Unit tests
└── docs/                   # Documentation
```

### Code Quality Tools

- **SwiftLint** - Code style enforcement (configured via `.swiftlint.yml`)
- **File Size Checks** - Maximum 400 lines per Swift file
- **Documentation Checks** - All public APIs must be documented

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme HEXPal

# Run tests from Xcode
Cmd+U
```

## 📐 Coding Standards

### Swift Style Guide

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use 4 spaces for indentation (not tabs)
- Limit line length to 100 characters (soft limit, 120 max)
- Use meaningful, descriptive names
- Prefer `let` over `var` when possible
- Use guard statements for early returns

See [`docs/CODING_STYLE.md`](docs/CODING_STYLE.md) for complete coding standards.

### File Organization

- **One primary type per file** (class, struct, enum)
- **File name matches type name** exactly
- **Maximum 400 lines** per Swift file (strict limit)
- Use extensions to organize code within files
- Group related functionality together

### Architecture Patterns

- **MVC** - Model-View-Controller pattern
- **Separation of Concerns** - Keep controllers, models, utilities separate
- **Single Responsibility** - Each class should have one clear purpose
- **Protocol-Oriented** - Use protocols for abstraction and testability

### Code Review Checklist

Before submitting a pull request, ensure:

- [ ] Code follows Swift API Design Guidelines
- [ ] No SwiftLint errors or warnings
- [ ] All tests passing
- [ ] File size under 400 lines
- [ ] All public APIs have doc comments
- [ ] Complex logic has explanatory comments
- [ ] Error handling implemented
- [ ] Performance targets met
- [ ] No memory leaks
- [ ] Code is clear and self-documenting

## 🧪 Testing Requirements

### Test Coverage Goals

- **Core utilities:** 80%+ coverage
- **Color conversion:** 100% coverage
- **Screen capture:** Test with mock data

### Test Scenarios

Before committing, test:
- [ ] On latest macOS version
- [ ] With multiple displays
- [ ] With different color profiles
- [ ] Hotkey works reliably
- [ ] Memory usage acceptable
- [ ] No crashes

See [`docs/PRE_SETUP_CONSIDERATIONS.md`](docs/PRE_SETUP_CONSIDERATIONS.md) for detailed testing scenarios.

### Writing Tests

- Write tests alongside code
- Test both success and failure cases
- Use descriptive test names
- Keep tests focused and independent

## 🔀 Pull Request Process

### Branch Strategy

- `main` - Production-ready code
- `develop` - Development branch (if used)
- `feature/*` - New features
- `fix/*` - Bug fixes
- `docs/*` - Documentation updates

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks

**Examples:**
```
feat: Add color history feature
fix: Resolve hotkey conflict detection
docs: Update API documentation for ColorConverter
refactor: Extract screen capture logic to separate file
```

### Pull Request Checklist

Before submitting a PR:

- [ ] Code follows all coding standards
- [ ] All tests passing
- [ ] Documentation updated
- [ ] No linter errors
- [ ] Performance targets met
- [ ] File size limits respected
- [ ] Commit messages follow convention
- [ ] PR description explains changes clearly
- [ ] References related issues

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring
- [ ] Performance improvement

## Testing
How was this tested?

## Related Issues
Closes #123
```

## 🎨 Feature Development

### Before Adding Features

Ask these questions:
1. Does this make getting HEX codes faster?
2. Do users actually need this?
3. Will this slow down the core workflow?
4. Can we achieve the goal more simply?
5. Is this consistent with our speed-first philosophy?

### Feature Development Process

1. **Discuss** - Open an issue to discuss the feature first
2. **Plan** - Update `docs/PLAN.md` with feature details
3. **Implement** - Follow coding standards and architecture
4. **Test** - Write tests and verify performance
5. **Document** - Update README and code comments
6. **Submit** - Create pull request with clear description

### MVP Features (Must Have)

- Menu bar icon
- Global hotkey (Cmd+Shift+C)
- Screen color picker with magnifying glass
- HEX code display
- Automatic clipboard copy
- Visual confirmation

### Post-MVP Features

- Color history
- Multiple formats (RGB, HSL)
- Customizable hotkey
- Palette management
- Contrast checker

See [`.cursor/rules/feature-development.mdc`](.cursor/rules/feature-development.mdc) for feature development guidelines.

## 🐛 Bug Reports

### Before Reporting

1. Check if the bug has already been reported
2. Test on the latest version
3. Try to reproduce the issue

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- macOS version:
- HEXPal version:
- System information:

**Screenshots**
If applicable

**Additional Context**
Any other relevant information
```

## 📚 Documentation

### Inline Documentation

- **Public APIs** - Must have doc comments
- **Complex Logic** - Must have explanatory comments
- **Edge Cases** - Document limitations and gotchas

### External Documentation

- Update README.md for user-facing changes
- Update docs/ for architecture changes
- Add examples for new features

See [`docs/documentation-standards.mdc`](.cursor/rules/documentation-standards.mdc) for complete documentation requirements.

## 🎯 Performance Requirements

All contributions must meet these targets:

- **Activation:** < 100ms from hotkey to picker ready
- **Total Workflow:** < 2 seconds from activation to HEX in clipboard
- **Memory:** < 50MB RAM usage
- **CPU:** < 1% idle, < 5% when active

Profile before optimizing. Avoid premature optimization.

## 🔒 Security & Privacy

- No data collection
- No network requests (unless explicitly needed)
- Local-only operation
- Handle permissions gracefully
- Don't log sensitive information

## ❓ Questions?

- **Issues:** [GitHub Issues](https://github.com/jamcreativeconsulting/HEXPal/issues)
- **Discussions:** [GitHub Discussions](https://github.com/jamcreativeconsulting/HEXPal/discussions)
- **Email:** jordan@jamcreative.co
- **GitHub:** [@jbeur](https://github.com/jbeur)
- **Documentation:** See `docs/` directory

## 🙏 Thank You!

Your contributions make HEXPal better for everyone. We appreciate your time and effort!

---

**Remember:** Speed, simplicity, and reliability are our priorities. When in doubt, choose the simpler, faster option.
