# Fix: Microphone Permission Denied on macOS

## Problem

You're getting "Microphone permission denied" error when clicking the microphone button.

## Root Causes & Solutions

### Solution 1: Reset Permissions and Rebuild (RECOMMENDED)

This is the most common fix:

```bash
# 1. Reset TCC permissions
tccutil reset Microphone
tccutil reset SpeechRecognition

# 2. Clean Flutter build
flutter clean

# 3. Get dependencies
flutter pub get

# 4. Reinstall pods
cd macos && pod install && cd ..

# 5. Build and run
flutter run -d macos
```

When the app launches:

1. Click a microphone button
2. **IMPORTANT:** You should see a system dialog asking for microphone permission
3. Click **OK** (not "Don't Allow")
4. You may see a second dialog for speech recognition
5. Click **OK** again

### Solution 2: Check System Settings

If you accidentally clicked "Don't Allow":

1. Open **System Settings** (or **System Preferences** on older macOS)
2. Go to **Privacy & Security**
3. Click **Microphone** in the left sidebar
4. Look for **hexmac** in the list
5. Toggle it **ON** (checkmark should appear)
6. Also check **Speech Recognition** section
7. Restart the app

### Solution 3: Verify App Bundle

The permission dialog only appears if the app is properly built:

```bash
# Check if app bundle exists and has correct Info.plist
./check_permissions.sh
```

Look for:

- ✓ NSMicrophoneUsageDescription found
- ✓ NSSpeechRecognitionUsageDescription found
- ✓ Audio input entitlement found

If any are missing, rebuild:

```bash
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter run -d macos
```

### Solution 4: Check Console Logs

Run with verbose logging to see what's happening:

```bash
flutter run -d macos -v
```

Look for these debug messages:

```
=== Starting Speech Service Initialization ===
Platform: macOS detected
Microphone permission status: ...
Requesting microphone permission...
```

If you see:

- `❌ Microphone permission denied` - Permission was denied
- `✅ All permissions granted` - Permissions are OK
- No messages at all - Service isn't initializing

### Solution 5: Manual Permission Grant

If the system dialog never appears:

1. **Quit the app completely**
2. Open **Terminal**
3. Run:
   ```bash
   tccutil reset Microphone
   tccutil reset SpeechRecognition
   ```
4. **Delete the app bundle:**
   ```bash
   rm -rf build/macos/Build/Products/Debug/hexmac.app
   ```
5. **Rebuild from scratch:**
   ```bash
   flutter clean
   flutter pub get
   cd macos && pod install && cd ..
   flutter run -d macos
   ```
6. When app launches, click microphone button
7. System dialog **MUST** appear now

### Solution 6: Check for Multiple App Instances

Sometimes old instances prevent permission dialogs:

```bash
# Kill all instances
pkill -9 hexmac

# Check if any are still running
pgrep hexmac

# If nothing returns, you're good
# Now run the app again
flutter run -d macos
```

### Solution 7: Verify Entitlements in Built App

Check if the built app has the correct entitlements:

```bash
# Build the app first
flutter build macos --debug

# Check entitlements
codesign -d --entitlements - build/macos/Build/Products/Debug/hexmac.app

# You should see:
# <key>com.apple.security.device.audio-input</key>
# <true/>
```

If not present, the entitlements file isn't being applied. Check:

- `macos/Runner/DebugProfile.entitlements`
- `macos/Runner/Release.entitlements`

Both should have:

```xml
<key>com.apple.security.device.audio-input</key>
<true/>
```

### Solution 8: Check macOS Version

Speech recognition requires macOS 11.0 (Big Sur) or later:

```bash
sw_vers -productVersion
```

If you're on 10.15 or earlier, you need to update macOS.

### Solution 9: Disable and Re-enable SIP (Advanced)

⚠️ **Only if nothing else works:**

1. Restart Mac in Recovery Mode (hold Cmd+R during boot)
2. Open Terminal from Utilities menu
3. Run: `csrutil disable`
4. Restart Mac
5. Run the app and grant permissions
6. Restart in Recovery Mode again
7. Run: `csrutil enable`
8. Restart Mac

### Solution 10: Create New Build Configuration

If the app was built before adding permissions:

```bash
# Remove all build artifacts
rm -rf build/
rm -rf macos/Pods/
rm -rf macos/Podfile.lock
rm -rf .dart_tool/

# Rebuild everything
flutter clean
flutter pub get
cd macos && pod install && cd ..

# Build fresh
flutter run -d macos
```

## Verification Steps

After trying any solution:

1. **Check logs when clicking mic button:**

   ```
   === Starting Speech Service Initialization ===
   Platform: macOS detected
   Microphone permission status: PermissionStatus.granted
   ✅ All permissions granted
   ```

2. **Button should turn green** when clicked

3. **White dot should appear** indicating listening

4. **Speak and see text appear** (for input mic) or send to AI (for header mic)

## Still Not Working?

### Debug Checklist

Run through this checklist:

```bash
# 1. Check macOS version (must be 11.0+)
sw_vers -productVersion

# 2. Check if microphone works in other apps
# Open Voice Memos and try recording

# 3. Check system microphone
system_profiler SPAudioDataType | grep "Input"

# 4. Verify Flutter setup
flutter doctor -v

# 5. Check app bundle
./check_permissions.sh

# 6. Check for errors
flutter run -d macos -v 2>&1 | grep -i "permission\|microphone\|speech"
```

### Get Detailed Logs

Add this to see exactly what's happening:

1. Run: `flutter run -d macos -v`
2. Click microphone button
3. Copy all output
4. Look for lines containing:
   - "permission"
   - "microphone"
   - "speech"
   - "denied"
   - "granted"

### Common Error Messages

**"Microphone permission denied"**

- Solution: Reset permissions (Solution 1)

**"Speech recognition permission denied"**

- Solution: Enable in System Settings → Privacy → Speech Recognition

**"Speech recognition not available"**

- Check internet connection (required for speech recognition)
- Check if Siri is enabled (uses same engine)

**No error, but button stays red**

- Check console logs for initialization errors
- Verify microphone is connected and working

## Prevention

To avoid this issue in the future:

1. **Always grant permissions** when system asks
2. **Don't click "Don't Allow"** - it's hard to undo
3. **Check System Settings** before reporting issues
4. **Keep macOS updated** to latest version
5. **Run verification script** after any changes: `./test_macos_microphone.sh`

## Quick Fix Command

Try this one-liner first:

```bash
tccutil reset Microphone && tccutil reset SpeechRecognition && flutter clean && flutter pub get && cd macos && pod install && cd .. && flutter run -d macos
```

This will:

1. Reset permissions
2. Clean build
3. Get dependencies
4. Install pods
5. Run the app

Then click the microphone button and grant permissions when asked.

## Success Indicators

You'll know it's working when:

- ✅ System dialog appears asking for microphone access
- ✅ Button turns green when clicked
- ✅ White dot appears on button
- ✅ Console shows: "✅ All permissions granted"
- ✅ Speech is converted to text
- ✅ No error messages in console

## Need More Help?

If none of these solutions work:

1. Run: `./check_permissions.sh` and share output
2. Run: `flutter run -d macos -v` and share logs
3. Check System Settings → Privacy & Security → Microphone
4. Verify microphone works in Voice Memos app
5. Check if you're running in a VM (permissions may not work)

---

**Most Common Solution:** Solution 1 (Reset & Rebuild) works 90% of the time!
