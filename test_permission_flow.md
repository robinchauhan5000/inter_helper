# Test Permission Flow - Step by Step

## Before You Start

1. **Reset permissions** (to simulate first-time user):

   ```bash
   tccutil reset Microphone
   tccutil reset SpeechRecognition
   ```

2. **Rebuild the app**:
   ```bash
   flutter clean
   flutter pub get
   cd macos && pod install && cd ..
   ```

## Test Steps

### Step 1: Launch App

```bash
flutter run -d macos -v
```

**Expected:**

- App launches successfully
- No errors in console
- You see the Interview Copilot interface
- Both microphone buttons are RED

### Step 2: Click Header Microphone Button

**Action:** Click the microphone button in the top header

**Expected Console Output:**

```
=== Starting Speech Service Initialization ===
Platform: macOS detected
Microphone permission status: PermissionStatus.denied
Requesting microphone permission...
```

**Expected System Dialog:**

```
┌─────────────────────────────────────────┐
│  "hexmac" would like to access the      │
│  microphone.                            │
│                                         │
│  This app needs access to the           │
│  microphone for speech-to-text          │
│  functionality during interviews.       │
│                                         │
│         [Don't Allow]    [OK]           │
└─────────────────────────────────────────┘
```

**Action:** Click **OK**

**Expected Console Output:**

```
Microphone permission result: PermissionStatus.granted
Speech recognition permission status: PermissionStatus.denied
Requesting speech recognition permission...
```

**Expected System Dialog:**

```
┌─────────────────────────────────────────┐
│  "hexmac" would like to use Speech      │
│  Recognition.                           │
│                                         │
│  This app needs access to speech        │
│  recognition to convert your voice to   │
│  text.                                  │
│                                         │
│         [Don't Allow]    [OK]           │
└─────────────────────────────────────────┘
```

**Action:** Click **OK**

**Expected Console Output:**

```
Speech recognition permission result: PermissionStatus.granted
✅ All permissions granted
Initializing speech recognition...
✅ Speech recognition initialized successfully
Started listening...
```

**Expected UI:**

- Button turns GREEN
- White dot appears on button
- Ready to listen

### Step 3: Test Speech Recognition

**Action:** Speak clearly: "What is a goroutine in golang?"

**Expected Console Output:**

```
Speech result: What (final: false)
Speech result: What is (final: false)
Speech result: What is a (final: false)
Speech result: What is a goroutine (final: false)
Speech result: What is a goroutine in golang (final: false)
```

**After 3 seconds of silence:**

```
Speech result: What is a goroutine in golang? (final: true)
Speech recognition status: done
```

**Expected UI:**

- Button turns back to RED
- Message appears in chat as user message
- Loading indicator shows "Asking OPENAI..."
- AI response appears

### Step 4: Test Input Microphone

**Action:** Click the microphone button in the bottom input bar

**Expected:**

- Button turns GREEN immediately (permissions already granted)
- White dot appears
- No permission dialogs (already granted)

**Action:** Speak: "Explain closures in JavaScript"

**Expected:**

- Text appears in input field in real-time
- Partial results update as you speak
- After 3 seconds of silence, final text is in field
- Button turns back to RED
- You can edit the text
- Click send to submit

## What If It Fails?

### Scenario A: No Permission Dialog Appears

**Problem:** You click the button but no system dialog shows up

**Debug:**

```bash
# Check console for errors
# Look for: "Error initializing speech service"

# Check if app has Info.plist
./check_permissions.sh
```

**Fix:**

```bash
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter run -d macos
```

### Scenario B: Permission Denied in Console

**Console shows:**

```
❌ Microphone permission denied
```

**Fix:**

1. Open System Settings
2. Privacy & Security → Microphone
3. Enable "hexmac"
4. Restart app

### Scenario C: Button Stays Red

**Problem:** Button doesn't turn green after granting permissions

**Debug:**

```bash
# Check console for:
# "✅ Speech recognition initialized successfully"
# "Started listening..."
```

**If missing, check:**

- Internet connection (required for speech recognition)
- Microphone is connected and working
- Try in Voice Memos app first

### Scenario D: No Speech Recognition

**Problem:** Button turns green but no text appears

**Debug:**

- Check internet connection
- Speak louder and clearer
- Check console for "Speech result:" messages
- Verify microphone works in other apps

## Success Criteria

✅ **All tests pass when:**

1. Permission dialogs appear on first click
2. Both permissions granted successfully
3. Console shows "✅ All permissions granted"
4. Button turns green when clicked
5. White dot appears when listening
6. Speech is converted to text
7. Header mic sends to AI automatically
8. Input mic fills text field
9. No errors in console
10. Can toggle mics on/off repeatedly

## Verification Commands

After testing, verify everything is working:

```bash
# Check permissions are granted
./check_permissions.sh

# Should show:
# ✓ NSMicrophoneUsageDescription found
# ✓ NSSpeechRecognitionUsageDescription found
# ✓ Audio input entitlement found
```

## Reset for Next Test

To test again from scratch:

```bash
# Reset permissions
tccutil reset Microphone
tccutil reset SpeechRecognition

# Restart app
flutter run -d macos
```

You'll see the permission dialogs again.

---

**Expected Total Time:** 2-3 minutes for complete test
**Success Rate:** Should be 100% if all setup is correct
