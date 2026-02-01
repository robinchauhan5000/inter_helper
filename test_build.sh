#!/bin/bash

echo "=== Testing macOS Permission Fix ==="
echo ""

echo "1. Cleaning previous builds..."
flutter clean

echo ""
echo "2. Getting dependencies..."
flutter pub get

echo ""
echo "3. Installing CocoaPods..."
cd macos && pod install && cd ..

echo ""
echo "4. Building for macOS..."
flutter build macos --debug

echo ""
echo "=== Build Complete ==="
echo ""
echo "To run the app:"
echo "  flutter run -d macos"
echo ""
echo "On first launch, you should see permission dialogs for:"
echo "  - Microphone access"
echo "  - Speech recognition"
echo ""
echo "Grant both permissions and the app should work without crashing!"
