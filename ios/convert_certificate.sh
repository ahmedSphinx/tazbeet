#!/bin/bash

# Certificate Conversion Script
# Run this after downloading the .cer file from Apple Developer Portal

echo "=== Converting Apple Certificate to P12 ==="
echo ""

# Check if certificate file exists
if [ ! -f "TazbeetProduction.cer" ]; then
    echo "❌ TazbeetProduction.cer not found!"
    echo "Please download the certificate from Apple Developer Portal first."
    exit 1
fi

# Convert .cer to .pem
echo "Converting .cer to .pem..."
openssl x509 -in TazbeetProduction.cer -inform DER -out TazbeetProduction.pem

if [ $? -eq 0 ]; then
    echo "✅ Certificate converted to PEM format"
    
    # Create P12 file
    echo "Creating P12 file..."
    openssl pkcs12 -export -out TazbeetProduction.p12 \
      -inkey TazbeetProduction.key \
      -in TazbeetProduction.pem
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ P12 certificate created successfully!"
        echo "File: TazbeetProduction.p12"
        echo ""
        echo "You can now:"
        echo "1. Double-click TazbeetProduction.p12 to install in Keychain"
        echo "2. Use this certificate for production builds in Xcode"
    else
        echo "❌ Failed to create P12 file"
        exit 1
    fi
else
    echo "❌ Failed to convert certificate"
    exit 1
fi
