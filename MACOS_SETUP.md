# macOS Setup Guide for Speech Recognition

## Prerequisites

- macOS 10.15 (Catalina) or later
- Xcode 12.0 or later
- Flutter SDK installed

## Required Permissions

### 1. Info.plist Configuration ✅

Located at: `macos/Runner/Info.plist`

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to the microphone for speech-to-text functionality during interviews.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs access to speech recognition to convert your voice to text.</string>
```

### 2. Entitlements Configuration ✅

**Debug Profile** (`macos/Runner/DebugProfile.entitlements`):

```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

**Release Profile** (`macos/Runner/Release.entitlements`):

```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

### 3. Podfile Configuration ✅

Located at: `macos/Podfile`

Minimum platform version: `platform :osx, '10.15'`

## Installation Steps

### Step 1: Clean Previous Builds

```bash
flutter clean
cd macos
rm -rf Pods Podfile.lock
cd ..
```

### Step 2: Get Dependencies

```bash
flutter pub get
```

### Step 3: Install CocoaPods

```bash
cd macos
pod install
cd ..
```

### Step 4: Build and Run

```bash
flutter run -d macos
```

## First Run - Permission Prompts

When you first run the app and click a microphone button, macOS will show permission dialogs:

1. **Microphone Access**
   - Dialog: "hexmac would like to access the microphone"
   - Click: **Allow**

2. **Speech Recognition**
   - Dialog: "hexmac would like to use Speech Recognition"
   - Click: **OK**

## System Preferences

If you accidentally denied permissions, you can enable them manually:

### Enable Microphone Access

1. Open **System Preferences** (or **System Settings** on macOS 13+)
2. Go to **Security & Privacy** → **Privacy** → **Microphone**
3. Find **hexmac** in the list
4. Check the box to enable microphone access

### Enable Speech Recognition

1. Open **System Preferences** (or **System Settings** on macOS 13+)
2. Go to **Security & Privacy** → **Privacy** → **Speech Recognition**
3. Find **hexmac** in the list
4. Check the box to enable speech recognition

## Testing the Microphone

### Test Header Microphone (Direct Send)

1. Launch the app
2. Click the microphone button in the **header** (top bar)
3. Button should turn **GREEN** with a white dot
4. Speak: "What is a goroutine in golang?"
5. Stop speaking (wait 3 seconds)
6. Message should automatically send to AI

### Test Input Microphone (Text Field)

1. Click the microphone button in the **input bar** (bottom)
2. Button should turn **GREEN** with a white dot
3. Speak: "Explain closures in JavaScript"
4. Text should appear in the input field
5. Edit if needed, then click send

## Troubleshooting

### Issue: Permission Denied Error

**Solution:**

- Check System Preferences → Security & Privacy → Privacy
- Enable Microphone and Speech Recognition for hexmac
- Restart the app

### Issue: Microphone Button Stays Red

**Solution:**

- Verify microphone is connected and working
- Test microphone in another app (e.g., Voice Memos)
- Check System Preferences permissions
- Restart the app

### Issue: No Speech Recognition

**Solution:**

- Ensure you have internet connection (required for speech recognition)
- Check if Siri is enabled (uses same speech engine)
- Go to System Preferences → Siri → Enable Siri
- Restart the app

### Issue: Build Errors

**Solution:**

```bash
# Clean everything
flutter clean
cd macos
rm -rf Pods Podfile.lock
pod deintegrate
pod install
cd ..

# Rebuild
flutter pub get
flutter run -d macos
```

### Issue: "Unsupported macOS version"

**Solution:**

- Ensure you're running macOS 10.15 or later
- Update Xcode to latest version
- Check `macos/Runner/Configs/AppInfo.xcconfig` for deployment target

## Development Tips

### Debug Mode

Run with verbose logging to see speech recognition events:

```bash
flutter run -d macos -v
```

### Check Microphone Status

The app shows visual indicators:

- 🔴 **Red Button** = Microphone OFF
- 🟢 **Green Button** = Microphone ON
- ⚪ **White Dot** = Actively listening

### Speech Recognition Limits

- Maximum listening duration: 30 seconds
- Auto-stop after: 3 seconds of silence
- Requires internet connection
- Uses Apple's Speech Recognition API

## Performance Notes

### First Launch

- May take a few seconds to initialize speech recognition
- Permission dialogs will appear
- Subsequent launches are faster

### Speech Recognition Accuracy

- Works best in quiet environments
- Speak clearly and at normal pace
- Supports multiple languages (based on system language)
- Accuracy improves with use

## Security & Privacy

### Data Handling

- Speech is processed by Apple's servers
- No audio is stored by the app
- Transcribed text is sent to OpenAI/Gemini APIs
- Follow your organization's data privacy policies

### Sandbox Restrictions

- App runs in macOS sandbox for security
- Only has access to granted permissions
- Cannot access files outside app container
- Network access limited to API endpoints

## Additional Resources

- [Apple Speech Framework Documentation](https://developer.apple.com/documentation/speech)
- [Flutter macOS Setup](https://docs.flutter.dev/platform-integration/macos/building)
- [speech_to_text Package](https://pub.dev/packages/speech_to_text)

## Support

If you encounter issues:

1. Check this guide's troubleshooting section
2. Verify all permissions are granted
3. Check console logs for error messages
4. Ensure macOS and Xcode are up to date
