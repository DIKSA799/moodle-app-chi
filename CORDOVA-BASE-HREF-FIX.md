# Cordova Base Href Fix

## The Problem

When running `npm start`, the app works fine because it's served by a development server.
But when building for Cordova/Android, the app shows a **blank white screen**.

## Root Cause

The Angular build generates `www/index.html` with:
```html
<base href="/">
```

This works for web servers but **FAILS** in Cordova apps because:
- Cordova loads the app from `file:///` protocol
- The `/` base href tries to load resources from the filesystem root
- All JavaScript files fail to load → blank screen

## The Solution

Change the base href to be relative:
```html
<base href="./">
```

This makes all resource paths relative to the `index.html` location.

## How It's Fixed

### 1. Automatic Fix (in build script)
The `COMPLETE-BUILD.sh` script now includes:
```bash
sed -i.bak 's|<base href="/">|<base href="./">|g' www/index.html
```

### 2. Cordova Hook (for cordova prepare)
Created `hooks/after_prepare/fix_base_href.js` that automatically fixes the base href
when you run `cordova prepare android`.

## Testing

**Before Fix**: Blank white screen  
**After Fix**: App loads and displays correctly

### Verify the fix:
```bash
# Check www/index.html
grep "base href" www/index.html
# Should show: <base href="./">

# Check the Android assets
grep "base href" platforms/android/app/src/main/assets/www/index.html
# Should show: <base href="./">
```

## Why npm start works but build doesn't

| Command | How it works | Base Href | Result |
|---------|-------------|-----------|--------|
| `npm start` | Dev server at http://localhost | `/` is fine | ✅ Works |
| `ionic build` | Static files in www/ | `/` breaks Cordova | ❌ Blank screen |
| `ionic build` + fix | Static files with `./` | `./ ` works | ✅ Works |

## Important Notes

- This fix is now included in `COMPLETE-BUILD.sh`
- The hook will auto-fix on `cordova prepare`
- Always use `./` for Cordova base href
- `/` is only for web-hosted apps

## Files Modified

1. `www/index.html` - Base href changed to `./ `
2. `COMPLETE-BUILD.sh` - Added sed command to fix base href
3. `hooks/after_prepare/fix_base_href.js` - Created auto-fix hook
4. `CHI-LMS-debug-v1.0.1.apk` - Rebuilt with fix

---

**Status**: ✅ Fixed - App now works correctly!
