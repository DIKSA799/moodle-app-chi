# CHI-LMS Android App Bundle (AAB) Build Instructions

## App Configuration Summary

### ✅ Completed Changes

The app has been reconfigured with the following details:

- **App ID**: `ng.edu.chi.lms` (changed from `com.moodle.moodlemobile`)
- **App Name**: `CHI-LMS`
- **Version**: `1.0.0`
- **Version Code**: `10000`
- **Author**: CHI LMS Team (support@chi.edu.ng)
- **Site URL**: https://lms.chi.edu.ng/public

### Release Credentials

**Keystore Information:**
- **File**: `chi-lms-release.keystore`
- **Store Password**: `CHI-LMS2024!`
- **Key Alias**: `chi-lms-key`
- **Key Password**: `CHI-LMS2024!`
- **Keystore Type**: JKS

**⚠️ SECURITY**: Keep these credentials secure. Do not commit `build.json` to public repositories.

### SDK Requirements (Google Play Compliance)

The app is configured to meet the latest Google Play requirements:
- **Target SDK**: 36 (Android 15) - As required by Google Play (Nov 2024+)
- **Min SDK**: 24 (Android 7.0)
- **Compile SDK**: Matches target SDK
- **AndroidX**: Enabled
- **Kotlin**: 1.9.24
- **Gradle Plugin**: Latest compatible version

##  Build Methods

### Method 1: Using the Build Script (Recommended)

```bash
cd /Users/Abubakar/STECH/moodleapp
./BUILD-AAB-RELEASE.sh
```

This script will:
1. Check prerequisites
2. Build production web assets
3. Prepare Android platform
4. Build signed AAB with release keystore
5. Copy AAB to `CHI-LMS-release.aab`

### Method 2: Manual Build Commands

```bash
cd /Users/Abubakar/STECH/moodleapp

# 1. Build production web assets
npm run build:prod

# 2. Prepare Android platform
npx cordova prepare android

# 3. Build release AAB
npx cordova build android --release --buildConfig=build.json -- --packageType=bundle

# 4. Find AAB at:
# platforms/android/app/build/outputs/bundle/release/app-release.aab
```

### Method 3: Using Ionic CLI

```bash
cd /Users/Abubakar/STECH/moodleapp

# Build with Ionic CLI
NODE_ENV=production ionic cordova build android --release --prod --buildConfig=build.json -- --packageType=bundle
```

### Method 4: Direct Gradle Build

If Cordova has issues, you can build directly with Gradle after preparing:

```bash
cd /Users/Abubakar/STECH/moodleapp

# 1. Prepare
npm run build:prod
npx cordova prepare android

# 2. Build with Gradle directly
cd platforms/android
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
./gradlew bundleRelease

# AAB will be at: app/build/outputs/bundle/release/app-release.aab
```

## Prerequisites

### 1. Java Development Kit (JDK)
- **Required**: JDK 17
- **Check**: `java -version`
- **Install**: Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or use Homebrew:
  ```bash
  brew install openjdk@17
  ```

### 2. Android SDK
- **Required**: Android SDK with Build Tools 34+
- **Set environment variables**:
  ```bash
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
  ```

### 3. Node.js
- **Required**: Node.js v22.17+ (as specified in package.json)
- **Check**: `node --version`
- **Current**: v22.17.1 ✓

### 4. Cordova & Dependencies
- Already installed via npm packages
- **Cordova**: 12.0.0
- **Cordova-Android**: 14.0.1

## Troubleshooting

### Issue: "Android platform not found"

```bash
# Remove and re-add platform
npx cordova platform rm android
npx cordova platform add android@14.0.1
```

### Issue: "cordova-android not found"

```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

### Issue: "Keystore password incorrect"

The new keystore has been created with the documented password. If you have issues:

```bash
# Verify keystore
keytool -list -v -keystore chi-lms-release.keystore -storepass CHI-LMS2024!

# Regenerate if needed (CAUTION: Will create new signing key)
keytool -genkey -v -keystore chi-lms-release.keystore \\
  -alias chi-lms-key -keyalg RSA -keysize 2048 -validity 10000 \\
  -storepass CHI-LMS2024! -keypass CHI-LMS2024! \\
  -dname "CN=CHI LMS, OU=Education, O=CHI, L=Lagos, ST=Lagos, C=NG"
```

### Issue: "Build fails with Gradle error"

```bash
# Clean and rebuild
npx cordova clean android
rm -rf platforms/android/app/build
# Then rebuild
```

### Issue: "Out of memory during build"

```bash
# Increase Node.js memory
export NODE_OPTIONS=--max-old-space-size=8192
npm run build:prod
```

## Uploading to Google Play

### 1. Verify AAB

```bash
# Check AAB size
ls -lh CHI-LMS-release.aab

# Verify signing
jarsigner -verify -verbose -certs CHI-LMS-release.aab
```

### 2. Google Play Console Steps

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app with details:
   - **App Name**: CHI-LMS
   - **Package Name**: `ng.edu.chi.lms`
   - **Category**: Education
3. Upload AAB to Internal Testing track first
4. Complete store listing:
   - Description
   - Screenshots (required: phone, tablet, feature graphic)
   - Icon (512x512px)
5. Content rating questionnaire
6. Privacy policy URL
7. Submit for review

### 3. Required Assets for Play Store

Create these assets for submission:
- **App Icon**: 512x512px PNG
- **Feature Graphic**: 1024x500px PNG
- **Phone Screenshots**: At least 2, max 8 (JPEG or 24-bit PNG, no alpha)
- **7" Tablet Screenshots**: At least 2 (optional but recommended)
- **10" Tablet Screenshots**: At least 2 (optional but recommended)

## Version Management

For future releases, update version in:
1. **moodle.config.json**: `versioncode` and `versionname`
2. **config.xml**: `android-versionCode` and `version`
3. Rebuild AAB with new version

Example for version 1.0.1:
```json
// moodle.config.json
"versioncode": 10001,
"versionname": "1.0.1",
```

```xml
<!-- config.xml -->
<widget android-versionCode="10001" version="1.0.1" ...>
```

## Files Modified

- ✅ `moodle.config.json` - App ID, version, app name
- ✅ `config.xml` - Widget ID, version, author info
- ✅ `build.json` - Release signing configuration (CREATED)
- ✅ `chi-lms-release.keystore` - New keystore with documented credentials (CREATED)
- ✅ `RELEASE-CREDENTIALS.txt` - Credentials documentation (CREATED)
- ✅ `BUILD-AAB-RELEASE.sh` - Automated build script (CREATED)

## Important Notes

1. **App ID Change**: The app ID has been changed from `com.moodle.moodlemobile` to `ng.edu.chi.lms`. This is a completely new app package and cannot be used to update an existing app with the old package name.

2. **Keystore Security**: The keystore file and passwords must be kept secure. Losing them means you cannot update your app on Google Play.

3. **First Release**: This is version 1.0.0 (10000), suitable for initial Play Store release.

4. **Target SDK Compliance**: Configured for Android 15 (API 36) which meets Google Play's requirements as of November 2024.

5. **Domain**: Using `chi.edu.ng` domain which is appropriate for an educational institution in Nigeria.

## Support

For build issues, check:
- Build logs in the terminal
- Gradle logs in `platforms/android/app/build/`
- Cordova documentation: https://cordova.apache.org/docs/en/latest/

---
**Last Updated**: December 2025
**Moodle App Base Version**: 5.1.0
**CHI-LMS Version**: 1.0.0
