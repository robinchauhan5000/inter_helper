# macOS Permissions - Complete Guide

## 🎯 Overview

Your app now properly requests **BOTH** required permissions for speech-to-text functionality:

1. **🎤 Microphone Permission** - To capture audio input
2. **🗣️ Speech Recognition Permission** - To convert speech to text

Both permissions are requested **proactively** on app launch, preventing crashes and providing a smooth user experience.

---

## 🚀 Quick Start

```bash
# Run the app
flutter run -d macos

# You'll see TWO permission dialogs:
# 1. Microphone access → Click OK
# 2. Speech recognition → Click OK
# 3. App works! 🎉
```

---

## 📚 Documentation Files

### Getting Started

- **`QUICK_FIX_REFERENCE.md`** - Quick reference card (start here!)
- **`BOTH_PERMISSIONS_GUIDE.md`** - Detailed guide about both permissions
- **`NEXT_STEPS.md`** - Testing instructions

### Technical Details

- **`PERMISSION_SOLUTION_SUMMARY.md`** - Complete technical overview
- **`PERMISSION_FIX.md`** - Implementation details
- **`PERMISSION_FLOW_DIAGRAM.md`** - Visual flow diagrams

### Verification & Testing

- **`PERMISSION_CHECKLIST.md`** - Complete checklist for verification
- **`verify_permissions.sh`** - Automated verification script
- **`test_build.sh`** - Build and test script

---

## ✅ What's Included

### Native macOS Layer (Swift)

- ✅ Method channel: `com.hexmac/permissions`
- ✅ Microphone permission handling (`AVFoundation`)
- ✅ Speech recognition permission handling (`Speech` framework)
- ✅ Combined permission request method
- ✅ Permission status checking

### Dart Layer

- ✅ `PermissionService` - Clean API for permission handling
- ✅ Platform-aware (macOS only)
- ✅ Method channel communication
- ✅ Status checking and requesting

### App Integration

- ✅ Permissions requested on app startup
- ✅ Checked before initializing speech service
- ✅ Graceful error handling
- ✅ User-friendly feedback dialogs

### Configuration

- ✅ Info.plist usage descriptions
- ✅ Entitlements for audio input
- ✅ Proper framework imports

---

## 🧪 Verification

Run the automated verification:

```bash
./verify_permissions.sh
```

Expected output: All ✅ checkmarks

---

## 📋 The Two Permissions Explained

### 1. Microphone Permission (NSMicrophoneUsageDescription)

**What it does**: Allows the app to access the microphone hardware

**Framework**: `AVFoundation` / `AVCaptureDevice`

**Dialog text**: "hexmac would like to access the microphone"

**Usage description**: "This app needs access to the microphone for speech-to-text functionality during interviews."

**Without it**: Cannot capture audio input

### 2. Speech Recognition Permission (NSSpeechRecognitionUsageDescription)

**What it does**: Allows the app to use Apple's speech recognition service

**Framework**: `Speech` / `SFSpeechRecognizer`

**Dialog text**: "hexmac would like to use speech recognition"

**Usage description**: "This app needs access to speech recognition to convert your voice to text."

**Without it**: Cannot convert speech to text

### Why Both Are Required

```
Audio Input (Microphone)
         ↓
    [Your App]
         ↓
Speech Recognition Service
         ↓
    Text Output
```

You need:

- **Microphone** to capture the audio
- **Speech Recognition** to process it into text

If either is denied, speech-to-text won't work!

---

## 🔄 Permission Flow

```
App Launch
    ↓
main.dart: PermissionService.requestAllPermissions()
    ↓
Method Channel: com.hexmac/permissions
    ↓
AppDelegate.swift: requestAllPermissions()
    ↓
AVCaptureDevice.requestAccess(for: .audio)
    ↓
[Dialog 1: Microphone] → User clicks OK
    ↓
SFSpeechRecognizer.requestAuthorization()
    ↓
[Dialog 2: Speech Recognition] → User clicks OK
    ↓
Return to Dart: { microphone: "authorized", speechRecognition: "authorized", allGranted: true }
    ↓
runApp(const MyApp())
    ↓
InterviewCopilotView: Check permissions
    ↓
Initialize Speech Service
    ↓
✅ Ready to use!
```

---

## 🎯 Testing Scenarios

### Scenario 1: First Launch (Happy Path)

1. User launches app
2. Microphone dialog appears → User clicks OK
3. Speech recognition dialog appears → User clicks OK
4. App loads successfully
5. Speech features work ✅

### Scenario 2: Permission Denied

1. User launches app
2. Microphone dialog appears → User clicks Don't Allow
3. App continues loading (no crash)
4. Dialog shows instructions for enabling permissions
5. Speech features disabled but app usable ✅

### Scenario 3: Subsequent Launches

1. User launches app (permissions already granted)
2. No dialogs appear
3. App loads immediately
4. Speech features work ✅

---

## 🐛 Troubleshooting

### Problem: App crashes on launch

**Solution**:

```bash
flutter clean
flutter run -d macos
```

Grant both permissions when prompted.

### Problem: Only one dialog appears

**Solution**:

- The second dialog appears after granting the first
- Wait a moment after clicking OK on the first dialog
- Check console logs for errors

### Problem: No dialogs appear

**Solution**:

- Permissions may already be granted
- Check System Settings → Privacy & Security
- Reset permissions:
  ```bash
  tccutil reset Microphone com.example.hexmac
  tccutil reset SpeechRecognition com.example.hexmac
  ```

### Problem: Speech not working after granting permissions

**Solution**:

1. Verify both permissions in System Settings
2. Restart the app
3. Check console logs for errors
4. Verify microphone is connected and working

---

## 📍 Where to Find Things

### Configuration Files

- `macos/Runner/Info.plist` - Permission descriptions
- `macos/Runner/DebugProfile.entitlements` - Debug entitlements
- `macos/Runner/Release.entitlements` - Release entitlements

### Native Code

- `macos/Runner/AppDelegate.swift` - Permission handling

### Dart Code

- `lib/services/permission_service.dart` - Permission service
- `lib/main.dart` - App initialization
- `lib/views/interview_copilot_view.dart` - Permission checking

### Documentation

- All `*.md` files in the root directory

---

## ✨ Key Features

✅ **Proactive Permission Requests** - Before attempting to use features
✅ **No Crashes** - Graceful handling of denied permissions
✅ **Clear Feedback** - User-friendly dialogs and instructions
✅ **Native Integration** - Proper use of Apple's APIs
✅ **Debug Logging** - Detailed console output for troubleshooting
✅ **Platform Aware** - Only runs on macOS
✅ **Both Permissions** - Microphone + Speech Recognition

---

## 🎓 Learn More

### Apple Documentation

- [Requesting Authorization for Media Capture](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/requesting_authorization_for_media_capture_on_macos)
- [Speech Recognition](https://developer.apple.com/documentation/speech)

### Flutter Documentation

- [Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [macOS Permissions](https://docs.flutter.dev/development/platform-integration/macos/permissions)

---

## 🎉 Success!

Your app is now properly configured to request both microphone and speech recognition permissions on macOS. Run the app and enjoy crash-free speech-to-text functionality!

```bash
flutter run -d macos
```

**Remember**: Click OK on BOTH permission dialogs! 🎤 🗣️
