# ✅ FIXED: macOS Microphone Permissions

## What Was Wrong

The `permission_handler` package doesn't fully support macOS for checking permission status. It was throwing:

```
MissingPluginException(No implementation found for method checkPermissionStatus
on channel flutter.baseflow.com/permissions/methods)
```

## The Solution

The `speech_to_text` package **handles permissions internally** on macOS. We don't need `permission_handler` at all!

When you call `_speech.initialize()`, it automatically:

1. Checks if microphone permission is granted
2. Shows system dialog if not granted
3. Checks if speech recognition permission is granted
4. Shows system dialog if not granted
5. Returns `true` if both are granted, `false` otherwise

## What Changed

### 1. Removed `permission_handler` Dependency

**File: `pubspec.yaml`**

```yaml
dependencies:
  speech_to_text: ^7.0.0
  # permission_handler removed - not needed for macOS
```

### 2. Simplified `speech_service.dart`

**File: `lib/services/speech_service.dart`**

- Removed all `permission_handler` imports
- Removed manual permission checking
- Let `speech_to_text` handle everything
- Added better debug logging

## How to Use Now

### Step 1: Clean and Rebuild

```bash
flutter clean
flutter pub get
cd macos && pod install && cd ..
```

### Step 2: Run the App

```bash
flutter run -d macos -v
```

### Step 3: Click Microphone Button

When you click either microphone button for the **first time**:

1. **System dialog appears automatically:**

   ```
   "hexmac" would like to access the microphone.
   [Don't Allow] [OK]
   ```

   → Click **OK**

2. **Second dialog appears:**

   ```
   "hexmac" would like to use Speech Recognition.
   [Don't Allow] [OK]
   ```

   → Click **OK**

3. **Button turns green** and starts listening!

### Step 4: Verify in Console

You should see:

```
=== Starting Speech Service Initialization ===
Platform: macOS
Initializing speech recognition...
(System will request permissions if needed)
✅ Speech recognition initialized successfully
Available locales: 67
System locale: en_US
✅ Started listening...
```

## What If Permissions Are Denied?

### If You Clicked "Don't Allow"

The console will show:

```
❌ Failed to initialize speech recognition
Possible reasons:
  1. Microphone permission was denied
  2. Speech recognition permission was denied
  ...
```

**Fix:**

1. Open **System Settings**
2. Go to **Privacy & Security**
3. Click **Microphone** → Enable "hexmac"
4. Click **Speech Recognition** → Enable "hexmac"
5. Restart the app

### Reset Permissions to Test Again

```bash
# Reset to see dialogs again
tccutil reset Microphone
tccutil reset SpeechRecognition

# Restart app
flutter run -d macos
```

## Testing

### Test 1: First Launch (Fresh Permissions)

```bash
# Reset permissions
tccutil reset Microphone
tccutil reset SpeechRecognition

# Run app
flutter run -d macos -v

# Click mic button
# → System dialogs should appear
# → Grant both permissions
# → Button turns green
# → Speak and see text
```

### Test 2: Subsequent Launches

```bash
# Run app (permissions already granted)
flutter run -d macos

# Click mic button
# → No dialogs (already granted)
# → Button turns green immediately
# → Speak and see text
```

### Test 3: Denied Permissions

```bash
# In System Settings, disable microphone for hexmac
# Run app
flutter run -d macos -v

# Click mic button
# → Console shows error
# → Snackbar shows instructions
# → Button stays red
```

## Console Output Examples

### ✅ Success (Permissions Granted)

```
=== Starting Speech Service Initialization ===
Platform: macOS
Initializing speech recognition...
(System will request permissions if needed)
✅ Speech recognition initialized successfully
Available locales: 67
System locale: en_US
✅ Started listening...
Speech result: Hello (final: false)
Speech result: Hello world (final: false)
Speech result: Hello world (final: true)
Speech recognition status: done
```

### ❌ Failure (Permissions Denied)

```
=== Starting Speech Service Initialization ===
Platform: macOS
Initializing speech recognition...
(System will request permissions if needed)
❌ Failed to initialize speech recognition
Possible reasons:
  1. Microphone permission was denied
  2. Speech recognition permission was denied
  3. No microphone is connected
  4. Speech recognition is not available on this device

To fix:
  1. Check System Settings → Privacy & Security → Microphone
  2. Check System Settings → Privacy & Security → Speech Recognition
  3. Ensure "hexmac" is enabled in both sections
  4. Restart the app
```

## Files Modified

1. **`pubspec.yaml`** - Removed `permission_handler`
2. **`lib/services/speech_service.dart`** - Simplified to use only `speech_to_text`

## Files Still Needed

These are still required for macOS permissions:

1. ✅ `macos/Runner/Info.plist` - Permission descriptions
2. ✅ `macos/Runner/DebugProfile.entitlements` - Audio input entitlement
3. ✅ `macos/Runner/Release.entitlements` - Audio input entitlement
4. ✅ `macos/Podfile` - Deployment target 11.0

## Verification

Run the verification script:

```bash
./test_macos_microphone.sh
```

All checks should pass:

- ✅ macOS version 11.0+
- ✅ NSMicrophoneUsageDescription found
- ✅ NSSpeechRecognitionUsageDescription found
- ✅ Audio input entitlement found
- ✅ speech_to_text pod installed

## Summary

**Before:** Used `permission_handler` → MissingPluginException ❌

**After:** Use `speech_to_text` built-in permissions → Works perfectly ✅

The `speech_to_text` package is designed to handle macOS permissions natively. We don't need any additional permission packages!

## Quick Start

```bash
# 1. Clean rebuild
flutter clean && flutter pub get && cd macos && pod install && cd ..

# 2. Run
flutter run -d macos -v

# 3. Click microphone button

# 4. Grant permissions when dialogs appear

# 5. Start speaking!
```

That's it! The microphone should now work perfectly on macOS. 🎉
