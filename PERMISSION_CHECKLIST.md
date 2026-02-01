# Permission Checklist - Microphone + Speech Recognition

## ✅ Pre-Flight Checklist

Before running your app, verify all permissions are properly configured:

### 1. Info.plist Configuration

- [ ] `NSMicrophoneUsageDescription` is present
- [ ] `NSSpeechRecognitionUsageDescription` is present
- [ ] Both have user-friendly descriptions

**Verify**:

```bash
grep -A 1 "NSMicrophoneUsageDescription\|NSSpeechRecognitionUsageDescription" macos/Runner/Info.plist
```

### 2. Entitlements Configuration

- [ ] `com.apple.security.device.audio-input` in DebugProfile.entitlements
- [ ] `com.apple.security.device.audio-input` in Release.entitlements

**Verify**:

```bash
grep "audio-input" macos/Runner/*.entitlements
```

### 3. Native Swift Implementation

- [ ] `import AVFoundation` in AppDelegate.swift
- [ ] `import Speech` in AppDelegate.swift
- [ ] Method channel `com.hexmac/permissions` created
- [ ] `requestMicrophonePermission()` implemented
- [ ] `requestSpeechRecognitionPermission()` implemented
- [ ] `requestAllPermissions()` implemented

**Verify**:

```bash
grep "import AVFoundation\|import Speech\|requestAllPermissions" macos/Runner/AppDelegate.swift
```

### 4. Dart Permission Service

- [ ] `lib/services/permission_service.dart` exists
- [ ] Method channel matches: `com.hexmac/permissions`
- [ ] `requestMicrophonePermission()` method exists
- [ ] `requestSpeechRecognitionPermission()` method exists
- [ ] `requestAllPermissions()` method exists
- [ ] `hasAllPermissions()` method exists

**Verify**:

```bash
ls -la lib/services/permission_service.dart
```

### 5. App Initialization

- [ ] `WidgetsFlutterBinding.ensureInitialized()` called in main()
- [ ] `PermissionService.requestAllPermissions()` called before runApp()
- [ ] Only runs on macOS platform

**Verify**:

```bash
grep "PermissionService.requestAllPermissions" lib/main.dart
```

### 6. View Integration

- [ ] `PermissionService` imported in interview_copilot_view.dart
- [ ] `_checkPermissionsAndInitializeSpeech()` method exists
- [ ] Permissions checked before initializing speech service
- [ ] Dialog shown if permissions denied

**Verify**:

```bash
grep "PermissionService\|_checkPermissionsAndInitializeSpeech" lib/views/interview_copilot_view.dart
```

---

## 🧪 Testing Checklist

### First Launch Test

- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run `cd macos && pod install && cd ..`
- [ ] Run `flutter run -d macos`
- [ ] **Dialog 1 appears**: Microphone permission
- [ ] Click **OK** on microphone dialog
- [ ] **Dialog 2 appears**: Speech recognition permission
- [ ] Click **OK** on speech recognition dialog
- [ ] App continues loading without crash
- [ ] App UI appears correctly
- [ ] No error dialogs shown

### Speech Feature Test

- [ ] Click microphone button in header
- [ ] Microphone icon changes to indicate listening
- [ ] Speak a test phrase
- [ ] Speech is converted to text
- [ ] Text appears in the chat
- [ ] AI responds to the question

### Permission Denial Test

- [ ] Reset permissions: `tccutil reset Microphone com.example.hexmac`
- [ ] Reset permissions: `tccutil reset SpeechRecognition com.example.hexmac`
- [ ] Run app again
- [ ] Click **Don't Allow** on microphone dialog
- [ ] App continues loading (no crash)
- [ ] Dialog appears explaining permissions needed
- [ ] Instructions are clear and helpful

### System Settings Verification

- [ ] Open System Settings
- [ ] Go to Privacy & Security → Microphone
- [ ] "hexmac" is listed
- [ ] "hexmac" is enabled (toggle on)
- [ ] Go to Privacy & Security → Speech Recognition
- [ ] "hexmac" is listed
- [ ] "hexmac" is enabled (toggle on)

---

## 🔍 Debug Checklist

### Console Output Verification

When you run the app, you should see these logs:

- [ ] `=== Requesting macOS Permissions ===`
- [ ] `Microphone: authorized` (or denied/notDetermined)
- [ ] `Speech Recognition: authorized` (or denied/notDetermined)
- [ ] `All Granted: true` (or false)
- [ ] `Checking permissions before initializing speech...`
- [ ] `✅ Speech service initialized successfully`

### If Permissions Denied

- [ ] `Permissions not granted, requesting...`
- [ ] Dialog shown with instructions
- [ ] App doesn't crash
- [ ] Speech features disabled gracefully

### If Permissions Granted

- [ ] `=== Starting Speech Service Initialization ===`
- [ ] `Initializing speech recognition...`
- [ ] `✅ Speech recognition initialized successfully`
- [ ] `Available locales: [number]`

---

## 🚨 Troubleshooting Checklist

### App Crashes on Launch

- [ ] Check both permissions are granted in System Settings
- [ ] Run `flutter clean`
- [ ] Delete app from Applications folder
- [ ] Rebuild: `flutter run -d macos`
- [ ] Check Console.app for crash logs

### Only One Permission Dialog Appears

- [ ] Verify both permissions in Info.plist
- [ ] Check AppDelegate.swift has both request methods
- [ ] Ensure `requestAllPermissions()` calls both
- [ ] Look for errors in console output

### No Permission Dialogs Appear

- [ ] Permissions may already be granted
- [ ] Check System Settings → Privacy & Security
- [ ] Reset permissions with `tccutil reset`
- [ ] Verify Info.plist has usage descriptions
- [ ] Check bundle identifier matches

### Speech Recognition Not Working

- [ ] Both permissions granted in System Settings
- [ ] Microphone is connected and working
- [ ] Check console for error messages
- [ ] Verify speech_to_text package is installed
- [ ] Try restarting the app

### Method Channel Errors

- [ ] Channel name matches: `com.hexmac/permissions`
- [ ] AppDelegate.swift compiled successfully
- [ ] Pod install completed without errors
- [ ] Flutter and Xcode versions compatible

---

## ✅ Final Verification

Run the automated verification script:

```bash
./verify_permissions.sh
```

You should see all ✅ checkmarks. If you see any ❌, fix those issues before running the app.

---

## 📊 Permission Status Reference

| Status          | Meaning                   | Action                |
| --------------- | ------------------------- | --------------------- |
| `authorized`    | Permission granted        | ✅ Can use feature    |
| `denied`        | User denied permission    | ❌ Show instructions  |
| `restricted`    | System policy restriction | ❌ Cannot use feature |
| `notDetermined` | Not yet requested         | ⏳ Request permission |

---

## 🎯 Success Criteria

Your app is working correctly when:

✅ App launches without crashing
✅ Two permission dialogs appear on first launch
✅ Both permissions can be granted
✅ Speech-to-text features work after granting permissions
✅ App handles permission denial gracefully
✅ Clear feedback provided to users
✅ No errors in console logs

---

## 📞 Need Help?

If you've gone through this checklist and still have issues:

1. Run `./verify_permissions.sh` and share the output
2. Check Console.app for error messages
3. Share the console output from `flutter run -d macos`
4. Verify your Flutter and Xcode versions
5. Check the documentation files:
   - `BOTH_PERMISSIONS_GUIDE.md`
   - `PERMISSION_SOLUTION_SUMMARY.md`
   - `PERMISSION_FLOW_DIAGRAM.md`
