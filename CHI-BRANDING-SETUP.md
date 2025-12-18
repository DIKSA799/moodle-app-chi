# CHI-LMS Custom Branding Configuration

## Current Build
- **APK**: CHI-LMS-debug-v1.0.1.apk (15MB)
- **Date**: Dec 18, 2024
- **Status**: Ready for testing

## What Was Fixed

### 1. Site Auto-Connect
- **Setting**: `onlyallowlistedsites: true`
- **Effect**: App only allows connection to CHI-LMS site
- **URL**: https://lms.chi.edu.ng/public

### 2. Logo Display
- **Setting**: `forceLoginLogo: true`
- **Setting**: `showTopLogo: visible`
- **Effect**: CHI logo shows on login and top of app

### 3. Logo Files Updated
All logo files set to CHI_logo.png (261KB):
- `src/assets/img/login_logo.png` - Login screen logo
- `src/assets/img/top_logo.png` - Top navigation logo
- `src/assets/icon/icon.png` - App icon (internal)
- `src/assets/icon/favicon.png` - Favicon
- `resources/icon.png` - Cordova icon
- `resources/splash.png` - Splash screen
- `resources/android/icon-foreground.png` - Android adaptive icon
- `resources/android/icon/*.png` - All Android icon sizes

### 4. App Identity
- **App ID**: ng.edu.chi.lms
- **App Name**: CHI-LMS
- **Version**: 1.0.1 (10001)

## Testing Checklist

Install APK on Android device:
```bash
adb install -r CHI-LMS-debug-v1.0.1.apk
```

Verify:
- ✅ App opens without white screen
- ✅ CHI logo appears on splash screen
- ✅ CHI logo appears on login screen
- ✅ App automatically shows CHI-LMS site URL
- ✅ App icon shows CHI logo
- ✅ Can log in and access site
- ✅ CHI logo visible in app header

## Build Commands

### Debug APK (for testing)
```bash
sudo ./COMPLETE-BUILD.sh
```

### Release AAB (for Play Store)
```bash
sudo ./BUILD-AAB-v1.0.1.sh
```

## Configuration Files

### moodle.config.json
Key settings:
- `onlyallowlistedsites: true` - Forces CHI site only
- `forceLoginLogo: true` - Shows custom logo
- `showTopLogo: "visible"` - Shows logo in header
- `sites: [{url: "https://lms.chi.edu.ng/public", ...}]` - Default site

### config.xml
Key settings:
- `id="ng.edu.chi.lms"` - Package ID
- `version="1.0.1"` - Version
- `versionCode="10001"` - Build number
- `<name>CHI-LMS</name>` - App name

## Notes

- All branding files are now correctly set
- App will only connect to CHI-LMS site
- Logo displays throughout the app
- Ready for production build after testing
