#!/bin/bash

# HEXPal Xcode Project Creation Helper Script
# This script helps validate the project structure before creating the Xcode project

set -e

echo "🔍 HEXPal Xcode Project Setup Helper"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Xcode is not installed or xcodebuild is not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Xcode found:$(xcodebuild -version | head -1)${NC}"
echo ""

# Validate project structure
echo "📁 Validating project structure..."
echo ""

MISSING_FILES=0

# Check required directories
for dir in App Controllers Models Utilities Views Resources HexPalTests; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ Directory exists: $dir/${NC}"
    else
        echo -e "${RED}❌ Missing directory: $dir/${NC}"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

echo ""

# Check required files
REQUIRED_FILES=(
    "App/AppDelegate.swift"
    "Controllers/MenuBarController.swift"
    "Resources/Info.plist"
    ".swiftlint.yml"
    "HexPalTests/HexPalTests.swift"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ File exists: $file${NC}"
    else
        echo -e "${RED}❌ Missing file: $file${NC}"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

echo ""

# Check if project already exists
if [ -d "HexPal.xcodeproj" ] || [ -d "HEXPal.xcodeproj" ]; then
    echo -e "${YELLOW}⚠️  Xcode project already exists${NC}"
    echo "   If you want to recreate it, delete the existing .xcodeproj directory first"
    echo ""
fi

# Summary
if [ $MISSING_FILES -eq 0 ]; then
    echo -e "${GREEN}✅ All required files and directories are in place!${NC}"
    echo ""
    echo "📋 Next Steps:"
    echo "   1. Open Xcode"
    echo "   2. Select File → New → Project..."
    echo "   3. Choose macOS → App template"
    echo "   4. Product Name: HexPal"
    echo "   5. Organization Identifier: co.jamcreative"
    echo "   6. Save Location: $(pwd)"
    echo "   7. Uncheck 'Create Git repository'"
    echo "   8. Follow the detailed instructions in XCODE_PROJECT_SETUP.md"
    echo ""
    echo "💡 Tip: After creating the project, run this script again to validate the setup"
    exit 0
else
    echo -e "${RED}❌ Found $MISSING_FILES missing file(s) or directory(ies)${NC}"
    echo "   Please ensure all required files are in place before creating the Xcode project"
    exit 1
fi
