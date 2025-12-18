#!/bin/bash
# CHI-LMS Complete Build Script
# Builds Angular app first, then creates APK with proper branding

cd /Users/Abubakar/STECH/moodleapp

echo "========================================="
echo "CHI-LMS Complete Build Script v1.0.1"
echo "========================================="
echo ""

# Step 1: Update all branding resources
echo "🎨 Updating all branding resources..."
cp CHI_logo.png resources/icon.png
cp CHI_logo.png resources/splash.png
cp CHI_logo.png resources/android/icon-foreground.png
for f in resources/android/icon/*.png; do
    cp CHI_logo.png "$f"
done

# Update app asset logos
cp CHI_logo.png src/assets/img/login_logo.png
cp CHI_logo.png src/assets/img/top_logo.png
cp CHI_logo.png src/assets/icon/icon.png
cp CHI_logo.png src/assets/icon/favicon.png

echo "✓ All icon and logo files updated with CHI logo"
echo ""

# Step 2: Build the complete Cordova app
echo "🏗️  Building Cordova Android app..."
echo "This may take several minutes..."
NODE_OPTIONS=--max-old-space-size=8192 NODE_ENV=production ionic cordova build android --prod

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Check errors above."
    exit 1
fi

echo "✓ Cordova build completed"
echo ""

# The ionic cordova build command already creates the APK
# Just need to copy and customize it
echo "🔨 Building custom signed APK..."
cd platforms/android
JAVA_HOME=$(/usr/libexec/java_home -v 17) \
ANDROID_HOME=/Users/Abubakar/Library/Android/sdk \
ANDROID_SDK_ROOT=/Users/Abubakar/Library/Android/sdk \
../../gradle-8.11.1/bin/gradle assembleDebug

if [ $? -eq 0 ]; then
    cd ../..
    cp -f platforms/android/app/build/outputs/apk/debug/app-debug.apk CHI-LMS-debug-v1.0.1.apk
    echo ""
    echo "========================================="
    echo "✅ BUILD SUCCESSFUL!"
    echo "========================================="
    echo "APK: CHI-LMS-debug-v1.0.1.apk"
    ls -lh CHI-LMS-debug-v1.0.1.apk
    echo ""
    echo "📱 Install and test this APK:"
    echo "   adb install -r CHI-LMS-debug-v1.0.1.apk"
    echo ""
    echo "✓ Check that app opens (no white screen)"
    echo "✓ Check app icon shows CHI logo"
    echo "✓ Check splash screen shows CHI logo"
    echo ""
    echo "After testing, run: ./BUILD-AAB-v1.0.1.sh for release build"
else
    echo "❌ APK build failed. Check error messages above."
    exit 1
fi
