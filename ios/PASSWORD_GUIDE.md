# Certificate Password Guide

## Current Situation
The export process is asking for the private key password used when creating the original certificate.

## Password Options
Try these passwords in order:

1. **tazbeet123** (if you set this)
2. **123456** (if you set this)
3. **Empty password** (if you didn't set one)
4. **Your Mac login password** (if Keychain asks)

## If All Else Fails
1. Open Keychain Access
2. Find "iPhone Distribution: abas moaty" certificate
3. Right-click → Get Info
4. Check if certificate shows as valid

## Alternative: Use Xcode
Instead of command line export, use:
- Xcode → Window → Organizer → Archives
- Select archive → Distribute App
- Xcode will handle signing automatically
