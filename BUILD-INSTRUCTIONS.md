# CHI-LMS Build Instructions

## Overview
This is the customized Moodle mobile app for **Community Health Institute LMS**.

### Customizations Applied:
- **App Name**: CHI-LMS (Community Health Institute LMS)
- **Package ID**: com.moodle.moodlemobile
- **Brand Color**: Green (#28a745)
- **Default Site**: https://lms.chi.edu.ng (pre-configured, users go directly to site)
- **Theme**: Green status bar, green notifications, green primary color

---

## Prerequisites

### Required Software:
1. **Node.js** (v16 or higher)
2. **npm** (comes with Node.js)
3. **Java JDK 17** (Important: Must be JDK 17, not 24)
4. **Android SDK** (installed at: `/Users/Abubakar/Library/Android/sdk`)
5. **Gradle 8.11.1** (already downloaded in `platforms/android/gradle-8.11.1/`)

### Environment Variables:
```bash
JAVA_HOME=$(/usr/libexec/java_home -v 17)
ANDROID_HOME=/Users/Abubakar/Library/Android/sdk
ANDROID_SDK_ROOT=/Users/Abubakar/Library/Android/sdk
```

---

## Build Commands

### Full Rebuild (After ANY changes)
Use this command every time you make changes to the app:

```bash
cd /Users/Abubakar/STECH/moodleapp && \
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
```

**Time**: ~3-5 minutes  
**Output**: `CHI-LMS-debug.apk` (ready to install)

---

### Quick Rebuild (Config changes ONLY)
Use this ONLY if you changed `config.xml` or `moodle.config.json` but NO code/theme changes:

```bash
cd /Users/Abubakar/STECH/moodleapp && \
npx cordova prepare android && \
cd platforms/android && \
JAVA_HOME=$(/usr/libexec/java_home -v 17) \
ANDROID_HOME=/Users/Abubakar/Library/Android/sdk \
ANDROID_SDK_ROOT=/Users/Abubakar/Library/Android/sdk \
./gradle-8.11.1/bin/gradle assembleDebug && \
cd ../.. && \
cp -f platforms/android/app/build/outputs/apk/debug/app-debug.apk CHI-LMS-debug.apk && \
echo "✅ Build complete! APK: CHI-LMS-debug.apk"
```

**Time**: ~1-2 minutes

---

## Configuration Files

### 1. App Name & Branding
**File**: `config.xml`
```xml
<name>CHI-LMS</name>
<description>Community Health Institute LMS</description>
```

### 2. App Display Name
**File**: `moodle.config.json`
```json
"appname": "Community Health Institute LMS"
```

### 3. Pre-configured Site
**File**: `moodle.config.json`
```json
"sites": [
    {
        "url": "https://lms.chi.edu.ng",
        "name": "CHI-LMS"
    }
],
"onlyallowlistedsites": false
```
Note: The site appears in the list but users still need to select and login. This prevents white screen issues.

### 4. Brand Colors (Green Theme)
**File**: `src/theme/globals.variables.scss`
```scss
$brand-color: #28a745 !default;
```

**File**: `moodle.config.json`
```json
"notificoncolor": "#28a745"
```

**File**: `config.xml`
```xml
<preference name="StatusBarBackgroundColor" value="#28a745" />
<preference name="NavigationBarBackgroundColor" value="#28a745" />
```

---

## Common Customizations

### Change App Name
1. Edit `config.xml`:
   ```xml
   <name>Your New Name</name>
   ```

2. Edit `moodle.config.json`:
   ```json
   "appname": "Your New Name"
   ```

3. Rebuild using **Full Rebuild** command

### Change Pre-configured Site URL
1. Edit `moodle.config.json`:
   ```json
   "sites": [
       {
           "url": "https://your-new-site.com",
           "name": "Your Site Name"
       }
   ]
   ```

2. Rebuild using **Quick Rebuild** command (config only)

Note: Do NOT set "onlyallowlistedsites": true or "default": true as this can cause white screen issues.

### Change Brand Color
1. Edit `src/theme/globals.variables.scss`:
   ```scss
   $brand-color: #your-color !default;
   ```

2. Edit `moodle.config.json`:
   ```json
   "notificoncolor": "#your-color"
   ```

3. Edit `config.xml`:
   ```xml
   <preference name="StatusBarBackgroundColor" value="#your-color" />
   <preference name="NavigationBarBackgroundColor" value="#your-color" />
   ```

4. Rebuild using **Full Rebuild** command

---

## Installing the APK

### On Your Device:
1. Enable **Developer Options** on your Android device
2. Enable **USB Debugging**
3. Connect device to computer
4. Run:
   ```bash
   adb install /Users/Abubakar/STECH/moodleapp/CHI-LMS-debug.apk
   ```

### Manual Installation:
1. Copy `CHI-LMS-debug.apk` to your Android device
2. Open the APK file on your device
3. Allow installation from unknown sources if prompted
4. Install the app

---

## Troubleshooting

### Build Fails with "Unsupported class file major version 68"
**Problem**: Wrong Java version  
**Solution**: Make sure you're using Java 17:
```bash
java -version  # Should show version 17
/usr/libexec/java_home -v 17  # Use this in JAVA_HOME
```

### Build Fails with "No matching client found for package name"
**Problem**: google-services.json package name mismatch  
**Solution**: Make sure package name in `config.xml`, `moodle.config.json`, and `google-services.json` all match

### App Crashes on Login
**Problem**: Package name was changed after initial installation  
**Solution**: 
1. Uninstall old app completely
2. Keep package as `com.moodle.moodlemobile` (don't change it)
3. Reinstall new APK

### White Screen / App Won't Load
**Problem**: Forced default site or onlyallowlistedsites configuration  
**Solution**: 
1. Edit `moodle.config.json`:
   ```json
   "onlyallowlistedsites": false
   ```
2. Remove `"default": true` from sites array
3. Rebuild the app

### Changes Not Showing Up
**Problem**: Cache or incomplete build  
**Solution**: 
1. Run full clean rebuild:
   ```bash
   cd platforms/android && ./gradle-8.11.1/bin/gradle clean
   ```
2. Then run **Full Rebuild** command

---

## File Locations

### APK Output:
- Debug APK: `CHI-LMS-debug.apk` (in project root)
- Raw APK: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

### Key Configuration Files:
- `config.xml` - Cordova config (app name, package ID, permissions)
- `moodle.config.json` - Moodle app config (site URL, branding)
- `google-services.json` - Firebase config (must match package name)
- `src/theme/globals.variables.scss` - Color theme variables

---

## Important Notes

⚠️ **DO NOT CHANGE PACKAGE NAME** (`com.moodle.moodlemobile`)  
Changing the package name causes authentication issues with Moodle. Keep it as is.

⚠️ **Always Use Java 17**  
Gradle 8.11.1 requires Java 17. Using Java 24 or other versions will fail.

⚠️ **Debug vs Release APK**  
- Debug APK: For testing, auto-signed, installs easily
- Release APK: For production, requires keystore signing

⚠️ **Site Configuration**  
The app has your site pre-configured in the list. Users select it and login normally. Do NOT use `onlyallowlistedsites: true` or `"default": true` as this causes white screen issues.

---

## Version Information

- **App Version**: 5.1.0
- **Version Code**: 51001
- **Moodle App Base**: 5.1.0
- **Android Min SDK**: 24
- **Android Target SDK**: 36
- **Package Name**: com.moodle.moodlemobile

---

## Support

For issues with:
- **Moodle functionality**: Check Moodle documentation
- **Build errors**: Review this document's troubleshooting section
- **Site connectivity**: Verify https://lms.chi.edu.ng is accessible

---

**Last Updated**: December 15, 2024  
**Built By**: Community Health Institute IT Team
