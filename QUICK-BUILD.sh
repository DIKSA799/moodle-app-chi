#!/bin/bash
cd /Users/Abubakar/STECH/moodleapp
echo "Building CHI-LMS..."
npm run build:prod && \
npx cordova prepare android && \
cd platforms/android && \
JAVA_HOME=$(/usr/libexec/java_home -v 17) \
ANDROID_HOME=/Users/Abubakar/Library/Android/sdk \
ANDROID_SDK_ROOT=/Users/Abubakar/Library/Android/sdk \
./gradle-8.11.1/bin/gradle assembleDebug && \
cd ../.. && \
cp -f platforms/android/app/build/outputs/apk/debug/app-debug.apk CHI-LMS-debug.apk && \
echo "✅ Build complete! APK: CHI-LMS-debug.apk"
