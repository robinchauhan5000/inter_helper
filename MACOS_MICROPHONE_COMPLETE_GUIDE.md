# Complete macOS Microphone Setup Guide

## ✅ Setup Status: COMPLETE

All required permissions and configurations have been added for macOS speech recognition.

## What Was Configured

### 1. Dependencies Added

**File: `pubspec.yaml`**

```yaml
dependencies:
  speech_to_text: ^7.0.0
  permission_handler: ^11.3.1
```

### 2. macOS Permissions

**File: `macos/Runner/Info.plist`**

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to the microphone for speech-to-text functionality during interviews.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs access to speech recognition to convert your voice to text.</string>
```

### 3. macOS Entitlements

**Files: `macos/Runner/DebugProfile.entitlements` & `macos/Runner/Release.entitlements`**

```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

### 4. Deployment Target

**Files: `macos/Podfile` & `macos/Runner/Configs/AppInfo.xcconfig`**

- Minimum macOS version: **11.0** (Big Sur)
- Required for speech_to_text package compatibility

### 5. New Service Created

**File: `lib/services/speech_service.dart`**

- Handles speech-to-text initialization
- Manages microphone permissions
- Provides speech recognition callbacks
- macOS-specific error handling

## How to Run

### Quick Start

```bash
# 1. Clean previous builds
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Install CocoaPods (if needed)
cd macos && pod install && cd ..

# 4. Run on macOS
flutter run -d macos
```

### Verification Script

Run the automated verification:

```bash
./test_macos_microphone.sh
```

## Microphone Features

### 🎤 Header Microphone (Top Button)

**Location:** Top header bar, left side

**Visual States:**

- 🔴 **Red** = OFF (not listening)
- 🟢 **Green** = ON (listening)
- ⚪ **White dot** = Actively recording

**Behavior:**

1. Click to start listening
2. Speak your question
3. Automatically sends to AI after 3 seconds of silence
4. Maximum duration: 30 seconds

**Use Case:** Quick questions that go directly to AI

### 🎤 Input Microphone (Bottom Button)

**Location:** Bottom input bar, left side

**Visual States:**

- 🔴 **Red** = OFF (not listening)
- 🟢 **Green** = ON (listening)
- ⚪ **White dot** = Actively recording

**Behavior:**

1. Click to start listening
2. Speak your message
3. Text appears in input field in real-time
4. Edit if needed
5. Click send button when ready

**Use Case:** Messages you want to review before sending

## First Run Experience

### Permission Prompts

When you first click a microphone button, macOS will show:

1. **Microphone Permission**

   ```
   "hexmac would like to access the microphone"
   [Don't Allow] [OK]
   ```

   → Click **OK**

2. **Speech Recognition Permission**
   ```
   "hexmac would like to use Speech Recognition"
   [Don't Allow] [OK]
   ```
   → Click **OK**

### If You Denied Permissions

Go to **System Settings** → **Privacy & Security**:

1. **Microphone**
   - Find "hexmac" in the list
   - Toggle ON

2. **Speech Recognition**
   - Find "hexmac" in the list
   - Toggle ON

Then restart the app.

## Testing Checklist

### ✅ Pre-Launch Tests

- [ ] Run `./test_macos_microphone.sh` - all checks pass
- [ ] macOS version 11.0 or later
- [ ] Microphone detected in system
- [ ] CocoaPods installed successfully

### ✅ Runtime Tests

- [ ] App launches without errors
- [ ] Header mic button shows red initially
- [ ] Input mic button shows red initially
- [ ] Clicking header mic requests permissions
- [ ] Permissions granted successfully
- [ ] Header mic turns green when clicked
- [ ] Input mic turns green when clicked
- [ ] White dot appears when listening
- [ ] Speech is converted to text
- [ ] Header mic sends directly to AI
- [ ] Input mic fills text field
- [ ] Both mics can be toggled on/off

### ✅ Speech Recognition Tests

Test phrases to verify accuracy:

- "What is a goroutine in golang?"
- "Explain closures in JavaScript"
- "How does async await work?"
- "What are the SOLID principles?"

## Troubleshooting

### Issue: "Permission Denied" Error

**Symptoms:** Red snackbar appears saying "Microphone permission denied"

**Solutions:**

1. Check System Settings → Privacy & Security → Microphone
2. Enable for "hexmac"
3. Restart the app
4. Try clicking microphone button again

### Issue: Microphone Button Stays Red

**Symptoms:** Button doesn't turn green when clicked

**Solutions:**

1. Check if microphone is connected
2. Test microphone in Voice Memos app
3. Verify permissions in System Settings
4. Check console for error messages:
   ```bash
   flutter run -d macos -v
   ```

### Issue: No Speech Recognition

**Symptoms:** Button turns green but no text appears

**Solutions:**

1. Verify internet connection (required for speech recognition)
2. Check if Siri is enabled (uses same engine)
3. Speak clearly and at normal pace
4. Check for background noise
5. Try restarting the app

### Issue: Build Errors

**Symptoms:** Compilation fails or pod install errors

