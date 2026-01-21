# Recreate Production Provisioning Profile with Entitlements

## Problem
Current provisioning profile missing:
- aps-environment entitlement
- com.apple.developer.applesignin entitlement

## Solution: Recreate Profile

1. **Delete Current Profile**:
   - Go to Apple Developer Portal → Profiles
   - Delete "Tazbeet App Store Production"

2. **Create New Profile**:
   - Click "+" → "App Store" → "Continue"
   - App ID: "com.company.tazbeet"
   - Certificate: "iPhone Distribution: abas moaty"
   - **Enable capabilities**:
     * Push Notifications
     * Sign in with Apple
   - Name: "Tazbeet App Store Production v2"
   - Generate and download

3. **Install New Profile**:
   - Double-click .mobileprovision file
   - Update ExportOptions.plist with new name

4. **Build Again**:
   - Run: `xcodebuild -exportArchive -archivePath build/ios/archive/Runner.xcarchive -exportPath build/ios/Export -exportOptionsPlist ios/ExportOptions.plist`
