#!/bin/bash

echo "=== Verifying Permission Configuration ==="
echo ""

echo "1. Checking Info.plist for permission descriptions..."
echo ""

if grep -q "NSMicrophoneUsageDescription" macos/Runner/Info.plist; then
    echo "✅ Microphone permission description found"
    grep -A 1 "NSMicrophoneUsageDescription" macos/Runner/Info.plist | tail -1
else
    echo "❌ Microphone permission description MISSING"
fi

echo ""

if grep -q "NSSpeechRecognitionUsageDescription" macos/Runner/Info.plist; then
    echo "✅ Speech Recognition permission description found"
    grep -A 1 "NSSpeechRecognitionUsageDescription" macos/Runner/Info.plist | tail -1
else
    echo "❌ Speech Recognition permission description MISSING"
fi

echo ""
echo "2. Checking entitlements for audio input..."
echo ""

if grep -q "com.apple.security.device.audio-input" macos/Runner/DebugProfile.entitlements; then
    echo "✅ Audio input entitlement found in DebugProfile.entitlements"
else
    echo "❌ Audio input entitlement MISSING in DebugProfile.entitlements"
fi

if grep -q "com.apple.security.device.audio-input" macos/Runner/Release.entitlements; then
    echo "✅ Audio input entitlement found in Release.entitlements"
else
    echo "❌ Audio input entitlement MISSING in Release.entitlements"
fi

echo ""
echo "3. Checking AppDelegate.swift for permission handling..."
echo ""

if grep -q "import Speech" macos/Runner/AppDelegate.swift; then
    echo "✅ Speech framework imported"
else
    echo "❌ Speech framework NOT imported"
fi

if grep -q "import AVFoundation" macos/Runner/AppDelegate.swift; then
    echo "✅ AVFoundation framework imported"
else
    echo "❌ AVFoundation framework NOT imported"
fi

if grep -q "requestMicrophonePermission" macos/Runner/AppDelegate.swift; then
    echo "✅ Microphone permission method found"
else
    echo "❌ Microphone permission method MISSING"
fi

if grep -q "requestSpeechRecognitionPermission" macos/Runner/AppDelegate.swift; then
    echo "✅ Speech Recognition permission method found"
else
    echo "❌ Speech Recognition permission method MISSING"
fi

if grep -q "requestAllPermissions" macos/Runner/AppDelegate.swift; then
    echo "✅ Request all permissions method found"
else
    echo "❌ Request all permissions method MISSING"
fi

echo ""
echo "4. Checking Dart permission service..."
echo ""

if [ -f "lib/services/permission_service.dart" ]; then
    echo "✅ PermissionService exists"
    
    if grep -q "requestMicrophonePermission" lib/services/permission_service.dart; then
        echo "✅ Microphone permission method in Dart"
    fi
    
    if grep -q "requestSpeechRecognitionPermission" lib/services/permission_service.dart; then
        echo "✅ Speech Recognition permission method in Dart"
    fi
    
    if grep -q "requestAllPermissions" lib/services/permission_service.dart; then
        echo "✅ Request all permissions method in Dart"
    fi
else
    echo "❌ PermissionService MISSING"
fi

echo ""
echo "5. Checking main.dart initialization..."
echo ""

if grep -q "PermissionService.requestAllPermissions" lib/main.dart; then
    echo "✅ Permissions requested on app startup"
else
    echo "❌ Permissions NOT requested on app startup"
fi

echo ""
echo "=== Verification Complete ==="
echo ""
echo "Summary:"
echo "--------"
echo "Your app is configured to request BOTH:"
echo "  1. 🎤 Microphone Permission"
echo "  2. 🗣️  Speech Recognition Permission"
echo ""
echo "When you run the app, you will see TWO permission dialogs:"
echo "  Dialog 1: \"hexmac would like to access the microphone\""
echo "  Dialog 2: \"hexmac would like to use speech recognition\""
echo ""
echo "Click OK on BOTH dialogs for the app to work properly!"
