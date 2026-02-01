#!/bin/bash

# Script to check and debug macOS permissions for the app

echo "======================================"
echo "macOS Permission Checker"
echo "======================================"
echo ""

APP_NAME="hexmac"
BUNDLE_ID="com.example.hexmac"

# Check if app is running
echo "1. Checking if app is running..."
if pgrep -x "$APP_NAME" > /dev/null; then
    echo "   ✓ App is running (PID: $(pgrep -x "$APP_NAME"))"
else
    echo "   ✗ App is not running"
fi
echo ""

# Check TCC database for microphone permissions
echo "2. Checking microphone permissions in TCC database..."
echo "   Note: This requires the app to have been launched at least once"
echo ""

# Check if the app bundle exists
echo "3. Checking app bundle..."
APP_BUNDLE="build/macos/Build/Products/Debug/$APP_NAME.app"
if [ -d "$APP_BUNDLE" ]; then
    echo "   ✓ App bundle found: $APP_BUNDLE"
    
    # Check Info.plist
    echo ""
    echo "4. Checking Info.plist for permission descriptions..."
    INFO_PLIST="$APP_BUNDLE/Contents/Info.plist"
    
    if /usr/libexec/PlistBuddy -c "Print :NSMicrophoneUsageDescription" "$INFO_PLIST" 2>/dev/null; then
        echo "   ✓ NSMicrophoneUsageDescription found"
    else
        echo "   ✗ NSMicrophoneUsageDescription NOT found"
    fi
    
    if /usr/libexec/PlistBuddy -c "Print :NSSpeechRecognitionUsageDescription" "$INFO_PLIST" 2>/dev/null; then
        echo "   ✓ NSSpeechRecognitionUsageDescription found"
    else
        echo "   ✗ NSSpeechRecognitionUsageDescription NOT found"
    fi
    
    # Check entitlements
    echo ""
    echo "5. Checking code signature and entitlements..."
    codesign -d --entitlements - "$APP_BUNDLE" 2>/dev/null | grep -A 1 "audio-input"
    if [ $? -eq 0 ]; then
        echo "   ✓ Audio input entitlement found in signed app"
    else
        echo "   ✗ Audio input entitlement NOT found in signed app"
    fi
else
    echo "   ✗ App bundle not found. Build the app first with: flutter build macos --debug"
fi

echo ""
echo "======================================"
echo "Manual Permission Check"
echo "======================================"
echo ""
echo "To manually check permissions:"
echo "1. Open System Settings"
echo "2. Go to Privacy & Security"
echo "3. Click on Microphone"
echo "4. Look for '$APP_NAME' in the list"
echo "5. Ensure it's toggled ON"
echo ""
echo "To reset permissions and try again:"
echo "   tccutil reset Microphone"
echo "   tccutil reset SpeechRecognition"
echo ""
echo "Then restart the app and click the microphone button."
echo ""
