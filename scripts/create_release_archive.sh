#!/bin/bash

# HEXPal Release Archive Creation Script
# This script helps create a release archive and attach it to GitHub release

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}HEXPal Release Archive Creation${NC}"
echo "=================================="
echo ""

# Check if we're in the right directory
if [ ! -f "HexPal.xcodeproj/project.pbxproj" ]; then
    echo -e "${RED}Error: Must run from HEXPal project root directory${NC}"
    exit 1
fi

# Check for required tools
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is required but not installed${NC}"
    echo "Install with: brew install gh"
    exit 1
fi

# Configuration
SCHEME="HexPal"
ARCHIVE_NAME="HexPal.xcarchive"
ARCHIVE_PATH="./build/${ARCHIVE_NAME}"
APP_NAME="HexPal.app"
ZIP_NAME="HexPal-v1.0.zip"
RELEASE_TAG="v1.0"

echo "Configuration:"
echo "  Scheme: ${SCHEME}"
echo "  Archive: ${ARCHIVE_PATH}"
echo "  Release Tag: ${RELEASE_TAG}"
echo ""

# Step 1: Create build directory
echo -e "${YELLOW}Step 1: Preparing build directory...${NC}"
mkdir -p build
echo "✓ Build directory ready"
echo ""

# Step 2: Create archive using xcodebuild
echo -e "${YELLOW}Step 2: Creating Xcode archive...${NC}"
echo "This may take a few minutes..."
echo ""

xcodebuild archive \
    -project HexPal.xcodeproj \
    -scheme "${SCHEME}" \
    -configuration Release \
    -archivePath "${ARCHIVE_PATH}" \
    -derivedDataPath ./build/DerivedData \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Archive creation failed${NC}"
    exit 1
fi

echo "✓ Archive created successfully"
echo ""

# Step 3: Export app from archive
echo -e "${YELLOW}Step 3: Exporting app from archive...${NC}"
APP_PATH="${ARCHIVE_PATH}/Products/Applications/${APP_NAME}"

if [ ! -d "${APP_PATH}" ]; then
    echo -e "${RED}Error: App bundle not found at ${APP_PATH}${NC}"
    exit 1
fi

echo "✓ App bundle found"
echo ""

# Step 4: Create ZIP archive
echo -e "${YELLOW}Step 4: Creating ZIP archive...${NC}"
cd build
zip -r "${ZIP_NAME}" "${ARCHIVE_NAME}/Products/Applications/${APP_NAME}" > /dev/null
cd ..

ZIP_PATH="./build/${ZIP_NAME}"

if [ ! -f "${ZIP_PATH}" ]; then
    echo -e "${RED}Error: ZIP creation failed${NC}"
    exit 1
fi

ZIP_SIZE=$(du -h "${ZIP_PATH}" | cut -f1)
echo "✓ ZIP archive created: ${ZIP_NAME} (${ZIP_SIZE})"
echo ""

# Step 5: Generate checksums
echo -e "${YELLOW}Step 5: Generating checksums...${NC}"
CHECKSUM_SHA256=$(shasum -a 256 "${ZIP_PATH}" | cut -d' ' -f1)
CHECKSUM_MD5=$(md5 -q "${ZIP_PATH}")

echo "SHA256: ${CHECKSUM_SHA256}"
echo "MD5:    ${CHECKSUM_MD5}"
echo ""

# Save checksums to file
CHECKSUM_FILE="./build/checksums.txt"
cat > "${CHECKSUM_FILE}" << EOF
HEXPal v1.0 Checksums
=====================

File: ${ZIP_NAME}
Size: ${ZIP_SIZE}

SHA256: ${CHECKSUM_SHA256}
MD5:    ${CHECKSUM_MD5}

To verify:
  shasum -a 256 -c checksums.txt
  md5 -c checksums.txt
EOF

echo "✓ Checksums saved to ${CHECKSUM_FILE}"
echo ""

# Step 6: Upload to GitHub release
echo -e "${YELLOW}Step 6: Uploading to GitHub release...${NC}"
echo "Release tag: ${RELEASE_TAG}"
echo "File: ${ZIP_NAME}"
echo ""

read -p "Upload to GitHub release? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh release upload "${RELEASE_TAG}" "${ZIP_PATH}" --clobber
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Successfully uploaded to GitHub release${NC}"
        
        # Also upload checksums
        gh release upload "${RELEASE_TAG}" "${CHECKSUM_FILE}" --clobber
        echo -e "${GREEN}✓ Checksums uploaded${NC}"
    else
        echo -e "${RED}Error: Upload failed${NC}"
        exit 1
    fi
else
    echo "Skipping upload. You can upload manually later with:"
    echo "  gh release upload ${RELEASE_TAG} ${ZIP_PATH}"
fi

echo ""
echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}Release archive creation complete!${NC}"
echo ""
echo "Files created:"
echo "  Archive: ${ARCHIVE_PATH}"
echo "  ZIP:     ${ZIP_PATH}"
echo "  Checksums: ${CHECKSUM_FILE}"
echo ""
echo "Next steps:"
echo "  1. Test the app from the archive"
echo "  2. Verify the GitHub release has the files"
echo "  3. Update RELEASE_NOTES.md with release date"
