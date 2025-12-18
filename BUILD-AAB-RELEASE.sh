#!/bin/bash
# CHI-LMS Android App Bundle (AAB) Release Build Script
# This script builds a production-ready AAB file for Google Play Store

set -e  # Exit on error

echo "==================================="
echo "CHI-LMS AAB Release Builder"
echo "==================================="
echo ""

# Configuration
APP_DIR="/Users/Abubakar/STECH/moodleapp"
KEYSTORE_FILE="chi-lms-release.keystore"
BUILD_CONFIG="build.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cd "$APP_DIR"

# Check prerequisites
echo "Checking prerequisites..."

if [ ! -f "$KEYSTORE_FILE" ]; then
    echo -e "${RED}Error: Keystore file not found: $KEYSTORE_FILE${NC}"
    exit 1
fi

if [ ! -f "$BUILD_CONFIG" ]; then
    echo -e "${RED}Error: Build config file not found: $BUILD_CONFIG${NC}"
    exit 1
fi

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}Error: Java not found. Please install Java 17.${NC}"
    exit 1
fi

# Check Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo -e "${YELLOW}Warning: ANDROID_HOME not set. Attempting to set...${NC}"
    export ANDROID_HOME="/Users/Abubakar/Library/Android/sdk"
    export ANDROID_SDK_ROOT="/Users/Abubakar/Library/Android/sdk"
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js not found.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites check passed${NC}"
echo ""

# Step 1: Clean previous builds
echo "Step 1: Cleaning previous builds..."
rm -rf www/ 2>/dev/null || true
rm -rf platforms/android/app/build/outputs/ 2>/dev/null || true
echo -e "${GREEN}✓ Clean complete${NC}"
echo ""

# Step 2: Install dependencies (if needed)
echo "Step 2: Checking dependencies..."
if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install --legacy-peer-deps
fi
echo -e "${GREEN}✓ Dependencies ready${NC}"
echo ""

# Step 3: Build production web assets
echo "Step 3: Building production web assets..."
NODE_OPTIONS=--max-old-space-size=8192 NODE_ENV=production npm run build:prod
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Production build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Web assets built${NC}"
echo ""

# Step 4: Prepare Android platform
echo "Step 4: Preparing Android platform..."
if [ ! -d "platforms/android" ]; then
    echo "Android platform not found. Adding..."
    npx cordova platform add android@14.0.1
fi

# Prepare the platform with updated config
npx cordova prepare android
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: cordova prepare failed${NC}"
    echo -e "${YELLOW}Tip: Try running: npx cordova platform rm android && npx cordova platform add android${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Android platform prepared${NC}"
echo ""

# Step 5: Build release AAB
echo "Step 5: Building release AAB..."
echo "This may take a few minutes..."
echo ""

# Set Java home to Java 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home)

# Build the AAB
npx cordova build android --release --buildConfig="$BUILD_CONFIG" -- --packageType=bundle

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: AAB build failed${NC}"
    echo ""
    echo "Troubleshooting tips:"
    echo "1. Ensure Android SDK is properly installed"
    echo "2. Check that ANDROID_HOME is set correctly"
    echo "3. Verify Java 17 is installed"
    echo "4. Try: npx cordova clean android"
    exit 1
fi

# Step 6: Copy AAB to root directory
AAB_SOURCE="platforms/android/app/build/outputs/bundle/release/app-release.aab"
AAB_DEST="CHI-LMS-release.aab"

if [ -f "$AAB_SOURCE" ]; then
    cp -f "$AAB_SOURCE" "$AAB_DEST"
    echo ""
    echo -e "${GREEN}✅ SUCCESS! AAB built successfully!${NC}"
    echo ""
    echo "==================================="
    echo "Build Information:"
    echo "==================================="
    echo "App Name:       CHI-LMS"
    echo "App ID:         ng.edu.chi.lms"
    echo "Version:        1.0.0 (10000)"
    echo "AAB File:       $AAB_DEST"
    echo "File Size:      $(ls -lh "$AAB_DEST" | awk '{print $5}')"
    echo ""
    echo "Keystore:       $KEYSTORE_FILE"
    echo "Credentials:    See RELEASE-CREDENTIALS.txt"
    echo ""
    echo "Next steps:"
    echo "1. Upload $AAB_DEST to Google Play Console"
    echo "2. Fill in store listing details"
    echo "3. Complete content rating questionnaire"
    echo "4. Set up pricing & distribution"
    echo "5. Submit for review"
    echo ""
    echo "==================================="
else
    echo -e "${RED}Error: AAB file not found at expected location${NC}"
    echo "Expected: $AAB_SOURCE"
    exit 1
fi
