# SHA-1 Certificate Fingerprints for Firebase Configuration

## Current Fingerprints Found

### Debug Keystore (Development)
```
SHA1: 29:AB:59:B7:C1:F7:DD:34:D0:94:B8:22:13:E4:66:A9:59:F4:FB:35
```
**Status:** ✅ Already registered in Firebase (matches first entry in google-services.json)

### Release Keystore (Production)
```
SHA1: 2A:9A:37:06:47:CE:F4:5F:15:2B:44:1D:17:D2:60:4B:68:B5:05:D8
```
**Status:** ❌ **NOT registered in Firebase** - This needs to be added!

---

## Action Required

### Add Release SHA-1 to Firebase Console

1. Go to: https://console.firebase.google.com/project/tazbeet-570e2/settings/general
2. Scroll to "Your apps" → Android app (`com.company.tazbeet`)
3. Click "Add fingerprint"
4. Paste: `2A9A3706:47CEF45F:152B441D:17D2604B:68B505D8` (without colons)
   Or: `2A:9A:37:06:47:CE:F4:5F:15:2B:44:1D:17:D2:60:4B:68:B5:05:D8` (with colons)
5. Click Save
6. Download the updated `google-services.json`
7. Replace `android/app/google-services.json` with the new file

---

## Why This Matters

The Google Sign-In error you're seeing:
```
java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'
DEVELOPER_ERROR
```

This happens because:
- When you build a **release** APK/AAB, it's signed with your **release keystore**
- Google Play Services validates the app signature against Firebase's registered SHA-1 certificates
- Your release SHA-1 (`2A:9A:37:06...`) is NOT in Firebase
- Therefore, Google Sign-In fails with DEVELOPER_ERROR

---

## Quick Fix Steps

```bash
# 1. Add the release SHA-1 to Firebase Console (see above)

# 2. Download updated google-services.json from Firebase

# 3. Replace the file
cp ~/Downloads/google-services.json android/app/google-services.json

# 4. Clean and rebuild
flutter clean
flutter pub get
flutter build appbundle --release

# 5. Test
flutter run --release
```

---

## All SHA-1 Certificates in Firebase

After adding the release certificate, you should have:

1. ✅ `29:AB:59:B7:C1:F7:DD:34:D0:94:B8:22:13:E4:66:A9:59:F4:FB:35` (Debug - already there)
2. ✅ `1A:0C:BB:86:FD:5B:00:FC:F6:E8:E7:E8:3D:F7:69:9C:4D:C5:21:F6` (Unknown - already there)
3. ✅ `23:22:8D:D4:D2:B5:1C:64:08:FD:70:B8:7F:6A:5C:EF:03:ED:88:6A` (Unknown - already there)
4. ❌ `2A:9A:37:06:47:CE:F4:5F:15:2B:44:1D:17:D2:60:4B:68:B5:05:D8` (Release - NEEDS TO BE ADDED)

---

## Testing After Fix

### Debug Build (Should already work)
```bash
flutter run
# Try Google Sign-In - should work
```

### Release Build (Will work after adding SHA-1)
```bash
flutter build appbundle --release
# Install and test - Google Sign-In should work
```

---

## Note on Play Store Signing

If you're using **Google Play App Signing**, you'll also need to add the Play Store's SHA-1:
1. Go to Play Console → Your App → Setup → App Integrity
2. Copy the "App signing key certificate" SHA-1
3. Add it to Firebase Console as well

This is separate from your upload key and is managed by Google Play.
