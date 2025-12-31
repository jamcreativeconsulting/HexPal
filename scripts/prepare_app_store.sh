#!/bin/bash

# HEXPal App Store Preparation Script
# This script helps prepare HEXPal for Mac App Store submission

set -e

echo "🚀 HEXPal App Store Preparation"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -f "HexPal.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Must run from HEXPal project root directory"
    exit 1
fi

echo "This script will help you prepare HEXPal for Mac App Store submission."
echo ""
echo "Prerequisites:"
echo "  ✅ Apple Developer account"
echo "  ✅ App Store Connect app record created"
echo "  ✅ Screenshots prepared"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

echo ""
echo "📋 Pre-Submission Checklist:"
echo ""

# Check Info.plist for required keys
echo "Checking Info.plist..."
if grep -q "NSAccessibilityUsageDescription" Resources/Info.plist; then
    echo "  ✅ NSAccessibilityUsageDescription present"
else
    echo "  ⚠️  NSAccessibilityUsageDescription missing (adding now...)"
    # This would need to be done manually or with a more complex script
    echo "  ⚠️  Please add NSAccessibilityUsageDescription to Info.plist"
fi

if grep -q "NSScreenCaptureUsageDescription" Resources/Info.plist; then
    echo "  ✅ NSScreenCaptureUsageDescription present"
else
    echo "  ❌ NSScreenCaptureUsageDescription missing"
fi

# Check for app icon
if [ -d "Resources/Assets.xcassets/AppIcon.appiconset" ]; then
    ICON_COUNT=$(find Resources/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
    if [ "$ICON_COUNT" -gt 0 ]; then
        echo "  ✅ App icon found ($ICON_COUNT images)"
    else
        echo "  ⚠️  App icon directory exists but no images found"
    fi
else
    echo "  ⚠️  App icon not found (optional but recommended)"
fi

echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Open HexPal.xcodeproj in Xcode"
echo "2. Verify Signing & Capabilities:"
echo "   - Team: Your Apple Developer team"
echo "   - Bundle ID: co.jamcreative.HexPal"
echo "   - App Sandbox: Enabled"
echo "   - Hardened Runtime: Enabled"
echo ""
echo "3. Create Archive:"
echo "   - Product → Archive"
echo "   - Wait for archive to complete"
echo ""
echo "4. Distribute to App Store:"
echo "   - In Organizer, select archive"
echo "   - Click 'Distribute App'"
echo "   - Choose 'App Store Connect'"
echo "   - Choose 'Upload'"
echo "   - Follow prompts"
echo ""
echo "5. Complete App Store Connect listing:"
echo "   - Add screenshots"
echo "   - Fill in app description"
echo "   - Set pricing (Free)"
echo "   - Complete age rating"
echo ""
echo "6. Submit for review"
echo ""
echo "📖 Full guide: docs/APP_STORE_SUBMISSION.md"
echo ""
