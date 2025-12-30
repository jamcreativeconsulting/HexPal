#!/bin/bash
# Script to help identify files that should be excluded from HexPal target
# Note: This script only lists files - actual exclusion must be done in Xcode

echo "Files that should be EXCLUDED from HexPal target:"
echo "=================================================="
echo ""
echo "Documentation files:"
find . -maxdepth 1 -name "*.md" -o -name "LICENSE" -o -name "CONTRIBUTING*" -o -name "CODE_OF_CONDUCT*" | grep -v ".git" | sort | sed 's/^\.\//  - /'
echo ""
echo "Configuration files:"
find . -maxdepth 1 -name ".gitignore" -o -name ".swiftlint*" | grep -v ".git" | sed 's/^\.\//  - /'
echo ""
echo "Directories to exclude:"
echo "  - .cursor/"
echo "  - .github/"
echo "  - docs/"
echo ""
echo "To exclude these files in Xcode:"
echo "1. Select files/folders in Project Navigator"
echo "2. Open File Inspector (right sidebar)"
echo "3. Under 'Target Membership', uncheck 'HexPal'"
echo ""
echo "Files that SHOULD be included:"
echo "  - App/*.swift"
echo "  - Controllers/*.swift"
echo "  - Models/*.swift"
echo "  - Utilities/*.swift"
echo "  - Views/*.swift"
echo "  - Resources/Info.plist (handled automatically via INFOPLIST_FILE)"
