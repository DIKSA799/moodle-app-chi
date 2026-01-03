#!/bin/bash

# CHI-LMS Optimized APK Build Script
# This script builds an optimized APK with maximum Android compatibility

echo "========================================="
echo "CHI-LMS Optimized APK Build"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Set Java and Android environment variables
export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null) || export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$JAVA_HOME/bin:$PATH"

# Change to project directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${YELLOW}Environment:${NC}"
echo "Java: $(java -version 2>&1 | head -n 1)"
echo "Android SDK: $ANDROID_SDK_ROOT"
echo ""

echo -e "${YELLOW}Step 1: Preparing Cordova platform...${NC}"
npx cordova prepare android

echo -e "${YELLOW}Step 2: Building APK with Gradle...${NC}"
cd "$SCRIPT_DIR/platforms/android"

# Make gradlew executable
chmod +x gradlew

# Run gradle build
./gradlew assembleRelease \
    -PcdvBuildMultipleApks=false \
    -Dorg.gradle.jvmargs="-Xmx4096m" \
    -Dorg.gradle.parallel=true

BUILD_RESULT=$?

cd "$SCRIPT_DIR"

# Check for APK in multiple locations
APK_PATHS=(
    "platforms/android/app/build/outputs/apk/release/app-release.apk"
    "platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
)

APK_FOUND=""
for path in "${APK_PATHS[@]}"; do
    if [ -f "$path" ]; then
        APK_FOUND="$path"
        break
    fi
done

if [ $BUILD_RESULT -eq 0 ] && [ -n "$APK_FOUND" ]; then
    echo ""
    echo -e "${GREEN}✓ APK built successfully!${NC}"
    echo ""
    echo "APK Location: $APK_FOUND"

    # Copy to root directory with version name
    cp "$APK_FOUND" "CHI-LMS-optimized-v1.0.1.apk"
    echo -e "${GREEN}✓ APK copied to: CHI-LMS-optimized-v1.0.1.apk${NC}"

    # Show APK info
    echo ""
    echo "APK Size: $(ls -lh CHI-LMS-optimized-v1.0.1.apk | awk '{print $5}')"

    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}Build Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Configuration:"
    echo "- Min SDK: 24 (Android 7.0+)"
    echo "- Target SDK: 34 (Android 14)"
    echo "- Compile SDK: 34"
    echo ""
    echo "This APK should work on:"
    echo "✓ Android 7.0 - Android 15+"
    echo "✓ Optimized for Android 10-14 devices"
    echo ""
else
    echo -e "${RED}✗ Build failed or APK not found.${NC}"
    if [ -d "platforms/android/app/build/outputs" ]; then
        echo "Checking build outputs..."
        find platforms/android/app/build/outputs -name "*.apk" 2>/dev/null
    fi
    exit 1
fi