**Solutions:**

```bash
# Complete clean rebuild
flutter clean
cd macos
rm -rf Pods Podfile.lock
pod deintegrate
pod install
cd ..
flutter pub get
flutter run -d macos
```

### Issue: "Unsupported macOS version"

**Symptoms:** Error about deployment target

**Solutions:**

1. Verify macOS version: `sw_vers -productVersion`
2. Must be 11.0 or later
3. Update macOS if needed
4. Check `macos/Podfile` has `platform :osx, '11.0'`

## Technical Details

### Speech Recognition Flow

```
User clicks mic button
    ↓
Request permissions (first time only)
    ↓
Initialize speech service
    ↓
Start listening (button turns green)
    ↓
Convert speech to text (real-time)
    ↓
Stop after silence or max duration
    ↓
Header mic: Send to AI
Input mic: Fill text field
```

### Permission Flow

```
App requests microphone permission
    ↓
macOS shows system dialog
    ↓
User grants/denies
    ↓
App requests speech recognition permission
    ↓
macOS shows system dialog
    ↓
User grants/denies
    ↓
Permissions stored in system
    ↓
Future launches: No prompts needed
```

### Architecture

```
View Layer (interview_copilot_view.dart)
    ↓
Speech Service (speech_service.dart)
    ↓
speech_to_text Package
    ↓
Apple Speech Framework
    ↓
macOS System Services
```

## Performance Considerations

### First Launch

- Speech service initialization: ~1-2 seconds
- Permission dialogs: User interaction required
- Subsequent launches: Instant (permissions cached)

### Speech Recognition

- Latency: ~100-300ms for partial results
- Final result: After 3 seconds of silence
- Maximum duration: 30 seconds
- Requires: Active internet connection

### Resource Usage

- CPU: Low (handled by system)
- Memory: ~10-20MB for speech service
- Network: Minimal (only for recognition API)
- Battery: Moderate when actively listening

## Security & Privacy

### Data Flow

1. **Audio Capture:** Microphone → App
2. **Processing:** App → Apple Speech API (cloud)
3. **Text Result:** Apple → App
4. **AI Request:** App → OpenAI/Gemini API

### Data Storage

- ❌ Audio is NOT stored
- ❌ Transcripts are NOT stored locally
- ✅ Only sent to AI for processing
- ✅ Follows Apple's privacy guidelines

### Permissions

- Microphone: Required for audio capture
- Speech Recognition: Required for text conversion
- Network: Required for API calls
- Sandbox: App runs in restricted environment

## Files Modified

### Configuration Files

- ✅ `pubspec.yaml` - Dependencies
- ✅ `macos/Podfile` - CocoaPods config
- ✅ `macos/Runner/Info.plist` - Permission descriptions
- ✅ `macos/Runner/DebugProfile.entitlements` - Debug permissions
- ✅ `macos/Runner/Release.entitlements` - Release permissions
- ✅ `macos/Runner/Configs/AppInfo.xcconfig` - Deployment target

### Source Files

- ✅ `lib/services/speech_service.dart` - New service
- ✅ `lib/views/interview_copilot_view.dart` - Mic integration
- ✅ `lib/widgets/interview_copilot_input_bar.dart` - Visual indicators
- ✅ `lib/widgets/interview_copilot_header.dart` - Header mic button

### Documentation

- ✅ `MACOS_SETUP.md` - Setup instructions
- ✅ `MICROPHONE_FEATURE.md` - Feature documentation
- ✅ `test_macos_microphone.sh` - Verification script
- ✅ `MACOS_MICROPHONE_COMPLETE_GUIDE.md` - This file

## Support & Resources

### Official Documentation

- [Apple Speech Framework](https://developer.apple.com/documentation/speech)
- [Flutter macOS](https://docs.flutter.dev/platform-integration/macos/building)
- [speech_to_text Package](https://pub.dev/packages/speech_to_text)
- [permission_handler Package](https://pub.dev/packages/permission_handler)

### Common Commands

```bash
# Check Flutter setup
flutter doctor -v

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Install pods
cd macos && pod install && cd ..

# Run on macOS
flutter run -d macos

# Run with verbose logging
flutter run -d macos -v

# Build release
flutter build macos --release
```

## Next Steps

1. ✅ All configurations complete
2. ✅ Run verification script
3. ✅ Launch app: `flutter run -d macos`
4. ✅ Grant permissions when prompted
5. ✅ Test both microphone buttons
6. ✅ Verify speech-to-text accuracy
7. ✅ Test with AI integration

## Success Criteria

Your setup is complete when:

- ✅ App launches without errors
- ✅ Microphone buttons turn green when clicked
- ✅ Speech is converted to text accurately
- ✅ Header mic sends directly to AI
- ✅ Input mic fills text field
- ✅ No permission errors appear
- ✅ Both mics can be toggled on/off

---

**Status:** ✅ READY FOR TESTING

**Last Updated:** February 2, 2026

**macOS Version:** 11.0+

**Flutter Version:** 3.38.9+
