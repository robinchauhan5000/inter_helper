# Next Steps - Testing the Permission Fix

## What Was Fixed

Your app was crashing on initial launch because it tried to use the microphone before permissions were granted. I've implemented a complete solution that:

1. **Requests permissions proactively** - Before the app tries to use the microphone
2. **Uses native macOS APIs** - Proper Swift implementation for permission handling
3. **Provides clear feedback** - Shows helpful dialogs if permissions are denied
4. **Prevents crashes** - Checks permissions before initializing speech services

## How to Test

### Option 1: Quick Test

```bash
flutter run -d macos
```

### Option 2: Full Clean Build

```bash
./test_build.sh
```

Or manually:

```bash
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter run -d macos
```

## What to Expect

1. **First Launch**:
   - App will immediately show macOS permission dialogs
   - First dialog: Microphone access
   - Second dialog: Speech recognition
   - Click "OK" or "Allow" on both

2. **After Granting Permissions**:
   - App should start normally without crashing
   - Speech-to-text features will work
   - Microphone button will function properly

3. **If Permissions Denied**:
   - App will show a helpful dialog with instructions
   - App won't crash, but speech features won't work
   - You can grant permissions later in System Settings

## Verifying the Fix

To verify permissions are working:

1. Launch the app
2. Click the microphone button in the header or input bar
3. Speak something
4. Your speech should be converted to text

## Resetting Permissions (for testing)

If you want to test the permission flow again:

```bash
# Reset permissions for your app
tccutil reset Microphone com.example.hexmac
tccutil reset SpeechRecognition com.example.hexmac

# Then run the app again
flutter run -d macos
```

## Files Changed

- `macos/Runner/AppDelegate.swift` - Added native permission handling
- `lib/services/permission_service.dart` - New Dart service for permissions
- `lib/main.dart` - Request permissions on app startup
- `lib/views/interview_copilot_view.dart` - Check permissions before using speech
- `lib/services/speech_service.dart` - Fixed deprecated warnings
- `lib/services/services.dart` - Export new permission service

## Troubleshooting

### If the app still crashes:

1. Make sure you granted both permissions
2. Try restarting the app
3. Check Console.app for error messages
4. Verify permissions in System Settings → Privacy & Security

### If permissions aren't requested:

1. Run `flutter clean`
2. Delete the app from Applications
3. Rebuild and run again

### If you see "Method not implemented":

1. Make sure you ran `pod install` in the macos directory
2. Try rebuilding: `flutter clean && flutter run -d macos`

## Need Help?

Check the logs in the console - the app prints detailed debug information about:

- Permission status checks
- Permission requests
- Speech service initialization
- Any errors that occur

Look for lines starting with:

- `=== Requesting macOS Permissions ===`
- `Checking permissions before initializing speech...`
- `✅ Speech service initialized successfully`
