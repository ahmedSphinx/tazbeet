#!/bin/bash

# Script to clean up duplicate l10n folders and archived code
# Run from project root: bash scripts/cleanup_duplicates.sh

echo "🧹 Tazbeet Cleanup Script"
echo "========================"
echo ""

# Backup before deletion
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup in $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Remove duplicate l10n folders
echo ""
echo "📁 Removing duplicate l10n folders..."

if [ -d "lib/l10n/Thursday, January 22, 2026, week 4" ]; then
    echo "  - Moving 'Thursday, January 22, 2026, week 4' to backup"
    mv "lib/l10n/Thursday, January 22, 2026, week 4" "$BACKUP_DIR/"
fi

if [ -d "lib/l10n/l10n_fixed_v2" ]; then
    echo "  - Moving 'l10n_fixed_v2' to backup"
    mv "lib/l10n/l10n_fixed_v2" "$BACKUP_DIR/"
fi

if [ -d "lib/l10n/l10n_fixed_week4" ]; then
    echo "  - Moving 'l10n_fixed_week4' to backup"
    mv "lib/l10n/l10n_fixed_week4" "$BACKUP_DIR/"
fi

# Remove archived code
echo ""
echo "🗂️  Removing archived code..."

if [ -d "lib/_archive" ]; then
    echo "  - Moving '_archive' folder to backup"
    mv "lib/_archive" "$BACKUP_DIR/"
fi

# Count TODO/FIXME comments
echo ""
echo "📝 Scanning for TODO/FIXME comments..."
TODO_COUNT=$(grep -r "TODO\|FIXME\|HACK" lib/ --include="*.dart" | wc -l)
echo "  Found $TODO_COUNT TODO/FIXME/HACK comments"

# List large files
echo ""
echo "📏 Finding large files (>500 lines)..."
find lib/ -name "*.dart" -exec wc -l {} \; | sort -rn | head -10 | while read lines file; do
    if [ "$lines" -gt 500 ]; then
        echo "  - $file: $lines lines"
    fi
done

echo ""
echo "✅ Cleanup complete!"
echo "Backup saved in: $BACKUP_DIR"
echo ""
echo "Next steps:"
echo "1. Review backup folder"
echo "2. Run: flutter analyze"
echo "3. Run: flutter test"
echo "4. If all good, delete backup folder"
