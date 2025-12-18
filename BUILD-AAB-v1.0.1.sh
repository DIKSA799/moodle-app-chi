#!/bin/bash
# CHI-LMS AAB Build Script
# Version 1.0.1 (for Play Store update)

cd /Users/Abubakar/STECH/moodleapp

echo "========================================="
echo "CHI-LMS AAB Build v1.0.1"
echo "========================================="
echo ""

# Verify version
echo "📋 Build Information:"
echo "   Version: 1.0.1"
echo "   Version Code: 10001"
echo "   Package: ng.edu.chi.lms"
echo ""

# Build release AAB
echo "🔨 Building release AAB..."
export PATH="$PWD/gradle-8.11.1/bin:$PATH"

cd platforms/android
JAVA_HOME=$(/usr/libexec/java_home -v 17) \
ANDROID_HOME=/Users/Abubakar/Library/Android/sdk \
ANDROID_SDK_ROOT=/Users/Abubakar/Library/Android/sdk \
../../gradle-8.11.1/bin/gradle bundleRelease \
  -Pandroid.injected.signing.store.file=/Users/Abubakar/STECH/moodleapp/chi-lms-release.keystore \
  -Pandroid.injected.signing.store.password="CHI-LMS2024!" \
  -Pandroid.injected.signing.key.alias=chi-lms-key \
  -Pandroid.injected.signing.key.password="CHI-LMS2024!"

if [ $? -eq 0 ]; then
    cd ../..
    cp -f platforms/android/app/build/outputs/bundle/release/app-release.aab CHI-LMS-release-v1.0.1.aab
    echo ""
    echo "========================================="
    echo "✅ AAB BUILD SUCCESSFUL!"
    echo "========================================="
    echo ""
    echo "📦 AAB File:"
    ls -lh CHI-LMS-release-v1.0.1.aab
    echo ""
    echo "🎯 NEXT STEPS:"
    echo ""
    echo "1. Upload to Google Play Console:"
    echo "   https://play.google.com/console"
    echo ""
    echo "2. Create new release (v1.0.1):"
    echo "   • Go to: Release → Production → Create new release"
    echo "   • Upload: CHI-LMS-release-v1.0.1.aab"
    echo ""
    echo "3. Update release notes:"
    echo "   • Fixed branding and splash screen"
    echo "   • Updated app icon"
    echo "   • Bug fixes and improvements"
    echo ""
    echo "4. Submit for review"
    echo ""
    echo "========================================="
else
    echo "❌ Build failed. Check error messages above."
    exit 1
fi
