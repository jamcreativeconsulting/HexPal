#!/bin/bash

# Quick Archive Script for HEXPal
# Simpler version that just creates the archive

set -e

echo "🚀 HEXPal Quick Archive Creation"
echo ""

# Create build directory
mkdir -p build

# Build and archive
echo "📦 Creating archive (this may take a few minutes)..."
xcodebuild archive \
    -project HexPal.xcodeproj \
    -scheme HexPal \
    -configuration Release \
    -archivePath ./build/HexPal.xcarchive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

# Find the app bundle
APP_PATH="./build/HexPal.xcarchive/Products/Applications/HexPal.app"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: App bundle not found"
    exit 1
fi

# Create ZIP
echo "📦 Creating ZIP archive..."
cd build/HexPal.xcarchive/Products/Applications
zip -r ../../../HexPal-v1.0.zip HexPal.app > /dev/null
cd ../../../..

ZIP_PATH="./build/HexPal-v1.0.zip"

if [ ! -f "$ZIP_PATH" ]; then
    echo "❌ Error: ZIP creation failed"
    exit 1
fi

# Get size
ZIP_SIZE=$(du -h "$ZIP_PATH" | cut -f1)

# Generate checksums
echo "🔐 Generating checksums..."
SHA256=$(shasum -a 256 "$ZIP_PATH" | cut -d' ' -f1)
MD5=$(md5 -q "$ZIP_PATH")

# Save checksums
cat > ./build/checksums.txt << EOF
HEXPal v1.0 Checksums
=====================

File: HexPal-v1.0.zip
Size: ${ZIP_SIZE}

SHA256: ${SHA256}
MD5:    ${MD5}

To verify:
  shasum -a 256 HexPal-v1.0.zip
  md5 HexPal-v1.0.zip
EOF

echo ""
echo "✅ Archive created successfully!"
echo ""
echo "Files:"
echo "  📦 ZIP:     $ZIP_PATH ($ZIP_SIZE)"
echo "  🔐 Checksums: ./build/checksums.txt"
echo ""
echo "SHA256: ${SHA256}"
echo "MD5:    ${MD5}"
echo ""
echo "To upload to GitHub release:"
echo "  gh release upload v1.0 $ZIP_PATH"
echo "  gh release upload v1.0 ./build/checksums.txt"
