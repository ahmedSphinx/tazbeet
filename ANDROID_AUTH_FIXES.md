# Android Authentication Fixes Applied

## Issues Fixed

### 1. ✅ Apple Sign-In on Android - FIXED
**Error:** `Exception: webAuthenticationOptions argument must be provided on Android.`

**Root Cause:** The `sign_in_with_apple` package requires `webAuthenticationOptions` when running on Android platform.

**Fix Applied:** Updated `lib/services/auth_service.dart` to include web authentication options:
```dart
final appleCredential = await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
  webAuthenticationOptions: WebAuthenticationOptions(
    clientId: 'com.company.tazbeet',
    redirectUri: Uri.parse(
      'https://tazbeet-app.firebaseapp.com/__/auth/handler',
    ),
  ),
);
```

---

### 2. ⚠️ Google Sign-In SHA-1 Certificate Issue - REQUIRES MANUAL ACTION

**Error:** 
```
java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'
DEVELOPER_ERROR
```

**Root Cause:** The SHA-1 certificate fingerprint registered in Firebase Console doesn't match your current debug/release keystore.

**Current SHA-1 Certificates in Firebase:**
- `29ab59b7c1f7dd34d094b82213e466a959f4fb35`
- `1a0cbb86fd5b00fcf6e8e7e83df7699c4dc521f6`
- `23228dd4d2b51c6408fd70b87f6a5cef03ed886a`

---

## Required Manual Steps for Google Sign-In

### Step 1: Get Your Current SHA-1 Fingerprint

Run this command to get your **debug** keystore SHA-1:
```bash
cd android
./gradlew signingReport
```

Or use keytool directly:
```bash
# For debug keystore (macOS/Linux)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release keystore
keytool -list -v -keystore keystore/tazbeet.keystore -alias tazbeet-key -storepass tazbeet2025
```

### Step 2: Add SHA-1 to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **tazbeet-570e2**
3. Go to **Project Settings** (gear icon)
4. Scroll to **Your apps** section
5. Click on your Android app (`com.company.tazbeet`)
6. Click **Add fingerprint**
7. Paste your SHA-1 fingerprint
8. Click **Save**

### Step 3: Download Updated google-services.json

1. In Firebase Console, after adding the SHA-1
2. Click **Download google-services.json**
3. Replace the file at: `android/app/google-services.json`

### Step 4: Clean and Rebuild

```bash
flutter clean
cd android && ./gradlew clean
cd ..
flutter pub get
flutter run
```

---

## Testing the Fixes

### Test Apple Sign-In (Android)
1. Run the app on an Android device/emulator
2. Tap "Sign in with Apple"
3. Should now show the web authentication flow
4. Complete sign-in in the browser
5. Should redirect back to app successfully

### Test Google Sign-In (After SHA-1 Fix)
1. Run the app on an Android device/emulator
2. Tap "Sign in with Google"
3. Should show Google account picker
4. Select account
5. Should sign in successfully without DEVELOPER_ERROR

---

## Additional Recommendations

### 1. Add Multiple SHA-1 Certificates
For better compatibility, add SHA-1 for:
- ✅ Debug keystore (for development)
- ✅ Release keystore (for production)
- ✅ Play Store signing certificate (if using Google Play App Signing)

### 2. Verify Package Name Consistency
Ensure package name is consistent everywhere:
- ✅ `android/app/build.gradle.kts`: `com.company.tazbeet`
- ✅ `google-services.json`: `com.company.tazbeet`
- ✅ Firebase Console: `com.company.tazbeet`

### 3. Enable Sign-In Methods in Firebase
Verify in Firebase Console → Authentication → Sign-in method:
- ✅ Google (Enabled)
- ✅ Apple (Enabled)
- ✅ Email/Password (if needed)

---

## Quick Reference Commands

```bash
# Get debug SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1

# Get release SHA-1
keytool -list -v -keystore keystore/tazbeet.keystore -alias tazbeet-key -storepass tazbeet2025 | grep SHA1

# Clean build
flutter clean && flutter pub get && flutter run

# Check signing report
cd android && ./gradlew signingReport
```

---

## Status

- ✅ **Apple Sign-In**: Fixed (code updated)
- ⏳ **Google Sign-In**: Requires manual SHA-1 configuration in Firebase Console

Once you add the correct SHA-1 fingerprint to Firebase and download the updated `google-services.json`, both authentication methods should work correctly on Android.
