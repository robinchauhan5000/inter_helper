# Both Permissions Guide - Microphone + Speech Recognition

## ✅ Your App is Already Configured for BOTH Permissions!

The solution I implemented handles **both** permissions that are required for speech-to-text functionality on macOS:

1. **🎤 Microphone Permission** - To capture audio
2. **🗣️ Speech Recognition Permission** - To convert speech to text

---

## What Happens When You Launch the App

### Step-by-Step Flow

```
1. App Launches
   ↓
2. First Dialog Appears:
   ┌─────────────────────────────────────────────────────┐
   │  "hexmac" would like to access the microphone.      │
   │                                                     │
   │  This app needs access to the microphone for       │
   │  speech-to-text functionality during interviews.   │
   │                                                     │
   │              [Don't Allow]  [OK]                   │
   └─────────────────────────────────────────────────────┘
   ↓ Click OK

3. Second Dialog Appears:
   ┌─────────────────────────────────────────────────────┐
   │  "hexmac" would like to use speech recognition.     │
   │                                                     │
   │  This app needs access to speech recognition to    │
   │  convert your voice to text.                       │
   │                                                     │
   │              [Don't Allow]  [OK]                   │
   └─────────────────────────────────────────────────────┘
   ↓ Click OK

4. App Continues Loading
   ↓
5. ✅ Speech-to-Text Features Work!
```

---

## How It's Implemented

### 1. Info.plist (Permission Descriptions)

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to the microphone for speech-to-text functionality during interviews.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs access to speech recognition to convert your voice to text.</string>
```

### 2. AppDelegate.swift (Native Permission Handling)

```swift
import AVFoundation  // For microphone
import Speech        // For speech recognition

// Request microphone permission
AVCaptureDevice.requestAccess(for: .audio) { granted in
    // Handle result
}

// Request speech recognition permission
SFSpeechRecognizer.requestAuthorization { status in
    // Handle result
}

// Request BOTH at once
func requestAllPermissions(result: @escaping FlutterResult) {
    // First request microphone
    AVCaptureDevice.requestAccess(for: .audio) { micGranted in
        // Then request speech recognition
        SFSpeechRecognizer.requestAuthorization { speechStatus in
            // Return both results
        }
    }
}
```

### 3. main.dart (Request on Startup)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request BOTH permissions before starting the app
  if (macOS) {
    final permissions = await PermissionService.requestAllPermissions();
    // Returns:
    // {
    //   'microphone': 'authorized',
    //   'speechRecognition': 'authorized',
    //   'allGranted': true
    // }
  }

  runApp(const MyApp());
}
```

---

## Verification

Run the verification script to confirm everything is configured:

```bash
./verify_permissions.sh
```

You should see all ✅ checkmarks for:

- Microphone permission description
- Speech Recognition permission description
- Audio input entitlements
- Native permission methods
- Dart permission service
- Startup initialization

---

## Testing

### Test Both Permissions

1. **Clean build**:

   ```bash
   flutter clean
   flutter pub get
   cd macos && pod install && cd ..
   ```

2. **Run the app**:

   ```bash
   flutter run -d macos
   ```

3. **Grant both permissions**:
   - Click **OK** on microphone dialog
   - Click **OK** on speech recognition dialog

4. **Test speech-to-text**:
   - Click the microphone button
   - Speak something
   - Your speech should be converted to text ✅

---

## Checking Permissions Manually

### System Settings

1. Open **System Settings**
2. Go to **Privacy & Security**
3. Check **Microphone**:
   - "hexmac" should be listed and enabled ✅
4. Check **Speech Recognition**:
   - "hexmac" should be listed and enabled ✅

### Command Line

```bash
# Check microphone permission
tccutil reset Microphone com.example.hexmac

# Check speech recognition permission
tccutil reset SpeechRecognition com.example.hexmac
```

---

## Troubleshooting

### Only One Dialog Appears

If you only see the microphone dialog:

- The speech recognition dialog appears **after** you grant microphone permission
- Make sure you click **OK** on the first dialog
- Wait a moment for the second dialog to appear

### No Dialogs Appear

If no dialogs appear:

- Permissions may already be granted
- Check System Settings → Privacy & Security
- Reset permissions using `tccutil reset` commands above
- Run the app again

### Speech Not Working After Granting Permissions

1. **Verify both permissions are granted**:

   ```bash
   ./verify_permissions.sh
   ```

2. **Check System Settings**:
   - Privacy & Security → Microphone → hexmac ✅
   - Privacy & Security → Speech Recognition → hexmac ✅

3. **Restart the app**:

   ```bash
   flutter run -d macos
   ```

4. **Check console logs**:
   Look for:
   ```
   === Requesting macOS Permissions ===
   Microphone: authorized
   Speech Recognition: authorized
   All Granted: true
   ```

---

## Why Both Permissions Are Needed

### Microphone Permission

- **Purpose**: Capture audio input from your microphone
- **Used by**: `AVCaptureDevice` / `AVFoundation`
- **Without it**: Can't record audio

### Speech Recognition Permission

- **Purpose**: Process audio and convert speech to text
- **Used by**: `SFSpeechRecognizer` / `Speech` framework
- **Without it**: Can't convert speech to text

### Both Required

Your app needs **BOTH** permissions because:

1. Microphone captures the audio
2. Speech Recognition processes the audio into text

If either permission is denied, speech-to-text won't work!

---

## Summary

✅ **Microphone Permission** - Configured and requested
✅ **Speech Recognition Permission** - Configured and requested
✅ **Both requested on startup** - No crashes
✅ **Graceful error handling** - Clear feedback if denied
✅ **Proper native implementation** - Uses Apple's APIs correctly

Your app is fully configured to request and handle both permissions properly. Just run it and grant both permissions when prompted!

---

## Quick Reference

| Permission         | Framework    | Method                                    | Status         |
| ------------------ | ------------ | ----------------------------------------- | -------------- |
| Microphone         | AVFoundation | `AVCaptureDevice.requestAccess`           | ✅ Implemented |
| Speech Recognition | Speech       | `SFSpeechRecognizer.requestAuthorization` | ✅ Implemented |
| Both at once       | Custom       | `requestAllPermissions()`                 | ✅ Implemented |

**Run the app now and you'll see both permission dialogs!** 🎉
