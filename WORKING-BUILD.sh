#!/bin/bash
# Working CHI-LMS Build Script
# Based on what created the working CHI-LMS-debug.apk

cd /Users/Abubakar/STECH/moodleapp

echo "========================================="
echo "CHI-LMS Working Build Script"
echo "========================================="
echo ""

# Step 1: Update branding
echo "🎨 Applying CHI branding..."
cp CHI_logo.png resources/icon.png
cp CHI_logo.png resources/splash.png
cp CHI_logo.png resources/android/icon-foreground.png
for f in resources/android/icon/*.png; do
    cp CHI_logo.png "$f"
done
cp CHI_logo.png src/assets/img/login_logo.png
cp CHI_logo.png src/assets/img/top_logo.png
cp CHI_logo.png src/assets/icon/icon.png
cp CHI_logo.png src/assets/icon/favicon.png
echo "✓ Branding applied"
echo ""

# Step 2: Build with ionic cordova (which properly integrates cordova.js)
echo "🏗️  Building app..."
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export ANDROID_HOME=/Users/Abubakar/Library/Android/sdk
export ANDROID_SDK_ROOT=/Users/Abubakar/Library/Android/sdk  
export PATH="$PWD/gradle-8.11.1/bin:$PATH"

# Use ionic cordova prepare which adds cordova.js properly
NODE_OPTIONS=--max-old-space-size=8192 NODE_ENV=production npm run build:prod

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✓ Angular build complete"
echo ""

# Step 3: Prepare Cordova (this adds cordova.js)
echo "⚙️  Preparing Cordova..."
ionic cordova prepare android --no-build

if [ $? -ne 0 ]; then
    echo "❌ Cordova prepare failed"
    exit 1
fi

echo "✓ Cordova prepared (cordova.js added)"
echo ""

# Step 4: Build APK
echo "🔨 Building APK..."
cd platforms/android
../../gradle-8.11.1/bin/gradle assembleDebug

if [ $? -eq 0 ]; then
    cd ../..
    cp -f platforms/android/app/build/outputs/apk/debug/app-debug.apk CHI-LMS-debug-v1.0.1.apk
    echo ""
    echo "========================================="
    echo "✅ BUILD SUCCESSFUL!"
    echo "========================================="
    ls -lh CHI-LMS-debug-v1.0.1.apk
    echo ""
    echo "📱 Test: adb install -r CHI-LMS-debug-v1.0.1.apk"
else
    echo "❌ Build failed"
    exit 1
fi
