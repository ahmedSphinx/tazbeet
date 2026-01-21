# Creating Production Provisioning Profile

## Steps in Apple Developer Portal

1. Go to: Certificates, Identifiers & Profiles
2. Click "Profiles" in sidebar
3. Click "+" button to add new profile
4. Select "App Store" under "Distribution"
5. Click "Continue"

## Profile Configuration
- **App ID**: Select "com.company.tazbeet"
- **Distribution Certificate**: Select "iPhone Distribution: abas moaty"
- **Continue**

## Profile Details
- **Profile Name**: Tazbeet App Store Production
- **Generate** the profile
- **Download** the .mobileprovision file
- **Save as**: Tazbeet_AppStore.mobileprovision

## After Download
1. Double-click the .mobileprovision file to install
2. Update ExportOptions.plist with profile name
3. Run production build
