#!/bin/bash

# macOS Microphone Test Script for Interview Copilot
# This script helps verify that all microphone permissions and configurations are correct

echo "======================================"
echo "macOS Microphone Setup Verification"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check macOS version
echo "1. Checking macOS version..."
MACOS_VERSION=$(sw_vers -productVersion)
echo "   macOS Version: $MACOS_VERSION"

MAJOR_VERSION=$(echo $MACOS_VERSION | cut -d '.' -f 1)
if [ "$MAJOR_VERSION" -ge 11 ]; then
    echo -e "   ${GREEN}✓${NC} macOS version is compatible (11.0+)"
else
    echo -e "   ${RED}✗${NC} macOS version is too old. Requires 11.0 or later"
    exit 1
fi
echo ""

# Check if Xcode is installed
echo "2. Checking Xcode installation..."
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    echo "   $XCODE_VERSION"
    echo -e "   ${GREEN}✓${NC} Xcode is installed"
else
    echo -e "   ${RED}✗${NC} Xcode is not installed"
    echo "   Install from: https://apps.apple.com/app/xcode/id497799835"
    exit 1
fi
echo ""

# Check if Flutter is installed
echo "3. Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo "   $FLUTTER_VERSION"
    echo -e "   ${GREEN}✓${NC} Flutter is installed"
else
    echo -e "   ${RED}✗${NC} Flutter is not installed"
    exit 1
fi
echo ""

# Check Flutter doctor for macOS
echo "4. Running Flutter doctor for macOS..."
flutter doctor -v | grep -A 5 "macOS"
echo ""

# Check if CocoaPods is installed
echo "5. Checking CocoaPods installation..."
if command -v pod &> /dev/null; then
    POD_VERSION=$(pod --version)
    echo "   CocoaPods version: $POD_VERSION"
    echo -e "   ${GREEN}✓${NC} CocoaPods is installed"
else
    echo -e "   ${YELLOW}⚠${NC} CocoaPods is not installed"
    echo "   Install with: sudo gem install cocoapods"
fi
echo ""

# Check Info.plist permissions
echo "6. Checking Info.plist permissions..."
if grep -q "NSMicrophoneUsageDescription" macos/Runner/Info.plist; then
    echo -e "   ${GREEN}✓${NC} NSMicrophoneUsageDescription found"
else
    echo -e "   ${RED}✗${NC} NSMicrophoneUsageDescription missing"
fi

if grep -q "NSSpeechRecognitionUsageDescription" macos/Runner/Info.plist; then
    echo -e "   ${GREEN}✓${NC} NSSpeechRecognitionUsageDescription found"
else
    echo -e "   ${RED}✗${NC} NSSpeechRecognitionUsageDescription missing"
fi
echo ""

# Check entitlements
echo "7. Checking entitlements..."
if grep -q "com.apple.security.device.audio-input" macos/Runner/DebugProfile.entitlements; then
    echo -e "   ${GREEN}✓${NC} Audio input entitlement found in DebugProfile"
else
    echo -e "   ${RED}✗${NC} Audio input entitlement missing in DebugProfile"
fi

if grep -q "com.apple.security.device.audio-input" macos/Runner/Release.entitlements; then
    echo -e "   ${GREEN}✓${NC} Audio input entitlement found in Release"
else
    echo -e "   ${RED}✗${NC} Audio input entitlement missing in Release"
fi
echo ""

# Check Podfile deployment target
echo "8. Checking Podfile deployment target..."
if grep -q "platform :osx, '11.0'" macos/Podfile; then
    echo -e "   ${GREEN}✓${NC} Deployment target is set to 11.0"
else
    echo -e "   ${YELLOW}⚠${NC} Deployment target might be incorrect"
    echo "   Current setting:"
    grep "platform :osx" macos/Podfile
fi
echo ""

# Check if pods are installed
echo "9. Checking CocoaPods installation..."
if [ -d "macos/Pods" ]; then
    echo -e "   ${GREEN}✓${NC} Pods directory exists"
    if [ -f "macos/Podfile.lock" ]; then
        echo -e "   ${GREEN}✓${NC} Podfile.lock exists"
        if grep -q "speech_to_text" macos/Podfile.lock; then
            SPEECH_VERSION=$(grep "speech_to_text" macos/Podfile.lock | head -n 1)
            echo "   $SPEECH_VERSION"
            echo -e "   ${GREEN}✓${NC} speech_to_text pod is installed"
        else
            echo -e "   ${RED}✗${NC} speech_to_text pod not found"
        fi
    else
        echo -e "   ${YELLOW}⚠${NC} Podfile.lock not found. Run: cd macos && pod install"
    fi
else
    echo -e "   ${YELLOW}⚠${NC} Pods not installed. Run: cd macos && pod install"
fi
echo ""

# Check pubspec.yaml dependencies
echo "10. Checking Flutter dependencies..."
if grep -q "speech_to_text:" pubspec.yaml; then
    echo -e "   ${GREEN}✓${NC} speech_to_text dependency found"
else
    echo -e "   ${RED}✗${NC} speech_to_text dependency missing"
fi

if grep -q "permission_handler:" pubspec.yaml; then
    echo -e "   ${GREEN}✓${NC} permission_handler dependency found"
else
    echo -e "   ${RED}✗${NC} permission_handler dependency missing"
fi
echo ""

# Check if microphone is available
echo "11. Checking system microphone..."
if system_profiler SPAudioDataType | grep -q "Input"; then
    echo -e "   ${GREEN}✓${NC} Microphone detected"
    echo "   Available input devices:"
    system_profiler SPAudioDataType | grep -A 2 "Input"
else
    echo -e "   ${YELLOW}⚠${NC} No microphone detected"
fi
echo ""

# Summary
echo "======================================"
echo "Setup Verification Complete"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. If any checks failed, fix them before running the app"
echo "2. Run: flutter clean"
echo "3. Run: flutter pub get"
echo "4. Run: cd macos && pod install && cd .."
echo "5. Run: flutter run -d macos"
echo ""
echo "When the app launches:"
echo "- Click a microphone button"
echo "- Grant microphone permission when prompted"
echo "- Grant speech recognition permission when prompted"
echo "- Test both microphone buttons (header and input)"
echo ""
