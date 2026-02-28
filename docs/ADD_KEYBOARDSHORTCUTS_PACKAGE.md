# Adding the KeyboardShortcuts Package

Xcode 26's command-line `xcodebuild` has known issues resolving Swift packages. The reliable way to add KeyboardShortcuts is through Xcode's UI.

## Steps (≈2 minutes)

1. Open `HexPal.xcodeproj` in Xcode (double-click or `open HexPal.xcodeproj`).

2. **File → Add Package Dependencies...**

3. In the search field, paste:
   ```
   https://github.com/sindresorhus/KeyboardShortcuts
   ```

4. Set **Dependency Rule** to "Up to Next Major Version" with minimum `2.4.0`.

5. Click **Add Package**.

6. In the dialog, ensure **KeyboardShortcuts** is selected and the **HexPal** target is checked. Click **Add Package**.

7. Build (⌘B). Xcode will resolve and fetch the package, then build.

8. Commit `Package.resolved` so it's available in version control:
   - Path: `HexPal.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
   - Keep it out of `.gitignore` (it's already not ignored).

## After Adding

Once added via the UI, `xcodebuild` from the command line should work because the package will already be resolved in DerivedData. Future `git clone` + `xcodebuild` builds will use the committed `Package.resolved` to fetch the correct version.

## Version

- **Package URL:** https://github.com/sindresorhus/KeyboardShortcuts
- **Minimum version:** 2.4.0 (macOS 10.15+, Carbon APIs, no permissions required)
- **Deployment target:** HexPal uses macOS 11.5+; compatible
