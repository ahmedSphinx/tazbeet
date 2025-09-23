# Android Keystore Configuration

This document explains the keystore setup for the Tazbeet app.

## 📁 Files Created

### 1. Keystore File
- **Location**: `android/keystore/tazbeet.keystore`
- **Alias**: `tazbeet-key`
- **Validity**: 10,000 days (~27 years)
- **Key Algorithm**: RSA 2048-bit
- **Password**: `tazbeet2025` (both store and key password)

### 2. Configuration File
- **Location**: `android/key.properties`
- **Purpose**: Stores keystore credentials securely
- **Note**: This file is added to `.gitignore` for security

### 3. ProGuard Rules
- **Location**: `android/app/proguard-rules.pro`
- **Purpose**: Protects the app from reverse engineering
- **Features**: Keeps Flutter, Firebase, and authentication libraries

## 🔐 Security Information

### Keystore Details
```
Store Password: tazbeet2025
Key Password: tazbeet2025
Key Alias: tazbeet-key
```

### Distinguished Name (DN)
```
CN=Tazbeet Company
OU=Development Team
O=Tazbeet App
L=New York
ST=NY
C=US
```

## 🚀 How to Use

### Building Release APK
```bash
flutter build apk --release
```

### Building App Bundle (Recommended for Play Store)
```bash
flutter build appbundle --release
```

### Manual Signing (if needed)
```bash
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore android/keystore/tazbeet.keystore app-release-unsigned.apk tazbeet-key
```

## 📝 Important Notes

1. **Keep the keystore safe**: The `.jks` file contains your private key
2. **Backup the keystore**: Store it in a secure location
3. **Never commit to version control**: Both `.jks` and `key.properties` are in `.gitignore`
4. **Use for Play Store**: This keystore is ready for Google Play Store submission

## 📱 App Information
- **Package Name**: `com.company.tazbeet`
- **Application ID**: `com.company.tazbeet`

## 🔄 Regenerating Keystore

If you need to create a new keystore:

```bash
keytool -genkeypair -v \
  -keystore android/keystore/tazbeet.keystore \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias tazbeet-key \
  -dname "CN=Tazbeet Company, OU=Development Team, O=Tazbeet App, L=New York, ST=NY, C=US" \
  -storepass YOUR_STORE_PASSWORD \
  -keypass YOUR_KEY_PASSWORD
```

Then update `android/key.properties` with your new passwords.

## 📱 Play Store Upload

When uploading to Google Play Store:
1. Use the same keystore for all app updates
2. Keep the keystore file safe and backed up
3. Never lose or delete the keystore file
4. The app's package name is: `com.company.tazbeet`

## 🆘 Troubleshooting

### Build Fails
- Check that `key.properties` exists in `android/` directory
- Verify keystore passwords match in `key.properties`
- Ensure keystore file path is correct (`android/keystore/tazbeet.keystore`)

### Lost Keystore
- Unfortunately, lost keystores cannot be recovered
- You'll need to create a new keystore and publish as a new app
- Consider using Google Play App Signing for future apps

---

**⚠️ IMPORTANT**: Keep your keystore file (`android/keystore/tazbeet.keystore`) and passwords secure. Never share them or commit them to version control.
