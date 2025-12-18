#!/bin/bash
# CHI-LMS Build Script with Branding Fixes
# Version 1.0.1

cd /Users/Abubakar/STECH/moodleapp

echo "========================================="
echo "CHI-LMS Build Script v1.0.1"
echo "========================================="
echo ""

# Step 1: Clean platforms
echo "🧹 Cleaning old platforms..."
rm -rf platforms plugins www

# Step 2: Ensure proper splash screen is set
echo "🎨 Verifying branding resources..."
cp CHI_logo.png resources/splash.png
cp CHI_logo.png resources/icon.png

# Step 3: Create minimal www folder
echo "📁 Creating www folder..."
mkdir -p www
cat > www/index.html << 'EOF'
<!DOCTYPE html>
<html><head><title>CHI-LMS</title></head><body>Loading CHI-LMS...</body></html>
EOF

# Step 4: Try adding Android platform
echo "📱 Adding Android platform..."
if ! cordova platform add android@14.0.1; then
    echo "⚠️  Platform add failed. Trying alternative method..."
   
    # Alternative: Restore from previous successful build if available
    if [ -d "../moodleapp-backup/platforms/android" ]; then
        echo "📦 Restoring from backup..."
        mkdir -p platforms
        cp -r ../moodleapp-backup/platforms/android platforms/
    else
        echo "❌ Cannot add Android platform. Manual intervention needed."
        echo ""
        echo "MANUAL FIX REQUIRED:"
        echo "1. Install cordova-android manually: npm install cordova-android@14.0.1"
        echo "2. Or restore platforms/android from a backup"
        echo "3. Then run: cordova prepare android"
        exit 1
    fi
fi

# Step 5: Prepare/update platform
echo "⚙️  Preparing Android platform..."
cordova prepare android

# Step 6: Build APK
echo "🔨 Building debug APK..."
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
    echo "📱 Test this APK on your device"
    echo "✓ Check splash screen shows CHI logo"
    echo "✓ Check app icon is correct"
    echo "✓ Verify all branding is correct"
    echo ""
    echo "After testing, run: ./BUILD-AAB-v1.0.1.sh"
else
    echo "❌ Build failed. Check error messages above."
    exit 1
fi
