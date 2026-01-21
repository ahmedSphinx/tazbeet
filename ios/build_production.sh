#!/bin/bash

# Production Build Script for Tazbeet iOS App
# This script creates a production-ready build for App Store submission

echo "=== Tazbeet iOS Production Build ==="
echo ""

# Configuration
PROJECT_NAME="Runner"
SCHEME="Runner"
WORKSPACE="Runner.xcworkspace"
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/Runner.xcarchive"
EXPORT_PATH="$BUILD_DIR/Export"

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "Building production archive..."
echo ""

# Build archive for App Store
xcodebuild -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath "$ARCHIVE_PATH" \
  clean archive

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Archive created successfully!"
    echo "Archive location: $ARCHIVE_PATH"
    echo ""
    
    # Export for App Store
    echo "Exporting for App Store..."
    xcodebuild -exportArchive \
      -archivePath "$ARCHIVE_PATH" \
      -exportPath "$EXPORT_PATH" \
      -exportOptionsPlist ExportOptions.plist
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Production build completed successfully!"
        echo "Export location: $EXPORT_PATH"
        echo ""
        echo "Files ready for App Store Connect:"
        echo "  - $EXPORT_PATH/Runner.ipa"
        echo ""
        echo "Next steps:"
        echo "1. Upload Runner.ipa to App Store Connect"
        echo "2. Complete App Store Connect metadata"
        echo "3. Submit for review"
    else
        echo "❌ Export failed"
        exit 1
    fi
else
    echo "❌ Archive build failed"
    exit 1
fi
