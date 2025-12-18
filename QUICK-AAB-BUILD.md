# Quick AAB Build Guide - CHI-LMS

## ✅ What's Been Configured

Your app has been successfully reconfigured for release:

### App Identity
- **Package Name**: `ng.edu.chi.lms` (was `com.moodle.moodlemobile`)
- **App Name**: CHI-LMS
- **Version**: 1.0.0 (build 10000)
- **Domain**: chi.edu.ng

### Release Signing
- **Keystore**: `chi-lms-release.keystore` ✅ Created
- **Password**: `CHI-LMS2024!`
- **Alias**: `chi-lms-key`

### Files Updated
- ✅ `moodle.config.json` - App ID and version
- ✅ `config.xml` - Package ID and metadata
- ✅ `build.json` - Signing configuration
- ✅ `RELEASE-CREDENTIALS.txt` - Full credentials documentation

## 🚀 Quick Build (2 Commands)

```bash
# 1. Build production assets
npm run build:prod

# 2. Build release AAB
npx cordova build android --release --buildConfig=build.json -- --packageType=bundle
```

The AAB will be at: `platforms/android/app/build/outputs/bundle/release/app-release.aab`

## 🔧 If Android Platform Missing

If you get "Android platform not found":

```bash
# Install Ionic CLI globally (one-time)
npm install -g @ionic/cli

# Add Android platform
ionic cordova platform add android

# Then build
npm run build:prod
ionic cordova build android --release --prod --buildConfig=build.json -- --packageType=bundle
```

## 📋 Prerequisites Checklist

Before building, ensure you have:

- [ ] **Java 17** installed
  ```bash
  java -version  # Should show 17.x
  ```

- [ ] **Android SDK** installed
  ```bash
  # Set these in ~/.zshrc or ~/.bash_profile
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
  ```

- [ ] **Node.js v22.17+**
  ```bash
  node --version  # Currently v22.17.1 ✓
  ```

## 🎯 Complete Build Process

```bash
cd /Users/Abubakar/STECH/moodleapp

# Step 1: Clean (optional but recommended)
rm -rf www/ platforms/android/app/build/

# Step 2: Build web assets
npm run build:prod

# Step 3: Prepare Android (if needed)
npx cordova prepare android

# Step 4: Build AAB
npx cordova build android --release --buildConfig=build.json -- --packageType=bundle

# Step 5: Copy to root for easy access
cp platforms/android/app/build/outputs/bundle/release/app-release.aab CHI-LMS-release-v1.0.0.aab

# Step 6: Verify
ls -lh CHI-LMS-release-v1.0.0.aab
```

## 🐛 Common Issues & Fixes

### Issue: "Android platform not found"
```bash
npx cordova platform add android@14.0.1
```

### Issue: "cordova: command not found"
```bash
# Use npx
npx cordova --version
```

### Issue: "Build fails immediately"
```bash
# Clean and retry
npx cordova clean android
rm -rf platforms/android/app/build
# Then rebuild
```

### Issue: "Out of memory"
```bash
export NODE_OPTIONS=--max-old-space-size=8192
npm run build:prod
```

### Issue: "Keystore password incorrect"
Your keystore password is: `CHI-LMS2024!`
Verify with:
```bash
keytool -list -keystore chi-lms-release.keystore -storepass CHI-LMS2024!
```

## 📤 Uploading to Google Play

1. **File to upload**: `CHI-LMS-release-v1.0.0.aab`

2. **First time setup**:
   - Go to: https://play.google.com/console
   - Create new app
   - Package name: `ng.edu.chi.lms`

3. **Required info**:
   - App category: Education
   - Privacy policy URL
   - Screenshots (min 2 phone screenshots)
   - App icon (512x512px)
   - Feature graphic (1024x500px)

4. **Upload process**:
   - Internal testing track (recommended for first upload)
   - Then production when ready

## 📱 Testing the AAB

Before uploading, you can test using bundletool:

```bash
# Install bundletool (one-time)
brew install bundletool

# Generate APKs from AAB for testing
bundletool build-apks --bundle=CHI-LMS-release-v1.0.0.aab \\
  --output=CHI-LMS-test.apks \\
  --ks=chi-lms-release.keystore \\
  --ks-pass=pass:CHI-LMS2024! \\
  --ks-key-alias=chi-lms-key \\
  --key-pass=pass:CHI-LMS2024!

# Install on connected device
bundletool install-apks --apks=CHI-LMS-test.apks
```

## 🔄 For Future Updates

To release version 1.0.1:

1. Update version in `moodle.config.json`:
```json
"versioncode": 10001,
"versionname": "1.0.1",
```

2. Update in `config.xml`:
```xml
<widget android-versionCode="10001" version="1.0.1" ...>
```

3. Rebuild:
```bash
npm run build:prod
npx cordova build android --release --buildConfig=build.json -- --packageType=bundle
```

## ⚠️ Important Notes

1. **Keystore Backup**: Back up `chi-lms-release.keystore` - you cannot update your app without it!

2. **New Package Name**: This is a NEW app (`ng.edu.chi.lms`), not an update to any existing app.

3. **Credentials Security**: Keep `build.json` and `RELEASE-CREDENTIALS.txt` secure. Don't commit to public repos.

4. **First Upload**: Google Play review typically takes 1-3 days for first app submission.

## 📞 Need Help?

See full documentation in:
- `AAB-BUILD-INSTRUCTIONS.md` - Complete guide
- `RELEASE-CREDENTIALS.txt` - All credentials and keystore info
- `BUILD-AAB-RELEASE.sh` - Automated build script

---

**Quick Summary**: The app is configured and ready. Just run `npm run build:prod` then build the AAB. Upload to Google Play Console!
