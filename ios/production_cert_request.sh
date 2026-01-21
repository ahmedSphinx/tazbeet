#!/bin/bash

# Production Certificate Generation Script for Tazbeet iOS App
# This script generates a certificate signing request for production distribution

echo "=== Tazbeet iOS Production Certificate Request ==="
echo ""

# Configuration
CERT_NAME="Tazbeet Production Distribution"
EMAIL="developer@tazbeet.com"
COUNTRY="US"
ORG_NAME="Tazbeet Inc"
ORG_UNIT="Development"

# Create certificate signing request
echo "Generating Certificate Signing Request..."
openssl req -nodes -newkey rsa:2048 \
  -keyout TazbeetProduction.key \
  -out TazbeetProduction.certSigningRequest \
  -subj "/C=$COUNTRY/O=$ORG_NAME/OU=$ORG_UNIT/CN=$CERT_NAME/emailAddress=$EMAIL"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Certificate Signing Request generated successfully!"
    echo ""
    echo "Files created:"
    echo "  - TazbeetProduction.key (private key - KEEP SECURE)"
    echo "  - TazbeetProduction.certSigningRequest (upload to Apple Developer Portal)"
    echo ""
    echo "Next steps:"
    echo "1. Upload TazbeetProduction.certSigningRequest to Apple Developer Portal"
    echo "2. Download the production certificate (.cer file)"
    echo "3. Convert .cer to .p12 format for Xcode"
    echo ""
    echo "To convert .cer to .p12 after downloading from Apple:"
    echo "  openssl x509 -in distribution_certificate.cer -inform DER -out distribution_certificate.pem"
    echo "  openssl pkcs12 -export -out TazbeetProduction.p12 -inkey TazbeetProduction.key -in distribution_certificate.pem"
else
    echo "❌ Failed to generate certificate signing request"
    exit 1
fi
