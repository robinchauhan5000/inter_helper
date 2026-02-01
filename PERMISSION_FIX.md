# macOS Permission Fix

## Problem

The app was crashing on initial launch because it attempted to use the microphone before permissions were granted. After reopening, permissions were available and the app worked correctly.

## Solution

Implemented a proactive permission request system that asks for permissions **before** attempting to use the microphone or speech recognition.

## Changes Made

### 1. Native macOS Permission Handler (`macos/Runner/AppDelegate.swift`)

- Added method channel `com.hexmac/permissions`
- Implemented native Swift methods to:
  - Check microphone permission status
  - Request microphone permission
  - Check speech recognition permission status
  - Request speech recognition permission
  - Request all permissions at once

### 2. Dart Permission Service (`lib/services/permission_service.dart`)

- Created a new service to communicate with the native permission handler
- Provides methods to:
  - Check individual permission statuses
  - Request individual permissions
  - Request all permissions at once
  - Check if all required permissions are granted

### 3. App Initialization (`lib/main.dart`)

- Added `WidgetsFlutterBinding.ensureInitialized()` to ensure Flutter is ready
- Request all permissions on macOS **before** starting the app
- Logs permission status for debugging

### 4. View Updates (`lib/views/interview_copilot_view.dart`)

- Modified initialization flow to check permissions before initializing speech service
- Added `_checkPermissionsAndInitializeSpeech()` method
- Shows a clear dialog if permissions are denied with instructions
- Prevents crashes by ensuring permissions are granted before using speech features

### 5. Speech Service Fix (`lib/services/speech_service.dart`)

- Fixed deprecated parameter warnings
- Updated to use `SpeechListenOptions` instead of deprecated parameters

## How It Works

1. **App Launch**: When the app starts, it immediately requests microphone and speech recognition permissions
2. **Permission Dialogs**: macOS shows system permission dialogs for both microphone and speech recognition
3. **Permission Check**: Before initializing the speech service, the app verifies permissions are granted
4. **Graceful Handling**: If permissions are denied, the app shows a helpful dialog instead of crashing

## Testing

To test the fix:

1. Clean build and run:

   ```bash
   flutter clean
   flutter pub get
   cd macos
   pod install
   cd ..
   flutter run -d macos
   ```

2. On first launch, you should see permission dialogs immediately
3. Grant both microphone and speech recognition permissions
4. The app should start without crashing

## Permissions Required

The app requires two permissions on macOS:

- **Microphone**: To capture audio input
- **Speech Recognition**: To convert speech to text

Both are configured in:

- `macos/Runner/Info.plist` (usage descriptions)
- `macos/Runner/DebugProfile.entitlements` (sandbox permissions)
- `macos/Runner/Release.entitlements` (sandbox permissions)
